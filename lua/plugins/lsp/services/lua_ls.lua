-- 参考 `:h vim.lsp.ClientConfig`
---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Both",
        keywordSnippet = "Both",
        postfix = "@",
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  }
}
