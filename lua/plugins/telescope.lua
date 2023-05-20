-- 搜索插件
return {
	"nvim-telescope/telescope.nvim",
	version = "0.1.x",
	keys = {
		{"<C-f>", ":Telescope find_files<CR>", desc = "find files" },
		{"<A-f>", ":Telescope live_grep<CR>", desc = "live grep" },
		{"<leader>b", ":Telescope buffers<CR>", desc = "buffers" },
	},
	-- 搜索依赖插件
	dependencies = {"nvim-lua/plenary.nvim"},
	config = function()
		-- local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		require("telescope").setup {
			defaults = {
				-- Default configuration for telescope goes here:
				-- config_key = value,
				mappings = {
					i = {
						-- map actions.which_key to <C-h> (default: <C-/>)
						-- actions.which_key shows the mappings for your picker,
						-- e.g. git_{create, delete, ...}_branch for the git_branches picker
						-- ["<C-h>"] = "which_key",
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					}
				}
			},
		}
	end
}
