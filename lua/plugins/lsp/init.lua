
return {
  {"folke/neodev.nvim", lazy = true}, -- neovim开发提示
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim", -- lsp包管理器
      "williamboman/mason-lspconfig.nvim", -- 包管理器整合插件
      { "j-hui/fidget.nvim", tag = "legacy", },  -- 右下角lsp服务提示
    },
    config = function()

      local servers = {
        "lua_ls", "rust_analyzer", "clangd", "tsserver"
      }

      if _G.IS_WINDOWS then
        table.insert(servers, "powershell_es")
      end

      require("fidget").setup()
      require("mason").setup({
        ui = {
          border = "single",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
      require("lspconfig.ui.windows").default_options.border = "single"
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        handlers = {
          function(server_name)
            -- 查找是否单独定义lsp配置文件，否则使用空配置
            local ok, server_conf = pcall(require, "plugins.lsp.lang." .. server_name)
            local settings = ok and server_conf.settings or {}
            require("lspconfig")[server_name].setup {
              settings = settings, -- lua lsp配置
              on_attach = require("plugins.lsp.keymap").on_attach, -- keymap配置
              capabilities = require('cmp_nvim_lsp').default_capabilities() -- lsp补全配置
            }
          end,
        }
      })
      -- 修改代码诊断默认提示符号
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end
      -- 代码诊断ui相关
      local config = {
        virtual_text = false,
        signs = {
          active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "single",
          source = "always",
          header = "",
          prefix = "",
        },
      }
      -- 代码诊断ui相关
      vim.diagnostic.config(config)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
      })
    end
  }
}
