-- 浮动终端插件
local utils = require("utils")
-- windwos默认使用powershell，linux默认使用zsh
local def_shell = utils.is_windows() and "pwsh" or "zsh"
-- 获取窗口宽度，用于动态计算终端的长宽
local function get_width()
	return math.floor(vim.fn.winwidth("%") * 0.9)
end
local function get_height()
	return math.floor(vim.fn.winheight("%") * 0.9)
end

-- 默认终端样式为浮动
local def_direction = "float"

local def_float_opts = {
	-- border = "single" | "double" | "shadow" | "curved" | ... other options supported by win open
	border = "curved",
	-- 默认占终端长宽的90%
	width = get_width,
	height = get_height,
	winblend = 3
	-- zindex = <value>,
}

-- terminal插件相关扩展方法
pg.terminal = {}
-- 自定义lazygit配置
pg.terminal.lazygit_toggle = function()
	require("toggleterm.terminal").Terminal:new({
		cmd = "lazygit",
		direction = def_direction,
		float_opts = def_float_opts,
		hidden = true
	}):toggle()
end
-- 自定义底部terminal配置
pg.terminal.bot_term_toggle = function()
	require("toggleterm.terminal").Terminal:new({
		cmd = def_shell,
		direction = "horizontal",
		on_open = function()
			vim.o.cmdheight = 0
		end,
		on_close = function()
			vim.o.cmdheight = 1
		end,
		hidden = true
	}):toggle()
end

require("cmd_panel").create {
	"<leader>g",
	pg.terminal.lazygit_toggle,
	"open lazygit terminal",
	"terminal"
}
local toggleterm_map = "<C-\\>"

return {
	"akinsho/toggleterm.nvim",
	lazy = true,
	keys = {
		{ "<C-\\>",    ":ToggleTerm<CR>",                        desc = "toggle terminal" },
		-- leader+g打开lazygit
		{ "<leader>g", ":lual pg.terminal.lazygit_toggle()<CR>", desc = "toggle lazygit" },
		-- alt+4打开底部terminal
		{ "<A-4>",     ":lua pg.terminal.bot_term_toggle()<CR>", desc = "toggle bot terminal" },
	},

	config = function()
		-- 默认终端配置
		require("toggleterm").setup {
			open_mapping = toggleterm_map,
			shell = def_shell,
			-- direction = "vertical" | "horizontal" | "tab" | "float",
			direction = def_direction,
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
			float_opts = def_float_opts
		}
	end
}
