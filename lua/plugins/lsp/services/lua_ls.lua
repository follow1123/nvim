-- lua lsp 配置
local config = {
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

local service_name = "lua_ls"

--- 判断当前路径是否是配置路径或则插件路径
local function is_neovim_config_dir()
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
  -- print("start config neodev")
  local ok, m = pcall(require, "neodev")
  if ok then
    m.setup()
    config.settings.Lua.workspace.library = vim.list_extend(vim.api.nvim_get_runtime_file("", true), {"${3rd}/luassert/library", "${3rd}/luv/library"})
    -- 清除所有诊断信息
    vim.diagnostic.reset()
  end
end

config.on_attach = function (_, bufnr)

  require("plugins.lsp.keymap").setup(bufnr)

  -- print("enter attach method")
  if is_neovim_config_dir() then
    -- print("config neodev")
    vim.schedule_wrap(neodev)()
  end
end

-- 使用Neodev直接开启neodev功能
vim.api.nvim_create_user_command("Neodev", function ()
  neodev()
  local clients = vim.lsp.get_active_clients({ name = service_name })
  for _, client in ipairs(clients) do
    vim.cmd("LspRestart " .. client.id)
  end
end, {
  desc = "load neodev plugin and add neovim library path"
})

return config

