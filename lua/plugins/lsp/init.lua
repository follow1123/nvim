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
      -- vue2使用vuels, vue3使用volar
      local services = {
        "lua_ls", "rust_analyzer", "clangd", "tsserver", "vuels"
      }

      -- windows环境下添加powershell语言服务
      if _G.IS_WINDOWS then
        table.insert(services, "powershell_es")
      end

      -- 右下角lsp服务提示配置加载
      require("fidget").setup()
      -- mason图标配置
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

      -- lsp提示窗口配置
      require("lspconfig.ui.windows").default_options.border = "single"

      local lspconfig = require("lspconfig")

      -- lsp默认配置
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        autostart = true,
        -- keymap配置
        on_attach = function (_, bufnr)
          require("plugins.lsp.keymap").setup(bufnr)
        end,
        capabilities = require('cmp_nvim_lsp').default_capabilities() -- lsp补全配置
      })

      require("mason-lspconfig").setup({
        ensure_installed = services,
        handlers = {
          function(service_name)
            -- 查找是否单独定义lsp配置文件，否则使用空配置
            local ok, service_config = pcall(require, "plugins.lsp.services." .. service_name)
            service_config = ok and service_config or {}
            lspconfig[service_name].setup(service_config)
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
      -- 插件加载完成后重新加载当前文件时lsp服务启动
      vim.cmd("silent! e")
    end
  }
}
