-- 主题插件
return {
	'doums/darcula',
	-- event = "VeryLazy",
	config = function()
		-- 设置默认主题
		vim.api.nvim_command([[colorscheme darcula]])
	end
}