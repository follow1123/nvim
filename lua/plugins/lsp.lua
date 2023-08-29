return {
  "neovim/nvim-lspconfig",
  events = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim" -- neovim开发提示
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
    -- 按键映射
    local on_attach = function(_, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<M-r>', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<M-Enter>', vim.lsp.buf.code_action, '[C]ode [A]ction')
      -- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
      nmap("<M-l>", function()
        vim.lsp.buf.format { async = true }
      end, "[F]ormat code")

      -- 诊断相关快捷键
      nmap("<leader>dp", vim.diagnostic.open_float, "open diagnostic float window")
      nmap("<leader>dj", vim.diagnostic.goto_next, "goto next diagnostic")
      nmap("<leader>dk", vim.diagnostic.goto_prev, "goto previous diagnostic")

      local telescope = require("telescope.builtin")

      nmap("<leader>dl", function () -- 列出当前buffer所有的诊断信息
        telescope.diagnostics({
          bufnr = 0
        })
      end, "list all diagnostics in current buffer")
      nmap("<leader>dL", require("telescope.builtin").diagnostics, "list all diagnostics in workspace") -- 列出当前工作区所有的诊断信息
    end

    require("neodev").setup()

    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            settings = servers[server_name],
            on_attach = on_attach,
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
      -- disable virtual text
      -- the message show after the current line.
      virtual_text = false,
      -- show signs
      signs = {
        active = signs,
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }
    vim.diagnostic.config(config)
    -- set the popup window border
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })
  end
}
