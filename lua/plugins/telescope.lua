local lazy_map = require("utils.keymap").lazy_map
return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.x",
  cmd = "Telescope",
  keys = {
    -- 文件相关
    lazy_map("n", "<M-f>", "<cmd>Telescope find_files<cr>", "file(Telescope): Find files"),
    lazy_map("n", "<leader>ff", "<cmd>Telescope live_grep<cr>", "file(Telescope): Live grep"),
    -- 根据文件类型搜索
    lazy_map("n", "<leader>ft", function()
      vim.ui.input(
        { prompt = "File type: " },
        function(input)
          local opt = input == nil and {} or { type_filter = vim.trim(input) }
          require("telescope.builtin").live_grep(opt)
        end
      )
    end, "file(Telescope): Live grep by file type"),
    lazy_map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", "file(Telescope): Grep string"),
    -- 搜索当前光标下的单词(包括周围的符号)ind_files
    lazy_map("n", "<leader>fW", function ()
      local word = vim.fn.expand("<cWORD>")
      require("telescope.builtin").grep_string({ search = word })
    end, "file(Telescope): Grep string around word"),
    -- buffer相关
    lazy_map("n", "<leader>bf", "<cmd>Telescope buffers<cr>", "buffer(Telescope): Buffers"),
    lazy_map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", "git(Telescope): Git status"),
    -- help相关
    lazy_map("n", "<leader>hf", "<cmd>Telescope help_tags<cr>", "help(Telescope): Help tags"),
    lazy_map("n", "<leader>hk", "<cmd>Telescope keymaps<cr>", "help(Telescope): List keymaps"),
    lazy_map("n", "<leader>hh", "<cmd>Telescope highlights<cr>", "help(Telescope): List highlights"),
    lazy_map("n", "<leader>hr", "<cmd>Telescope registers<cr>", "help(Telescope): List registers"),
  },
  -- 搜索依赖插件
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = "❯ ",
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        mappings = {
          i = {
            ["<M-n>"] = actions.cycle_history_next, -- 历史记录上一个
            ["<M-p>"] = actions.cycle_history_prev, -- 历史记录下一个
            ["<M-u>"] = actions.preview_scrolling_up, -- 预览窗口向上滚动
            ["<M-d>"] = actions.preview_scrolling_down, -- 预览窗口向下滚动
            ["<M-a>"] = actions.toggle_all, -- 将全部结果标记为已选择

            ["<C-c>"] = actions.close, -- 关闭
            ["<Esc>"] = actions.close, -- 关闭

            -- 部分emacs快捷键
            ["<C-a>"] =  function() vim.api.nvim_input("<Home>") end,
            ["<C-e>"] =  function() vim.api.nvim_input("<End>") end,
            ["<C-f>"] =  function() vim.api.nvim_input("<Right>") end,
            ["<C-b>"] =  function() vim.api.nvim_input("<Left>") end,
            ["<M-f>"] =  function() vim.api.nvim_input("<C-Right>") end,
            ["<M-b>"] =  function() vim.api.nvim_input("<C-Left>") end,
            ["<C-d>"] =  function () vim.api.nvim_input("<Delete>") end,
          }
        }
      },
      pickers = {
        -- 查找文件设置
        find_files = {
          previewer = false,
        },
      },
    }

    require("telescope").load_extension("projects")
    vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "PmenuSel"})
  end
}
