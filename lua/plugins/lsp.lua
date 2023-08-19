
-- keys.map.lsp = {
-- 	{
-- 		desc = "format",
-- 		mode = "n",
-- 		key = "<A-l>",
-- 		-- command = "=G",
-- 		command = ":lua vim.lsp.buf.format()<CR>",
-- 	},
-- 	{
-- 		desc = "show diagnostic info",
-- 		key = "<leader><F2>",
-- 		command = ":lua vim.diagnostic.open_float()<CR>",
-- 	},
-- 	{
-- 		mapping = false,
-- 		desc = "goto prev diagnostic line",
-- 		-- key = "[d",
-- 		command = ":lua vim.diagnostic.goto_prev()<CR>",
-- 	},
-- 	{
-- 		mapping = false,
-- 		desc = "goto next diagnostic line",
-- 		-- key = "]d",
-- 		command = ":lua vim.diagnostic.goto_next()<CR>",
-- 	},
-- 	{
-- 		desc = "show code action panel",
-- 		key = "<leader><CR>",
-- 		command = ":lua vim.lsp.buf.code_action()<CR>",
-- 	},
-- 	{
-- 		desc = "rename variable",
-- 		key = "<A-r>",
-- 		command = ":lua vim.lsp.buf.rename()<CR>",
-- 	},
-- 	{
-- 		desc = "definition",
-- 		key = "gd",
-- 		command = ":lua vim.lsp.buf.definition()<CR>",
-- 	},
-- }
-- lsp 配置
local plugin = {
	{ "williamboman/mason.nvim",           build = ":MasonUpdate", event = "VeryLazy" },
	{ "williamboman/mason-lspconfig.nvim", event = "VeryLazy" },
	{ 
    "neovim/nvim-lspconfig",
    -- keys = {
    --   { "n", "<M-l>", ":lua vim.lsp.buf.format()<CR>", desc = "lsp format", silent = true }
    --
    -- },
    dependencies = {
      "folke/neodev.nvim"
    },
    event = "VeryLazy" 
  },
}

plugin[1].config = function()
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗"
			}
		}
	})
end

local lua_lib = vim.api.nvim_get_runtime_file("", true)
table.insert(lua_lib, "C:\\Users\\yf\\AppData\\Local\\nvim-data\\mason\\packages\\lua-language-server\\meta\\3rd\\luv\\library")

plugin[2].config = function()

  require("neodev").setup()
	require("mason-lspconfig").setup({
		ensure_installed = { "lua_ls", "rust_analyzer", "clangd" },
	})
	-- Setup language servers.
	local lspconfig = require("lspconfig")
	-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
	require("mason-lspconfig").setup_handlers({
		function(server_name)
			require("lspconfig")[server_name].setup {}
		end,
		-- Next, you can provide targeted overrides for specific servers.
		["lua_ls"] = function()
			lspconfig.lua_ls.setup {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" }
						},
						workspace = {
							-- 去除lsp提示
              checkThirdParty = false,
							-- Make the server aware of Neovim runtime files
							library = lua_lib
						},
						completion = {
							callSnippet = "Replace",
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					}
				}
			}
		end,
		["rust_analyzer"] = function()
			lspconfig.rust_analyzer.setup {
				settings = {
				}
			}
		end,
		["clangd"] = function()
			lspconfig.clangd.setup {
				settings = {
				}
			}
		end,
	})
end

plugin[3].config = function()
	-- replace the lsp info symbol
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn",  text = "" },
		{ name = "DiagnosticSignHint",  text = "" },
		{ name = "DiagnosticSignInfo",  text = "" },
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

return plugin
