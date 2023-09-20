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
  -- 新建终端，新建的终端不被管理，需要手动关闭
  new = function()
    vim.cmd("term " .. shell)
  end
}

-- ######################## 终端事件
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*" .. shell,
  callback = function(t)
    buf_map("t", "<Esc>", [[<C-\><C-n>]], "Quit terminal mode", t.buf)
    buf_map("t", "<M-q>", "<cmd>bdelete!<cr>", "Quit terminal", t.buf)
  end
})

vim.api.nvim_create_autocmd("TermEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.laststatus = 0
    vim.opt_local.cmdheight = 0
  end
})

vim.api.nvim_create_autocmd("TermLeave", {
  pattern = "*",
  callback = function()
    vim.opt_local.laststatus = 2
    vim.opt_local.cmdheight = 1
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
    vim.cmd(string.format("%dsplit term://%s", default_winheight, shell))
    local bufnr = vim.api.nvim_get_current_buf()
    buf_map("t", "<M-4>", term.toggle, "Toggle below terminal", bufnr)
    buf_map("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Move cursor up", bufnr)
    buf_map("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Move cursor left", bufnr)
    buf_map("t", "<C-up>", [[<C-\><C-n><C-w>+i]], "Increase window size", bufnr)
    buf_map("t", "<C-down>", [[<C-\><C-n><C-w>-i]], "Decrease window size", bufnr)
    term.instance = {
      winheight = default_winheight,
      bufnr = bufnr
    }
    -- 由于这个终端是一个分屏的终端，所以需要在离开窗口时也将底部状态栏相关高度设置为0
    vim.api.nvim_create_autocmd("WinLeave", {
      buffer = bufnr,
      callback = function ()
        vim.opt_local.laststatus = 0
        vim.opt_local.cmdheight = 0
      end
    })
  end,
  toggle = function()
    local below_term = term_map.below_term
    local instance = below_term.instance
    -- 没用终端则直接创建
    if not instance or not vim.tbl_contains(vim.api.nvim_list_bufs(),instance.bufnr) then
      below_term.open()
      return
    end
    -- 有则切换终端
    local winid = vim.fn.bufwinid(instance.bufnr)
    if winid > 0 then
      vim.api.nvim_win_close(winid, true) -- 隐藏
    else
      vim.cmd(string.format("%dsplit | buffer %s", instance.winheight, instance.bufnr)) -- 显示
    end
  end
}

-- ######################## 全屏终端
term_map.full_term = {
  open = function ()
    local term = term_map.full_term
    vim.cmd("term " .. shell)
    local bufnr = vim.api.nvim_get_current_buf()
    buf_map("t", "<C-\\>", term.toggle, "Toggle terminal", bufnr)
    print(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    term.instance = {
      bufnr = bufnr
    }
  end,
  toggle = function()
    local term = term_map.full_term
    local instance = term.instance
    local listed_bufs = vim.fn.getbufinfo({buflisted = 1})
    -- 不存在buffer则直接打开
    if not instance or #vim.tbl_filter(function(value) return value.bufnr == instance.bufnr end, listed_bufs) == 0 then
      term.open()
      return
    end
    -- 当前buffer不是term buffer则切换到term buffer
    if vim.api.nvim_get_current_buf() ~= instance.bufnr then
      vim.cmd("b" .. instance.bufnr)
      return
    end
    -- 有其他buffer可以切换则直接切换，没有则提示
    if #listed_bufs > 1 then
      -- 使用按键模拟的方式切换到最近的buffer，使用其他方式会导致切换回cursorline无法显示
      -- 由于已经将<C-\><C-n>映射为<esc>键，所以直接模拟esc键
      vim.api.nvim_input([[<esc><C-^>]])
    else
      vim.notify("no other buffer", vim.log.levels.INFO)
    end
  end
}

-- ######################## lazygit终端
vim.fn.system("lazygit --version")
if vim.v.shell_error == 0 then
  term_map.lazygit_term = {
    open = function ()
      local term = term_map.lazygit_term
      vim.cmd("term lazygit")
      local bufnr = vim.api.nvim_get_current_buf()
      buf_map("t", "<M-q>", "<cmd>bdelete!<cr>", "Quit lazygit", bufnr)
      buf_map("t", "<M-6>", term.toggle, "Toggle lazygit", bufnr)
      term.instance = {
        bufnr = bufnr
      }
    end,
    toggle = function()
      local term = term_map.lazygit_term
      local instance = term.instance
      local listed_bufs = vim.fn.getbufinfo({buflisted = 1})
      -- 不存在buffer则直接打开
      if not instance or #vim.tbl_filter(function(value) return value.bufnr == instance.bufnr end, listed_bufs) == 0 then
        term.open()
        return
      end
      -- 当前buffer不是term buffer则切换到term buffer
      if vim.api.nvim_get_current_buf() ~= instance.bufnr then
        vim.cmd("b" .. instance.bufnr)
        return
      end
      -- 有其他buffer可以切换则直接切换，没有则提示
      if #listed_bufs > 1 then
        -- 使用按键模拟的方式切换到最近的buffer，使用其他方式会导致切换回cursorline无法显示
        vim.api.nvim_input([[<C-\><C-n><C-^>]])
      else
        vim.notify("no other buffer", vim.log.levels.INFO)
      end
    end
  }
end

return terminal
