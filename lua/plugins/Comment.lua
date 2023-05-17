-- 注释插件
return {
	'numToStr/Comment.nvim',
	event = "VeryLazy",
	config = function()
		require('Comment').setup{
			toggler = {
				-- normal 模式下注释快捷键
				line = '<A-e>',
				---Block-comment toggle keymap
				-- block = 'gbc',
			},
			opleader = {
				-- visual 模式下注释快捷键
				line = '<A-e>',
				---Block-comment keymap
				-- block = 'gb',
			},
		}
	end
}
