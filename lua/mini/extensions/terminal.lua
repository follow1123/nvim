local terminal = {}

local keymap_util = require("mini.utils").keymap
local buf_map = keymap_util.buf_map

vim.api.nvim_create_autocmd({"WinEnter", "BufWinEnter"}, {
	pattern = "term://*pwsh",
  command = "startinsert!"
})

local function open_below_terminal()
  local below_term = {
    winheight = 15
  }
  vim.cmd(string.format("%dsplit term://pwsh", below_term.winheight))
  below_term.bufnr = vim.api.nvim_get_current_buf()
  buf_map("t", "<M-4>", terminal.toggle_below, "Toggle below terminal", below_term.bufnr)
  buf_map("t", "<Esc>", [[<C-\><C-n>]], "Toggle below terminal", below_term.bufnr)
  buf_map("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Move cursor left", below_term.bufnr)
  buf_map("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Move cursor up", below_term.bufnr)
  buf_map("t", "<C-up>", [[<C-\><C-n><C-w>+i]], "Increase window size", below_term.bufnr)
  buf_map("t", "<C-down>", [[<C-\><C-n><C-w>-i]], "Decrease window size", below_term.bufnr)
  buf_map("t", "<M-q>", terminal.close_below_terminal , "Decrease window size", below_term.bufnr)
  terminal.below_term = below_term
end

terminal.close_below_terminal = function()
  local below_term = terminal.below_term
  if below_term and vim.tbl_contains(vim.api.nvim_list_bufs(), below_term.bufnr) then
    vim.cmd("bdelete! " .. below_term.bufnr)
  end
end

terminal.toggle_below = function ()
  local below_term = terminal.below_term
  if below_term and vim.tbl_contains(vim.api.nvim_list_bufs(), below_term.bufnr) then
    local winnr = vim.fn.bufwinnr(below_term.bufnr)
    if winnr > 0 then
      below_term.winheight = vim.fn.winheight(winnr)
      vim.cmd("quit " .. winnr)
    else
      vim.cmd(string.format("%dsplit | buffer %s", below_term.winheight, below_term.bufnr))
    end
  else
    open_below_terminal()
  end

end

return terminal
