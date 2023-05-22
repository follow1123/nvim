-- 搜索插件
return {
	"nvim-telescope/telescope.nvim",
	version = "0.1.x",
	keys = {
		{"<C-f>", ":Telescope find_files<CR>", desc = "find files" },
		{"<A-f>", ":Telescope live_grep<CR>", desc = "live grep" },
		{"<leader>fb", ":Telescope buffers<CR>", desc = "buffers" },
		{"<leader>fh", ":Telescope help_tags<CR>", desc = "help tags" },
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
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					}
				}
			},
			pickers = {
				find_files = {
					theme = "dropdown",
					previewer = false,
					find_command = { "fd" },
				},
				live_grep = {
					theme = "ivy",
				}
			}
		}
	end
}
