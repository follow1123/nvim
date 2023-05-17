-- 搜索插件
return {
	-- 搜索依赖插件
	{
		'nvim-lua/plenary.nvim',
		-- enabled = false,
		event = "VeryLazy",
	},
	{
		'nvim-telescope/telescope.nvim',
		-- enabled = false,
		event = "VeryLazy",
		version = '0.1.x',
		dependencies = {{'nvim-lua/plenary.nvim'}},
		config = function()
			local builtin = require('telescope.builtin')
			require('util')
			.n('<C-f>', builtin.find_files)
			.n('<leader>fg', builtin.live_grep)
			.n('<leader>fb', builtin.buffers)
			.n('<leader>fh', builtin.help_tags)
			require('telescope').setup {
				defaults = {
					-- Default configuration for telescope goes here:
					-- config_key = value,
					mappings = {
						i = {
							-- map actions.which_key to <C-h> (default: <C-/>)
							-- actions.which_key shows the mappings for your picker,
							-- e.g. git_{create, delete, ...}_branch for the git_branches picker
							["<C-h>"] = "which_key"
						}
					}
				},
			}
		end
	}
}
