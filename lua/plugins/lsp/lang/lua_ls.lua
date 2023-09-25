-- lua lsp 配置
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

-- 判断当前路径是否是配置路径或则插件路径
local function check_is_config_or_plugin_path()
  local cur_path = vim.fs.normalize(vim.fn.expand("%:p:h"))
  local config_path = vim.fs.normalize(_G.CONFIG_PATH)
  return cur_path == config_path or (#cur_path >= #config_path and string.match(cur_path, "^" .. config_path .. "/")) or
    #vim.fs.find({"lua", "README.md", "LICENSE"}, {
      path = cur_path,
      upward = true,
      limit = 3,
    }) == 3
end

--  开启neodev功能
local function neodev()
  local ok, m = pcall(require, "neodev")
  if ok then
    m.setup()
  end
  require("neodev").setup()
  lua_ls.settings.Lua.workspace.library = vim.list_extend(vim.api.nvim_get_runtime_file("", true), {"${3rd}/luassert/library", "${3rd}/luv/library"})
  vim.cmd("LspRestart")
end

if check_is_config_or_plugin_path() then
  neodev()
end

-- 使用Neodev直接开启neodev功能
vim.api.nvim_create_user_command("Neodev", neodev, {
  desc = "load neodev plugin and add neovim library path"
})

return lua_ls

