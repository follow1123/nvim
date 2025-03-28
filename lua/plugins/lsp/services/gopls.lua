-- 参考 `:h vim.lsp.ClientConfig`
---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line
return {
  on_attach = function(client, bufnr)
    require("plugins.lsp.keymap")(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("auto-format-in-golang-file", { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
        })
      end
    })
  end
}
