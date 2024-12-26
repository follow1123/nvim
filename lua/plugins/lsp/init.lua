return {
  {
    -- neovim开发提示
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    }
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim", -- lsp包管理器
      "williamboman/mason-lspconfig.nvim", -- 包管理器整合插件
    },
    config = function()
      local lspconfig = require("lspconfig")

      require("plugins.lsp.lsp-status"):init()

      -- mason 管理窗口图标配置
      require("mason").setup({
        ui = {
          height = 0.7,
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "ts_ls" },
        handlers = {
          function(server_name)
            local success, client_config = pcall(require, "plugins.lsp.services." .. server_name)
            client_config = success and client_config or {}

            if not client_config.on_attach then
              client_config.on_attach = require("plugins.lsp.keymap")
            end
            if not client_config.capabilities then
              client_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
            end

            lspconfig[server_name].setup(client_config)
          end,
        }
      }
      -- 代码诊断ui相关
      vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          source = "if_many",
        },
      })
    end
  }
}
