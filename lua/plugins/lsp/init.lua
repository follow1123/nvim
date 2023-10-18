local ft_lsp= {
  lua = "lua_ls",
  rust = "rust_analyzer",
  c = "clangd",
  cpp = "clangd",
}

if _G.IS_WINDOWS then
  ft_lsp["ps1"] = "powershell_es"
end

return {
  {"folke/neodev.nvim", lazy = true}, -- neovim开发提示
  {
    "neovim/nvim-lspconfig",
    ft = vim.tbl_keys(ft_lsp),
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", tag = "legacy", },  -- 右下角lsp服务提示
    },
    config = function()
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
        ensure_installed = vim.tbl_values(ft_lsp),
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup {
              settings = require("plugins.lsp.lang.lua_ls").settings, -- lua lsp配置
              on_attach = require("plugins.lsp.keymap").on_attach, -- keymap配置
              capabilities = require('cmp_nvim_lsp').default_capabilities() -- lsp补全配置
            }
          end,
        }
      })
      -- 修改默认提示符号
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end
      -- set the style of lsp info
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
