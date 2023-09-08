-- 判断当前启动的是文件还是目录
-- 文件树插件
return {
	"kyazdani42/nvim-tree.lua",
  lazy = vim.fn.isdirectory(vim.fn.expand("%:p")) == 0,
  -- nvim打开目录则直接加载插件，否则使用key懒加载
  keys = {
    { "<M-1>", ":NvimTreeFindFileToggle<CR>", desc = "find file in nvim tree", silent = true },
  },
	config = function()
		-- 插件配置
		-- local api = require("nvim-tree.api")
		require("nvim-tree").setup {
      disable_netrw = true, -- 禁用默认netrw插件，已在plugin_init文件内禁用
      hijack_netrw = true, -- 使用nvim-tree代替netrw
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
      renderer = {
        indent_markers = {
          enable = true, -- 开启目录树的缩进线
        },
      }
    }
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#1e1e1e" })
  end
}
