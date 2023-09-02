-- 搜索插件
return {
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
    keys = {
      { "<A-f>",      ":Telescope find_files<CR>",                         desc = "find files" },
      { "<C-f>",      ":Telescope current_buffer_fuzzy_find<CR>",          desc = "find in current buffer" },
      { "<leader>ff", ":Telescope live_grep<CR>",                          desc = "live grep" },
      { "<leader>fb", ":Telescope buffers<CR>",                            desc = "buffers" },
      { "<leader>fh", ":Telescope help_tags<CR>",                          desc = "help tags" },

      -- vim内置帮助相关
      { "<leader>/c", ":Telescope commands<CR>",                           desc = "list commands" },
      { "<leader>/h", ":Telescope highlights<CR>",                         desc = "list highlights" },
      { "<leader>/r", ":Telescope registers<CR>",                          desc = "list registers" },
      { "<leader>/f", ":Telescope filetypes<CR>",                          desc = "list filetypes" },
      { "<leader>/t", ":Telescope colorscheme<CR>",                        desc = "list colorscheme" },
      { "<leader>/k", ":Telescope keymaps<CR>",                            desc = "list keymaps" },
      { "<leader>/a", ":Telescope autocommands<CR>",                       desc = "list autocommands" },
    },
    -- 搜索依赖插件
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- local themes = require("telescope.themes")
      local actions = require("telescope.actions")
      local state = require("telescope.actions.state")
      -- 搜索相关picker 默认搜索后居中光标
      local function select_default_and_center(prompt_bufnr)
        actions.select_default(prompt_bufnr)
        vim.cmd("normal! zz")
      end


      require("telescope").setup {
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "❯ ",
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,                           -- 下一个
              ["<C-k>"] = actions.move_selection_previous,                       -- 上一个

              ["<C-n>"] = actions.cycle_history_next,                            -- 历史记录上一个
              ["<C-p>"] = actions.cycle_history_prev,                            -- 历史记录下一个

              ["<C-c>"] = actions.close,                                         -- 关闭

              ["<C-x>"] = actions.select_horizontal,                             -- 水平分屏打开
              ["<C-v>"] = actions.select_vertical,                               -- 垂直分屏打开

              ["<C-u>"] = actions.preview_scrolling_up,                          -- 预览窗口向上滚动
              ["<C-d>"] = actions.preview_scrolling_down,                        -- 预览窗口向下滚动

              ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist, -- 使用tab或shift tab选中后按ctrl w打开一个窗口单独显示选中的数据
            }
          }
        },
        pickers = {
          find_files = { -- 查找文件设置
            previewer = false,
            find_command = { "fd" },
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
          buffers = {
            mappings = {
              i = {
                ["<M-d>"] = function (prompt_bufnr)
                  local selected_entry = state.get_selected_entry(prompt_bufnr)
                  if selected_entry == nil then
                    actions.close(prompt_bufnr)
                    return
                  end
                  local bufnr = selected_entry.bufnr
                  actions.close(prompt_bufnr)
                  vim.api.nvim_buf_delete(bufnr, { force = true })
                  require("telescope.builtin").buffers() -- 关闭后重新打开
                end
              }
            }
          }
        },
        extensions = {
          file_browser = {
            theme = "ivy",
            hijack_netrw = true,
          },
        }
      }

      require("telescope").load_extension("projects")
      require("telescope").load_extension("file_browser")
    end
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
}
