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
    "mason-org/mason-lspconfig.nvim", -- 包管理器整合插件
    event = "VeryLazy",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          }
        }
      }, -- lsp包管理器
      "neovim/nvim-lspconfig",
      { "j-hui/fidget.nvim", version = "v1.6.x", opts = {} }
    },
    init = require("plugins.lsp.config").setup,
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "ts_ls" }
    },
  }
}
