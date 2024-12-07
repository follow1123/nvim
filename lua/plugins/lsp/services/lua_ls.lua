-- 参考 `:h vim.lsp.ClientConfig`
---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line
return {
  on_attach = require("plugins.lsp.keymap"),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
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

-- function config.on_init(client)
  -- local lib_load_ext_name = "LibLoadExt"
  -- if vim.fn.exists(":" .. lib_load_ext_name) == 2 then return end
  -- vim.api.nvim_create_user_command(lib_load_ext_name,
  --   function()
    --     local clients = vim.lsp.get_clients({
      --       bufnr = vim.api.nvim_get_current_buf(),
      --       name = "lua_ls"
      --     })
      --     if not clients or #clients == 0 then return end
      --
      --     local ext_lib = vim.list_extend(
      --       vim.api.nvim_get_runtime_file("", true),
      --       { "${3rd}/luassert/library", "${3rd}/luv/library" })
      --     if client.settings.Lua.workspace.library then
      --       vim.list_extend(client.settings.Lua.workspace.library, ext_lib)
      --     else
      --       client.settings.Lua.workspace.library = ext_lib
      --     end
      --
      --     vim.diagnostic.reset()
      --     for _, client in ipairs(clients) do
      --       vim.cmd({
        --         cmd = "LspRestart",
        --         args = { client.id }
        --       })
        --     end
        --   end,
        --   { desc = "LSP: Load ext library" }
        -- )
        -- end
