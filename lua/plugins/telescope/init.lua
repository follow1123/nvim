local lazy_map = require("utils.keymap").lazy_map
return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.x",
  cmd = "Telescope",
  keys = {
    lazy_map("n", "<M-f>", "<cmd>Telescope find_files<cr>", "file(Telescope): Find files"),
    lazy_map("n", "<leader>ff", "<cmd>lua require 'plugins.telescope.multigrep'.multigrep()<cr>", "file(Telescope): Multi grep"),
    lazy_map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", "file(Telescope): Grep string"),
    lazy_map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", "git(Telescope): Git status"),
    lazy_map("n", "<leader>hf", "<cmd>Telescope help_tags<cr>", "help(Telescope): Help tags"),
    lazy_map("n", "<leader>hk", "<cmd>Telescope keymaps<cr>", "help(Telescope): List keymaps"),
    lazy_map("n", "<leader>hh", "<cmd>Telescope highlights<cr>", "help(Telescope): List highlights"),
  },
  -- 搜索依赖插件
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup {
      defaults = {
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        mappings = {
          i = {
            ["<M-n>"] = actions.cycle_history_next,     -- 历史记录上一个
            ["<M-p>"] = actions.cycle_history_prev,     -- 历史记录下一个
            ["<M-u>"] = actions.preview_scrolling_up,   -- 预览窗口向上滚动
            ["<M-d>"] = actions.preview_scrolling_down, -- 预览窗口向下滚动
            ["<M-a>"] = actions.toggle_all,             -- 将全部结果标记为已选择
            ["<C-s>"] = actions.select_horizontal,      -- 水平分屏打开

            ["<C-c>"] = actions.close,                  -- 关闭
            ["<Esc>"] = actions.close,                  -- 关闭

            -- 部分emacs快捷键
            ["<C-a>"] = function() vim.api.nvim_input("<Home>") end,
            ["<C-e>"] = function() vim.api.nvim_input("<End>") end,
            ["<C-f>"] = function() vim.api.nvim_input("<Right>") end,
            ["<C-b>"] = function() vim.api.nvim_input("<Left>") end,
            ["<M-f>"] = function() vim.api.nvim_input("<C-Right>") end,
            ["<M-b>"] = function() vim.api.nvim_input("<C-Left>") end,
            ["<C-d>"] = function() vim.api.nvim_input("<Delete>") end,
          }
        }
      },
      pickers = {
        -- 搜索文件时不显示预览窗口
        find_files = {
          borderchars = {
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
          theme = "dropdown",
          previewer = false,
        },
      },
    }

    -- 预览窗口默认较窄，设置折行
    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopePreviewerLoaded",
      group = vim.api.nvim_create_augroup("TELESCOPE_PREVIEWER_LOADED", { clear = true }),
      desc = "set telescope previewer window wrap text",
      command = "setlocal wrap"
    })
  end
}
