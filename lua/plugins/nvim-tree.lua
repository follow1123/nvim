-- 文件树插件
return {
	'kyazdani42/nvim-tree.lua',
	event = "VeryLazy",
	config = function()
		-- 默认打开文件树快捷键
		require('util').n('<A-1>', ':NvimTreeToggle<CR>')
		-- 在文件树内定位当前文件
		.n("<S-Tab>", ":NvimTreeFindFileToggle<CR>")
		-- 插件配置
		-- local api = require("nvim-tree.api")
		require("nvim-tree").setup{
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
