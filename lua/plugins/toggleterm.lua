-- 浮动终端插件
local plugin = {
	"akinsho/toggleterm.nvim",
	lazy = true,
}

local u = require('util')
-- windwos默认使用powershell，linux默认使用zsh
local def_shell = 'zsh'
if (u.is_windows()) then
	def_shell = 'pwsh'
end
-- 默认终端样式为浮动
local def_direction = 'float'
local def_float_opts = {
	-- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
	border = 'curved',
	-- 默认占终端长宽的90%
	width = math.floor(vim.fn.winwidth('%') * 0.9),
	height = math.floor(vim.fn.winheight('%') * 0.9),
	winblend = 3
	-- zindex = <value>,
}


-- 自定义lazygit配置
function _lazygit_toggle()
	require('toggleterm.terminal').Terminal:new({
		cmd = "lazygit",
		direction = def_direction,
		float_opts = def_float_opts,
		hidden = true
	}):toggle()
end

-- 自定义底部terminal配置
function _bot_term_toggle()
	require('toggleterm.terminal').Terminal:new({
		cmd = def_shell,
		direction = 'horizontal',
		on_open = function()
			vim.o.cmdheight = 0
		end,
		on_close = function()
			vim.o.cmdheight = 1
		end,
		hidden = true
	}):toggle()
end

local toggleterm_map = "<C-\\>"
plugin.keys = {
	{ "<C-\\>",    ":ToggleTerm<CR>",             desc = "toggle terminal" },
	-- leader+g打开lazygit
	{ "<leader>g", ":lua _lazygit_toggle()<CR>",  desc = "toggle lazygit" },
	-- -- alt+4打开底部terminal
	{ "<A-4>",     ":lua _bot_term_toggle()<CR>", desc = "toggle bot terminal" },
}
plugin.config = function()
	-- 默认终端配置
	require('toggleterm').setup {
		open_mapping = toggleterm_map,
		shell = def_shell,
		-- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
		direction = def_direction,
		auto_scroll = true, -- automatically scroll to the bottom on terminal output
		float_opts = def_float_opts
	}
end

return plugin
