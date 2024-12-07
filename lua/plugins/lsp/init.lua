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
          border = "single",
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
            if not success then return end
            lspconfig[server_name].setup(client_config)
          end,
        }
      }

      -- lsp 函数签名信息的边框
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "single", }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = "single", }
      )
      -- 代码诊断ui相关
      vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "single",
          source = "if_many",
        },
      })
    end
  }
}
