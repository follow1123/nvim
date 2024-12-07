-- 参考 `:h vim.lsp.ClientConfig`
---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line
return {
  root_dir = vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json", ".git" }),
  on_attach = require("plugins.lsp.keymap"),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}
