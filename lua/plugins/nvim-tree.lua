local keymap_uitl = require("utils.keymap")
local lazy_map = keymap_uitl.lazy_map
local buf_map = keymap_uitl.buf_map
local del_map = keymap_uitl.del_map
-- 判断当前启动的是文件还是目录
-- 文件树插件
return {
	"kyazdani42/nvim-tree.lua",
  lazy = vim.fn.isdirectory(vim.fn.expand("%:p")) == 0,
  -- nvim打开目录则直接加载插件，否则使用key懒加载
  keys = {
    lazy_map("n", "<M-1>", "<cmd>NvimTreeFindFileToggle<cr>", "nvim-tree: Find file in nvim tree"),
  },
	config = function()
		-- 插件配置
		local api = require("nvim-tree.api")
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
        enable = true,
        show_on_dirs = true,
      },
      diagnostics = {
        enable = true
      },
      actions = {
        file_popup = {
          open_win_config = {
            border = "single" -- 修改文件信息的边框类型
          }
        }
      },
      -- 不显示以.开头的隐藏文件
      filters = {
        dotfiles = true,
      },
      on_attach = function (bufnr)
        -- 默认按键
        api.config.mappings.default_on_attach(bufnr)

        -- 自定义按键 尽量和lf配置一致
        buf_map("n", "<leader>h", api.tree.toggle_help, "nvim-tree: Help", bufnr)

        -- 删除默认的快捷键
        del_map("n", {"d", "y", "Y", "x", "R", "r", "c", "C"}, bufnr)

        -- 文件操作
        buf_map("n", "dd", api.fs.cut, "nvim-tree: Cut", bufnr)
        buf_map("n", "x", api.fs.trash, "nvim-tree: Trash", bufnr)
        buf_map("n", "X", api.fs.remove, "nvim-tree: Remove", bufnr)
        buf_map("n", "<F2>", api.fs.rename_basename, "nvim-tree: Rname basename", bufnr)
        buf_map("n", "R", api.fs.rename, "nvim-tree: Rname", bufnr)
        buf_map("n", "yy", api.fs.copy.node, "nvim-tree: Copy", bufnr)
        buf_map("n", "yn", api.fs.copy.filename, "nvim-tree: Copy name", bufnr)
        buf_map("n", "yp", api.fs.copy.relative_path, "nvim-tree: Copy relative path", bufnr)
        buf_map("n", "yP", api.fs.copy.absolute_path, "nvim-tree: Copy absolute path", bufnr)

        -- 查找
        buf_map("n", "<C-f>", api.live_filter.start, "nvim-tree: Filter file", bufnr)
        buf_map("n", "<Esc>", api.live_filter.clear, "nvim-tree: Filter clean", bufnr)
        -- 其他
        buf_map("n", "r", api.tree.reload, "nvim-tree: Reload", bufnr)
        buf_map("n", "C", api.tree.collapse_all, "nvim-tree: Collapse all", bufnr)


      end,
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = false,
          }
        },
        indent_markers = {
          enable = true, -- 开启目录树的缩进线
        },
        root_folder_label = function(path)
          return "[" .. vim.fn.fnamemodify(vim.fs.normalize(path), ":~:gs?\\(\\w\\)[a-zA-Z0-9 一-龟-]\\+\\ze\\\\?\\1?") .. "]"
        end,
      }
    }
    -- 基础
    vim.api.nvim_set_hl(0, "NvimTreeNormal", {bg = "#1e1e1e"})
    vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", {fg = "#707070"})

    -- 文件
    vim.api.nvim_set_hl(0, "NvimTreeFolderNAme", {fg = "#d4d4d4"})
    vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", {fg = "#d4d4d4"})
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", {fg = "#d4d4d4"})
    vim.api.nvim_set_hl(0, "NvimTreeSymlinkFolderName", {fg = "#d4d4d4"})
    vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", {fg = "#a986c0"})

    -- git
    vim.api.nvim_set_hl(0, "NvimTreeFileDirty", {fg = "#6493b3"})
    vim.api.nvim_set_hl(0, "NvimTreeFileStaged", {fg = "#7dd24f"})
    vim.api.nvim_set_hl(0, "NvimTreeFileMerge", {fg = "#e0ebff"})
    -- vim.api.nvim_set_hl(0, "NvimTreeFileRenamed", {fg = ""})
    vim.api.nvim_set_hl(0, "NvimTreeFileNew", {fg = "#536232"})
    vim.api.nvim_set_hl(0, "NvimTreeFileDeleted", {fg = "Red"})
    vim.api.nvim_set_hl(0, "NvimTreeFileIgnored", {fg = "#3e3e3e", strikethrough = true})

  end
}
