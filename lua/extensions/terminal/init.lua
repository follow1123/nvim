-- terminal --------------------------------------------------------------------

local config = require("extensions.terminal.config")
vim.api.nvim_create_autocmd("FileType", {
  pattern = config.filetype,
  group = vim.api.nvim_create_augroup("set-terminal-buffer-options", { clear = true }),
  desc = "terminal: set some options when enter custom terminal buffer",
  callback = vim.schedule_wrap(function(e)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd.startinsert()

    vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
      buffer = e.buf,
      desc = "terminal: enter terminal buffer and start insert",
      command = "startinsert"
    })
  end)
})

local float_shell
local float_lazygit
local scratch_shell

return {
  toggle_float_shell = function(toggle_key)
    if float_shell == nil then
      float_shell = require("extensions.terminal.float_shell"):new(toggle_key)
    end
    float_shell:toggle()
  end,
  toggle_float_lazygit = function(toggle_key)
    if float_lazygit == nil then
      float_lazygit = require("extensions.terminal.float_lazygit"):new(toggle_key)
    end
    float_lazygit:toggle()
  end,
  toggle_scratch_shell = function(toggle_key)
    if scratch_shell == nil then
      scratch_shell = require("extensions.terminal.scratch_shell"):new(toggle_key)
    end
    scratch_shell:toggle()
  end
}
