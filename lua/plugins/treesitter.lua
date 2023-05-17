-- 语法高亮插件
return {
	{
		'nvim-treesitter/nvim-treesitter',
		event = "VeryLazy",
		build = ':TSUpdate',
		config = function()
			require('util')
			.n('<leader>l', 'gg=G<C-o>')
			require('nvim-treesitter.configs').setup {
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = { "c", "cpp", "bash", "lua", "vim", "vimdoc", "rust" },
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,
				-- List of parsers to ignore installing (for "all")
				ignore_install = { "javascript" },
				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
				highlight = {
					enable = true,
					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					-- list of language that will be disabled
					-- disable = { "c", "rust" },
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				-- 彩色括号配置
				rainbow = {
					enable = true,
					extended_mode = true,
					max_file_lines = nil,
					colors = {
						'#fac205',
						'#558961',
						'#1c4374',
						'#bf794e',
						'#ff77aa',
					}
				}
			}
		end
	},
	-- 彩色括号插件
	{
		'p00f/nvim-ts-rainbow',
		event = "VeryLazy",
		dependencies = {{
			'nvim-treesitter/nvim-treesitter'
		}}
	}
}
