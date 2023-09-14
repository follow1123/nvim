local lsp = {}

lsp.buf_has_client = function (bufnr)
  return #vim.lsp.get_active_clients({bufnr = bufnr}) ~= 0
end

return lsp
