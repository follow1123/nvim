return {
  "neovim/nvim-lspconfig",
  ft = { "lua", "rust", "ps1" },
  -- events = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim", -- neovim开发提示
    { -- 右下角lsp服务提示
      "j-hui/fidget.nvim",
      tag = "legacy",
    },
  },
  config = function()
    -- 设置lua lsp默认的lib位置
		local lua_lib = vim.api.nvim_get_runtime_file("", true)
    table.insert(lua_lib, "${3rd}/luassert/library")
    table.insert(lua_lib, "${3rd}/luv/library")
    -- lsp 配置
    local servers = {
      lua_ls = {
        Lua = {
          workspace = {
            library = lua_lib
          },
          telemetry = { enable = false },
        },
      },
      rust_analyzer = {

      }
    }

    require("neodev").setup()
    require("fidget").setup()

    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    local keymap = require("plugins.lsp.keymap")
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            settings = servers[server_name],
            on_attach = keymap.on_attach,
            capabilities = require('cmp_nvim_lsp').default_capabilities() -- lsp相关补全
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
