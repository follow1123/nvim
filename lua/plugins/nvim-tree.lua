-- 文件树插件
return {
	"kyazdani42/nvim-tree.lua",
	keys = {
		{ "<M-1>", ":NvimTreeFindFileToggle<CR>", desc = "find file in nvim tree", silent = true },
	},
	config = function()
		-- 插件配置
		-- local api = require("nvim-tree.api")
		require("nvim-tree").setup {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true
      },
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
