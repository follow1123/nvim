local buf = vim.api.nvim_get_current_buf()
local auto_format_group = vim.api.nvim_create_augroup("powershell_auto_format_on_save:" .. buf, { clear = true })


vim.api.nvim_create_autocmd("BufWritePre", {
  group = auto_format_group,
  buffer = buf,
  callback = function()
    vim.lsp.buf.format()
  end
})
