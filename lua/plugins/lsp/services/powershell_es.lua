-- 在 powershell 文件情况下，懒加载会导致 powershell_es 无法启动
-- 这里手动启动一下
if vim.bo.filetype == 'ps1' then
  vim.schedule(function ()
    vim.cmd("LspStart")
  end)
end
-- 参考 `:h vim.lsp.ClientConfig`
---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line
return {
  on_attach = require("plugins.lsp.keymap"),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  -- bundle_path = vim.fs.joinpath(vim.fs.normalize(vim.env.MASON), "packages/powershell-editor-services"),
  settings = { powershell = { codeFormatting = { Preset = 'OTBS' } } },
}
