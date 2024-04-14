local colors = require("utils.colors")
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
    lazy_map("n", "<M-1>", "<cmd>NvimTreeFindFileToggleOrFocus<cr>", "nvim-tree: Find file in nvim tree"),
  },
	config = function()
		-- 插件配置
		local api = require("nvim-tree.api")

    -- 目录树打开时直接获取焦点
    local function nvim_tree_toggle_or_focus()
      local visible_wins = vim.api.nvim_list_wins()
      local cur_win_id = vim.api.nvim_get_current_win()
      local has_nvim_tree = false
      local tree_win_id
      for _, win_id in ipairs(visible_wins) do
        local ft = vim.api.nvim_get_option_value("filetype", {
          win = win_id
        })
        if ft == "NvimTree" then
          has_nvim_tree = true
          tree_win_id = win_id
          break
        end
      end
      if not has_nvim_tree then
        api.tree.toggle {
          find_file = true
        }
        return
      end
      if cur_win_id == tree_win_id then
        api.tree.close()
      else
        api.tree.focus()
      end
    end
    vim.api.nvim_create_user_command("NvimTreeFindFileToggleOrFocus", nvim_tree_toggle_or_focus, {
      desc = "nvim tree toggle or focus"
    })
		require("nvim-tree").setup {
      disable_netrw = true, -- 禁用默认netrw插件，已在plugin_init文件内禁用
      hijack_netrw = true, -- 使用nvim-tree代替netrw
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false
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
        root_folder_label = false -- 不显示root目录
        -- root_folder_label = function(path)
        --   return "[" .. vim.fn.fnamemodify(vim.fs.normalize(path), ":~:gs?\\(\\w\\)[a-zA-Z0-9 一-龟-]\\+\\ze\\\\?\\1?") .. "]"
        -- end,
      }
    }

    -- 文件基础颜色
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = colors.primary }) -- 文件树背景颜色
    vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = colors.gray_03 }) -- 缩进线颜色
    vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = colors.purple_02 }) -- 特殊文件颜色
    vim.api.nvim_set_hl(0, "NvimTreeFolderArrowOpen", { fg = colors.gray_05}) -- 文件夹箭头icon打开颜色
    vim.api.nvim_set_hl(0, "NvimTreeFolderArrowClosed", { fg = colors.gray_05}) -- 文件夹箭头icon关闭颜色

    -- git相关颜色
    vim.api.nvim_set_hl(0, "NvimTreeGitNewIcon", { fg = colors.green_02})
    vim.api.nvim_set_hl(0, "NvimTreeGitRenamedIcon", { fg = colors.green_02})
    vim.api.nvim_set_hl(0, "NvimTreeGitDeletedIcon", { fg = colors.blue_03})
    vim.api.nvim_set_hl(0, "NvimTreeGitDirtyIcon", { fg = colors.blue_03})

    -- 文件夹状态相关颜色
    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = colors.white_03 })
    vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = colors.white_03 })
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = colors.white_03 })
    vim.api.nvim_set_hl(0, "NvimTreeSymlinkFolderName", { fg = colors.white_03 })

  end
}
