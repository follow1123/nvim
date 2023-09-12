local lua_ls = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Both",
        keywordSnippet = "Both",
        postfix = ".",
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  }
}
-- local curpo = vim.api.nvim_get_runtime_file("", true)
-- for _, value in ipairs(curpo) do
--   print(value)
-- end

-- 在nvim配置路径下的lsp配置 
local pattern = _G.IS_WINDOWS and "\\" or "/"
local config_path = _G.CONFIG_PATH .. pattern
local cur_path = vim.fn.expand("%:p:h") .. pattern

if #cur_path >= #config_path and string.match(cur_path, "^" .. config_path) then
  require("neodev").setup()
  lua_ls.settings.Lua.workspace.library = vim.list_extend(vim.api.nvim_get_runtime_file("", true), {"${3rd}/luassert/library", "${3rd}/luv/library"})
end
return lua_ls

