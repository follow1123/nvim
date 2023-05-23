-- 文件树插件

-- 定位到当前的工作目录
local function restore_nvim_tree()
	local nvim_tree = require("nvim-tree")
	nvim_tree.change_dir(vim.fn.getcwd())
	-- nvim_tree.refresh()
end

return {
	"kyazdani42/nvim-tree.lua",
	keys = {
		-- 在文件树内定位当前文件
		{ "<A-1>",     ":NvimTreeFindFileToggle<CR>", desc = "NvimTreeFindFileToggle" },
		-- 定位到当前的工作目录
		{ "<leader>t", restore_nvim_tree,             desc = "local current working dir" },
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
