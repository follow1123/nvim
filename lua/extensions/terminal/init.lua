-- terminal --------------------------------------------------------------------

local constant = require("extensions.terminal.constant")
vim.api.nvim_create_autocmd("FileType", {
  pattern = constant.term_filetype,
  group = vim.api.nvim_create_augroup("set-terminal-buffer-options", { clear = true }),
  desc = "terminal: set some options when enter custom terminal buffer",
  callback = vim.schedule_wrap(function(e)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false
    vim.cmd.startinsert()

    vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
      buffer = e.buf,
      desc = "terminal: enter terminal buffer and start insert",
      command = "startinsert"
    })
  end)
})

return {
  scratch_term = require("extensions.terminal.scratch_term"):new(),
  lazygit_term = require("extensions.terminal.lazygit_term"):new(),
  task_manager = require("extensions.terminal.task_manager")
}
