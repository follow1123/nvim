-- 参考 `:h vim.lsp.ClientConfig`
---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line
return {
  on_attach = require("plugins.lsp.keymap"),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}
