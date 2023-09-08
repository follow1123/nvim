return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = function()
    require("gitsigns").setup {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
        delay = 600,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1
      },
      yadm = {
        enable = false
      },
      on_attach = function(bufnr)
        local keymap_uitl = require("utils.keymap")
        local buf_map = keymap_uitl.buf_map

        local gs = package.loaded.gitsigns

        -- hunk移动
        buf_map("n", "]h", function() gs.next_hunk{ preview = true } end, "git: Next hunk", bufnr)
        buf_map("n", "[h", function() gs.prev_hunk{ preview = true } end, "git: Previous hunk", bufnr)
        -- git暂存
        buf_map("n", "<leader>gs", gs.stage_hunk, "git: Stage hunk", bufnr)
        buf_map("n", "<leader>gr", gs.reset_hunk, "git: Reset hunk", bufnr)
        buf_map("v", "<leader>gs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, "git: Stage hunk", bufnr)
        buf_map("v", "<leader>gr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, "git: Reset hunk", bufnr)
        buf_map("n", "<leader>gS", gs.stage_buffer, "git: Stage buffer", bufnr)
        buf_map("n", "<leader>gu", gs.undo_stage_hunk, "git: Undo stage buffer", bufnr)
        buf_map("n", "<leader>gR", gs.reset_buffer, "git: Reset buffer", bufnr)

        -- 预览
        buf_map("n", "<leader>gp", gs.preview_hunk, "git: Preview hunk", bufnr)
        buf_map("n", "<leader>gb", function() gs.blame_line{full=true} end, "git: Preview blame line", bufnr)
        -- gitdiff
        buf_map("n", "<leader>gd", gs.diffthis, "git: Diff this", bufnr)
        buf_map("n", "<leader>gD", function() gs.diffthis("~") end, "git: Diff this", bufnr)
        -- buf_map("n", "<leader>gd", gs.toggle_deleted)
        -- 开关
        buf_map("n", "<leader>g1", gs.toggle_current_line_blame, "git: Toggle current line blame", bufnr)
        -- 文本对象
        buf_map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", "git: Text object select hunk", bufnr)
      end
    }
  end
}
