-- 文件树插件
return {
	'kyazdani42/nvim-tree.lua',
	event = "VeryLazy",
	config = function()
		-- 默认打开文件树快捷键
		local u = require('util')
		u.m('n', '<A-1>', ':NvimTreeToggle<CR>', {noremap = true})
		-- 插件配置
		require("nvim-tree").setup{
			-- 自动关闭
			-- auto_close = true,
			-- 不显示 git 状态图标
			git = {
				enable = false
			},
			-- 不显示以.开头的隐藏文件
			filters = {
				dotfiles = true,
			},
		}
	end

}
