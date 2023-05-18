-- lsp 配置
local plugin = {
	{ "williamboman/mason.nvim", build = ':MasonUpdate' },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
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

plugin[2].config = function()
	require('mason-lspconfig').setup({
		ensure_installed = { 'lua_ls', 'rust_analyzer' },
	})
	-- Setup language servers.
	local lspconfig = require('lspconfig')
	local opts = { noremap = true, silent = true }
	require('util')
	.m('n', '<leader><F2>', vim.diagnostic.open_float, opts)
	.m('n', '[d', vim.diagnostic.goto_prev, opts)
	.m('n', ']d', vim.diagnostic.goto_next, opts)
	-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
	require("mason-lspconfig").setup_handlers({
		function (server_name)
			require("lspconfig")[server_name].setup{}
		end,
		-- Next, you can provide targeted overrides for specific servers.
		["lua_ls"] = function ()
			lspconfig.lua_ls.setup {
				settings = {
					capabilities = require('cmp_nvim_lsp').default_capabilities(),
					Lua = {
						diagnostics = {
							globals = { "vim" }
						}
					}
				}
			}
		end,
		["rust_analyzer"] = function ()
			lspconfig.rust_analyzer.setup {
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

return plugin
