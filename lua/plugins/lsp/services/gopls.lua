-- 参考 `:h vim.lsp.ClientConfig`
---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line
return {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = {
    gopls = {
      buildFlags = { "-tags=dev" }
    }
  },
}
