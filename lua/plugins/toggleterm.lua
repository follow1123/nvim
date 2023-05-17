-- 浮动终端插件
return {
	'akinsho/toggleterm.nvim',
	version = "*",
	event = "VeryLazy",
	config = function()
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
		-- 默认终端配置
		require('toggleterm').setup{
			open_mapping = [[<C-\>]],
			shell = def_shell,
			-- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
			direction = def_direction,
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
			float_opts = def_float_opts
		}
		local Terminal  = require('toggleterm.terminal').Terminal
		-- 自定义lazygit配置
		local lazygit = Terminal:new({
			cmd = "lazygit",
			direction = def_direction,
			float_opts = def_float_opts,
			hidden = true
		})
		function _lazygit_toggle()
			lazygit:toggle()
		end
		-- leader+g打开lazygit
		u.n("<leader>g", "<cmd>lua _lazygit_toggle()<CR>")
		-- 自定义底部terminal配置
		local bot_term = Terminal:new({
			cmd = def_shell,
			direction = 'horizontal',
			on_open = function()
				-- require('lualine').hide()
				vim.o.cmdheight = 0
			end,
			on_close = function()
				-- require('lualine').hide({unhide=true})
				vim.o.cmdheight = 1
			end,
			hidden = true
		})
		function _bot_term_toggle()
			bot_term:toggle()
		end
		-- alt+4打开lazygit
		u.n("<A-4>", "<cmd>lua _bot_term_toggle()<CR>")
	end
}
