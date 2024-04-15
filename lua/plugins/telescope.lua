local keymap_uitl = require("utils.keymap")
local lazy_map = keymap_uitl.lazy_map
local colors = require("utils.colors")
-- 搜索插件
return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.x",
  keys = {
    -- 文件搜索相关
    lazy_map("n", "<A-f>", ":Telescope find_files<CR>", "find files"),
    -- visual 模式下搜索选中的文本
    lazy_map("v", "<A-f>", function ()
      require("utils").handle_selected_region_content(function (content)
        if #content > 0 then
          require("telescope.builtin").find_files({ search_file = content[1] })
        end
      end)
    end, "find files in select text"),
    lazy_map("n", "<C-f>", ":Telescope current_buffer_fuzzy_find<CR>", "find in current buffer"),
    lazy_map("n", "<leader>ff", ":Telescope live_grep<CR>", "live grep"),
    -- visual 模式下搜索选中的文本
    lazy_map("v", "<leader>ff", function ()
      require("utils").handle_selected_region_content(function (content)
        if #content > 0 then
          require("telescope.builtin").grep_string({ search = content[1] })
        end
      end)
    end, "grep string in select text"),
    -- 搜索当前光标下的单词
    lazy_map("n", "<leader>fw", ":Telescope grep_string<CR>", "grep string"),
    -- 搜索当前光标下的单词(包括周围的符号)
    lazy_map("n", "<leader>fW", function ()
      local word = vim.fn.expand("<cWORD>")
      require("telescope.builtin").grep_string({ search = word })
    end, "grep string around word"),
    lazy_map("n", "<leader>bf", ":Telescope buffers<CR>", "buffers"),
    lazy_map("n", "<leader>hf", ":Telescope help_tags<CR>", "help tags"),

    -- vim内置帮助相关
    lazy_map("n", "<leader>hc", ":Telescope commands<CR>", "list commands"),
    lazy_map("n", "<leader>hh", ":Telescope highlights<CR>", "list highlights"),
    lazy_map("n", "<leader>hr", ":Telescope registers<CR>", "list registers"),
    lazy_map("n", "<leader>hF", ":Telescope filetypes<CR>", "list filetypes"),
    lazy_map("n", "<leader>hC", ":Telescope colorscheme<CR>", "list colorscheme"),
    lazy_map("n", "<leader>hk", ":Telescope keymaps<CR>", "list keymaps"),
    lazy_map("n", "<leader>ha", ":Telescope autocommands<CR>", "list autocommands"),
  },
  -- 搜索依赖插件
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- local themes = require("telescope.themes")
    local actions = require("telescope.actions")
    -- local state = require("telescope.actions.state")
    -- 搜索相关picker 默认搜索后居中光标
    local function select_default_and_center(prompt_bufnr)
      actions.select_default(prompt_bufnr)
      vim.cmd("normal! zz")
    end

    require("telescope").setup {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = "❯ ",
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next, -- 下一个
            ["<C-k>"] = actions.move_selection_previous, -- 上一个
            ["<M-j>"] = actions.toggle_selection + actions.move_selection_better, -- 标记当前结果为已选择并移动到下一个
            ["<M-k>"] = actions.toggle_selection + actions.move_selection_worse, -- 标记当前结果为已选择并移动到上一个
            ["<C-a>"] = actions.toggle_all, -- 将全部结果标记为已选择

            ["<C-c>"] = actions.close, -- 关闭
            ["<Esc>"] = actions.close, -- 关闭

            ["<C-x>"] = actions.select_horizontal, -- 水平分屏打开
            ["<C-v>"] = actions.select_vertical, -- 垂直分屏打开

            ["<C-u>"] = actions.preview_scrolling_up, -- 预览窗口向上滚动
            ["<C-d>"] = actions.preview_scrolling_down, -- 预览窗口向下滚动

            -- 默认emacs快捷键
            -- ["<C-a>"] =  function () vim.api.nvim_input("<Home>") end,
            ["<C-e>"] =  function () vim.api.nvim_input("<End>") end,
            ["<C-f>"] =  function () vim.api.nvim_input("<Right>") end,
            ["<C-b>"] =  function () vim.api.nvim_input("<Left>") end,
            ["<M-f>"] =  function () vim.api.nvim_input("<C-Right>") end,
            ["<M-b>"] =  function () vim.api.nvim_input("<C-Left>") end,
            ["<C-n>"] = actions.cycle_history_next, -- 历史记录上一个
            ["<C-p>"] = actions.cycle_history_prev, -- 历史记录下一个
          }
        }
      },
      pickers = {
        find_files = { -- 查找文件设置
          previewer = false,
          -- 可选参数 "--path-separator", "/" 修改搜索后的文件分隔符样式
          find_command = { "fd", "--type", "f", "--color", "never" },
        },
        current_buffer_fuzzy_find = { -- 搜索当前buffer设置
          theme = "ivy",
          mappings = {
            i = {
              ["<CR>"] = select_default_and_center
            }
          }
        },
        help_tags = { --搜索帮助设置
          mappings = {
            i = {
              ["<CR>"] = actions.select_vertical, -- 帮助页面默认垂直分屏显示
            }
          }
        },
      },
    }

    require("telescope").load_extension("projects")
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = colors.gray_02 })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.white_03 })
  end
}
