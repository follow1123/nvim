-- 文件树插件
return {
	'kyazdani42/nvim-tree.lua',
	keys = {
		-- 默认打开文件树快捷键
		{ "<A-1>", ":NvimTreeToggle<CR>", desc = "NvimTreeToggle"},
		-- 在文件树内定位当前文件
		{ "<S-Tab>", ":NvimTreeFindFileToggle<CR>", desc = "NvimTreeFindFileToggle"},
	},
	config = function()
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
