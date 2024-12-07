return {
  { "folke/neodev.nvim", lazy = true }, -- neovim开发提示
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim", -- lsp包管理器
      "williamboman/mason-lspconfig.nvim", -- 包管理器整合插件
    },
    config = function()
      require("plugins.lsp.lsp-status"):init()

      require("neodev").setup({
        override = function(root_dir, options)
          -- 插件lib未加载并且项目名包含vim的项目加载插件lib
          if not options.plugins and
            string.find(vim.fn.fnamemodify(root_dir, ":t"), "vim") then
            options.plugins = true
          end
        end
      })

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
      -- LspInfo命令窗口边框样式
      require("lspconfig.ui.windows").default_options.border = "single"

      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "rust_analyzer", "clangd" },
        handlers = {
          function(service_name)
            -- 查找是否单独定义lsp配置文件，否则使用空配置
            local def_conf = { on_attach = require("plugins.lsp.keymap") }
            local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if cmp_ok then
              -- lsp补全配置
              def_conf.capabilities = cmp_lsp.default_capabilities()
            end

            local ok, conf = pcall(require, "plugins.lsp.services." .. service_name)
            conf = ok and conf or {}
            conf = vim.tbl_deep_extend("keep", conf, def_conf)

            lspconfig[service_name].setup(conf)
          end,
        }
      }
      --
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
          header = "",
          prefix = "",
        },
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "single", }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = "single", }
      )
    end
  }
}
