-- ###########################
-- #        终端插件         #
-- ###########################
local keymap_util = require("mini.utils").keymap
local buf_map = keymap_util.buf_map

local shell = _G.IS_WINDOWS and "pwsh" or "zsh"

local term_map = {}
local terminal = {
  toggle = function(term_name)
    local term = term_map[term_name]
    if term then
      term.toggle()
    else
      vim.notify(string.format("no '%s' terminal", term_name), vim.log.levels.WARN)
    end
  end,
  send_msg = function (term_name, msg)
    local term = term_map[term_name]
    local instance = term.instance
    if instance and instance.term_id then
      if type(msg) == "table" then
        for _, m in ipairs(msg) do
          vim.api.nvim_chan_send(instance.term_id, m)
        end
      else
        vim.api.nvim_chan_send(instance.term_id, msg)
      end
    end
  end,
  -- 新建终端，新建的终端不被管理，需要手动关闭
  new = function()
    vim.cmd("term " .. shell)
  end
}

local function global_height()
  return vim.api.nvim_get_option("lines")
end

local function global_width()
  return vim.api.nvim_get_option("columns")
end

local full_window_opts = {
    relative = 'editor',
    width = global_width(),
    height = global_height(),
    row = 0,
    col = 0,
    style = 'minimal',
    border = 'none',
}

local function open_full_window(enter, bufnr)
  return vim.api.nvim_open_win(bufnr, enter, full_window_opts)
end

local function create_term_buf()
  local term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
  vim.api.nvim_buf_set_option(term_buf, "filetype", "fterm")
  return term_buf
end

-- ######################## 终端事件
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*" .. shell,
  callback = function(t)
    buf_map("t", "<Esc>", [[<C-\><C-n>]], "Quit terminal mode", t.buf)
  end
})

vim.api.nvim_create_autocmd({"WinEnter", "BufWinEnter"}, {
  pattern = {"term://*" .. shell, "term://*lazygit"},
  command = "startinsert!"
})

-- ######################## 底部终端
term_map.below_term = {
  default_winheight = 15,
  open = function()
    local term = term_map.below_term
    local default_winheight = term.default_winheight
    vim.cmd(string.format("%dsplit", default_winheight))
    local win_id = vim.api.nvim_get_current_win()
    local bufnr = create_term_buf()
    vim.api.nvim_win_set_buf(win_id, bufnr)
    local term_id = vim.fn.termopen(shell, {
      on_exit = function(_, code)
        if code == 0 then
          vim.api.nvim_win_close(term.instance.win_id, true)
          vim.api.nvim_buf_delete(term.instance.bufnr, { force = true })
          term.instance = nil
        end
      end
    })
    buf_map("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Move cursor up", bufnr)
    buf_map("t", "<M-4>", term.toggle, "Toggle below terminal", bufnr)
    buf_map("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Move cursor left", bufnr)
    buf_map("t", "<C-up>", [[<C-\><C-n><C-w>+i]], "Increase window size", bufnr)
    buf_map("t", "<C-down>", [[<C-\><C-n><C-w>-i]], "Decrease window size", bufnr)
    term.instance = {
      winheight = default_winheight,
      bufnr = bufnr,
      term_id = term_id,
      win_id = win_id,
    }
  end,
  toggle = function()
    local term = term_map.below_term
    local instance = term.instance
    -- 不存在buffer则直接打开
    if not instance or not vim.fn.getbufinfo(instance.bufnr) then
      term.open()
      return
    end
    -- 当前buffer不是term buffer则切换到term buffer
    if vim.api.nvim_get_current_buf() == instance.bufnr then
      vim.api.nvim_win_close(instance.win_id, true)
    else
      vim.cmd(string.format("%dsplit | buffer %s", instance.winheight, instance.bufnr)) -- 显示
      instance.win_id = vim.api.nvim_get_current_win()
    end
  end
}

-- ######################## 全屏终端
term_map.full_term = {
  open = function ()
    local term = term_map.full_term
    local bufnr = create_term_buf()
    local win_id = open_full_window(true, bufnr)
    local term_id = vim.fn.termopen(shell, {
      on_exit = function(_, code)
        if code == 0 then
          vim.api.nvim_win_close(term.instance.win_id, true)
          vim.api.nvim_buf_delete(term.instance.bufnr, { force = true })
          term.instance = nil
        end
      end
    })
    buf_map("t", "<C-\\>", term.toggle, "Toggle terminal", bufnr)
    term.instance = {
      bufnr = bufnr,
      term_id = term_id,
      win_id = win_id,
    }
  end,
  toggle = function()
    local term = term_map.full_term
    local instance = term.instance
    -- 不存在buffer则直接打开
    if not instance or not vim.fn.getbufinfo(instance.bufnr) then
      term.open()
      return
    end
    -- 当前buffer不是term buffer则切换到term buffer
    if vim.api.nvim_get_current_buf() == instance.bufnr then
      vim.api.nvim_win_close(instance.win_id, true)
    else
      instance.win_id = open_full_window(true, instance.bufnr)
    end
  end
}

-- ######################## lazygit终端
vim.fn.system("lazygit --version")
if vim.v.shell_error == 0 then
  term_map.lazygit_term = {
    open = function ()
      local term = term_map.lazygit_term
      local bufnr = create_term_buf()
      local win_id = open_full_window(true, bufnr)
      local term_id = vim.fn.termopen("lazygit", {
        on_exit = function(_, code)
          if code == 0 then
            vim.api.nvim_win_close(term.instance.win_id, true)
            vim.api.nvim_buf_delete(term.instance.bufnr, { force = true })
            term.instance = nil
          end
        end
     })
      buf_map("t", "<M-6>", term.toggle, "Toggle lazygit", bufnr)
      term.instance = {
        bufnr = bufnr,
        term_id = term_id,
        win_id = win_id,
      }
    end,
    toggle = function()
      local term = term_map.lazygit_term
      local instance = term.instance
      -- 不存在buffer则直接打开
      if not instance or not vim.fn.getbufinfo(instance.bufnr) then
        term.open()
        return
      end
      -- 当前buffer不是term buffer则切换到term buffer
      if vim.api.nvim_get_current_buf() == instance.bufnr then
        vim.api.nvim_win_close(instance.win_id, true)
      else
        instance.win_id = open_full_window(true, instance.bufnr)
      end
    end
  }
end

return terminal
