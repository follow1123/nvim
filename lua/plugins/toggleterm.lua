-- 浮动终端插件
return {
	'akinsho/toggleterm.nvim',
	version = "*",
	event = "VeryLazy",
	config = function()
		require('util').n('<C-\\>', ':ToggleTerm<CR>')
		-- require('toggleterm').setup()
		require('toggleterm').setup{
			shell = 'pwsh',
			-- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
			direction = 'float',
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
			-- This field is only relevant if direction is set to 'float'
			float_opts = {
				-- The border key is *almost* the same as 'nvim_open_win'
				-- see :h nvim_open_win for details on borders however
				-- the 'curved' border is a custom border type
				-- not natively supported but implemented in this plugin.
				-- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
				border = 'curved',
				-- like `size`, width and height can be a number or function which is passed the current terminal
				-- width = <value>,
				-- height = <value>,
				-- winblend = 3
				-- zindex = <value>,
			}
		}
	end
}
