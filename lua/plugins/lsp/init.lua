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

      -- 统一 lsp 相关弹窗背景颜色
      local default_lsp_window_impl = vim.lsp.util.open_floating_preview
      ---@diagnostic disable-next-line
      vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
        local buf, win_id = default_lsp_window_impl(contents, syntax, opts)
        vim.api.nvim_set_option_value("winhighlight", "Normal:Pmenu", {
          win = win_id
        })
        return buf, win_id
      end

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

      -- 统一诊断窗口背景颜色
      local default_diagnostic_window_impl = vim.diagnostic.open_float
      ---@diagnostic disable-next-line
      vim.diagnostic.open_float = function(opts, ...)
        local buf, win_id = default_diagnostic_window_impl(opts, ...)
        vim.api.nvim_set_option_value("winhighlight", "Normal:Pmenu", {
          win = win_id
        })
        return buf, win_id
      end
    end
  }
}
