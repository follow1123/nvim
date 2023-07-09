-- 浮动终端插件
local toggleterm_map = "<C-\\>"
local o = require("options")
local keys = require("key_mapping").map.terminal

return {
	"akinsho/toggleterm.nvim",
	keys = {
		{ toggleterm_map, "ToggleTerm<CR>", desc = "toggle terminal" },
		{ keys[1].key,    keys[1].callback, desc = keys[1].desc },
		{ keys[3].key,    keys[3].callback, desc = keys[3].desc },
		{ keys[4].key,    keys[4].callback, desc = keys[4].desc },
	},

	config = function()
		-- 默认终端配置
		require("toggleterm").setup {
			open_mapping = toggleterm_map,
			shell = o.terminal.def_shell,
			-- direction = "vertical" | "horizontal" | "tab" | "float",
			direction = o.terminal.def_direction,
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
			float_opts = o.terminal.def_float_opts,
			shading_factor = 0,
		}
	end
}
