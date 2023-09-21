-- 搜索插件
return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.x",
  keys = {
    { "<A-f>",      ":Telescope find_files<CR>",                         desc = "find files" },
    { "<C-f>",      ":Telescope current_buffer_fuzzy_find<CR>",          desc = "find in current buffer" },
    { "<leader>ff", ":Telescope live_grep<CR>",                          desc = "live grep" },
    { "<leader>bf", ":Telescope buffers<CR>",                            desc = "buffers" },
    { "<leader>hf", ":Telescope help_tags<CR>",                          desc = "help tags" },

    -- vim内置帮助相关
    { "<leader>hc", ":Telescope commands<CR>",                           desc = "list commands" },
    { "<leader>hh", ":Telescope highlights<CR>",                         desc = "list highlights" },
    { "<leader>hr", ":Telescope registers<CR>",                          desc = "list registers" },
    { "<leader>hF", ":Telescope filetypes<CR>",                          desc = "list filetypes" },
    { "<leader>hC", ":Telescope colorscheme<CR>",                        desc = "list colorscheme" },
    { "<leader>hk", ":Telescope keymaps<CR>",                            desc = "list keymaps" },
    { "<leader>ha", ":Telescope autocommands<CR>",                       desc = "list autocommands" },
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
            ["<C-j>"] = actions.move_selection_next,                           -- 下一个
            ["<C-k>"] = actions.move_selection_previous,                       -- 上一个

            ["<C-c>"] = actions.close,                                         -- 关闭
            ["<Esc>"] = actions.close,                                         -- 关闭

            ["<C-x>"] = actions.select_horizontal,                             -- 水平分屏打开
            ["<C-v>"] = actions.select_vertical,                               -- 垂直分屏打开

            ["<C-u>"] = actions.preview_scrolling_up,                          -- 预览窗口向上滚动
            ["<C-d>"] = actions.preview_scrolling_down,                        -- 预览窗口向下滚动

            -- 默认emacs快捷键
            ["<C-a>"] =  function () vim.api.nvim_input("<Home>") end,
            ["<C-e>"] =  function () vim.api.nvim_input("<End>") end,
            ["<C-f>"] =  function () vim.api.nvim_input("<Right>") end,
            ["<C-b>"] =  function () vim.api.nvim_input("<Left>") end,
            ["<M-f>"] =  function () vim.api.nvim_input("<C-Right>") end,
            ["<M-b>"] =  function () vim.api.nvim_input("<C-Left>") end,
            ["<C-n>"] = actions.cycle_history_next,                            -- 历史记录上一个
            ["<C-p>"] = actions.cycle_history_prev,                            -- 历史记录下一个
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
      },
    }

    require("telescope").load_extension("projects")
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#4b4b4b" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#d4d4d4" })
  end
}
