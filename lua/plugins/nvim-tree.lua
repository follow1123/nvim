-- 文件树插件
local keys = require("key_mapping").map.nvim_tree
return {
	"kyazdani42/nvim-tree.lua",
	keys = {
		{ keys[1].key, keys[1].command, desc = keys[1].desc },
		{ keys[2].key, keys[2].command, desc = keys[2].desc },
	},
	config = function()
		-- 插件配置
		-- local api = require("nvim-tree.api")
		require("nvim-tree").setup {
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
