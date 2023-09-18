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

  end
}

local function hide_status_line()
  vim.opt_local.laststatus = 0
  vim.opt_local.cmdheight = 0
end

local function show_status_line()
  vim.opt_local.laststatus = 2
  vim.opt_local.cmdheight = 1
end

local function close_terminal(term)
  local instance = term.instance
  if instance and vim.tbl_contains(vim.api.nvim_list_bufs(), instance.bufnr) then
    vim.cmd("bdelete! " .. instance.bufnr)
    term.instance = nil
    show_status_line()
  end
end

local function toggle_terminal(term)
  local instance = term.instance
  if instance and vim.tbl_contains(vim.api.nvim_list_bufs(), instance.bufnr) then
    local listed_buf = vim.fn.getbufinfo({buflisted = 1})
    local cur_bufnr = vim.api.nvim_get_current_buf()
    if cur_bufnr == instance.bufnr then
      if #listed_buf > 1 then
        vim.cmd("b#")
        show_status_line()
      else
        vim.notify("no other buffer", vim.log.levels.INFO)
      end
    else
      vim.cmd("b" .. instance.bufnr)
      hide_status_line()
    end
  else
    term.open()
    hide_status_line()
  end
end


vim.api.nvim_create_autocmd({"WinEnter", "BufWinEnter"}, {
  pattern = {"term://*" .. shell, "term://*lazygit", "term://*lf"},
  command = "startinsert!"
})

-- ######################## 底部终端
term_map.below_term = {
  default_winheight = 15,
}

term_map.below_term.open = function()
  local term = term_map.below_term
  local default_winheight = term.default_winheight
  vim.cmd(string.format("%dsplit term://%s", default_winheight, shell))
  local bufnr = vim.api.nvim_get_current_buf()
  buf_map("t", "<M-4>", term.toggle, "Toggle below terminal", bufnr)
  buf_map("t", "<Esc>", [[<C-\><C-n>]], "Toggle below terminal", bufnr)
  buf_map("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Move cursor up", bufnr)
  buf_map("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Move cursor left", bufnr)
  buf_map("t", "<C-up>", [[<C-\><C-n><C-w>+i]], "Increase window size", bufnr)
  buf_map("t", "<C-down>", [[<C-\><C-n><C-w>-i]], "Decrease window size", bufnr)
  buf_map("t", "<M-q>", term.close, "Close terminal", bufnr)
  term.instance = {
    winheight = default_winheight,
    bufnr = bufnr
  }
end

term_map.below_term.close = function()
  local instance = term_map.below_term.instance
  if instance and vim.tbl_contains(vim.api.nvim_list_bufs(), instance.bufnr) then
    vim.cmd("bdelete! " .. instance.bufnr)
    term_map.below_term.instance = nil
    show_status_line()
  end
end

term_map.below_term.toggle = function()
  local below_term = term_map.below_term
  local instance = below_term.instance
  if instance and vim.tbl_contains(vim.api.nvim_list_bufs(), instance.bufnr) then
    local winnr = vim.fn.bufwinnr(instance.bufnr)
    if winnr > 0 then
      vim.cmd("quit " .. winnr)
      show_status_line()
    else
      vim.cmd(string.format("%dsplit | buffer %s", instance.winheight, instance.bufnr))
      hide_status_line()
    end
  else
    below_term.open()
    hide_status_line()
  end
end

-- ######################## 全屏终端
--TODO 打开这个终端后切换回去光标行不见了
term_map.full_term = {}

term_map.full_term.open = function ()
  local term = term_map.full_term
  vim.cmd("term " .. shell)
  local bufnr = vim.api.nvim_get_current_buf()
  buf_map("t", "<C-\\>", term.toggle, "Toggle terminal", bufnr)
  buf_map("t", "<Esc>", [[<C-\><C-n>]], "Toggle below terminal", bufnr)
  buf_map("t", "<M-q>", term.close, "Close terminal", bufnr)
  term.instance = {
    bufnr = bufnr
  }
end

term_map.full_term.close = function()
  close_terminal(term_map.full_term)
end

term_map.full_term.toggle = function()
  toggle_terminal(term_map.full_term)
end

-- ######################## lazygit终端
vim.fn.system("lazygit --version")
if vim.v.shell_error == 0 then
  term_map.lazygit_term = {}
  term_map.lazygit_term.open = function ()
    local term = term_map.lazygit_term
    vim.cmd("term lazygit")
    local bufnr = vim.api.nvim_get_current_buf()
    buf_map("t", "<M-q>", term.close, "Close lazygit terminal", bufnr)
    buf_map("t", "<M-6>", term.toggle, "Toggle lazygit terminal", bufnr)
    -- buf_map("t", "q", term.close, "Close lazygit terminal", bufnr)
    term.instance = {
      bufnr = bufnr
    }
  end

  term_map.lazygit_term.close = function()
    close_terminal(term_map.lazygit_term)
  end

  term_map.lazygit_term.toggle = function()
    toggle_terminal(term_map.lazygit_term)
  end
end


-- ######################## lazygit终端
vim.fn.system("lf --version")
if vim.v.shell_error == 0 then
  term_map.lf_term = {}
  term_map.lf_term.open = function ()
    local term = term_map.lf_term
    vim.cmd("term lf")
    local bufnr = vim.api.nvim_get_current_buf()
    buf_map("t", "<M-q>", term.close, "Close lf terminal", bufnr)
    buf_map("t", "<M-7>", term.toggle, "Toggle lf terminal", bufnr)
    term.instance = {
      bufnr = bufnr
    }
  end

  term_map.lf_term.close = function()
    close_terminal(term_map.lf_term)
  end

  term_map.lf_term.toggle = function()
    toggle_terminal(term_map.lf_term)
  end
end

return terminal
