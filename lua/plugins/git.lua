return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  init = function()
    -- 进入buffer时判断是否使用git管理，有则加载gitsigns插件
    vim.api.nvim_create_autocmd("BufReadPre", {
      pattern = "*",
      callback = function()
        if package.loaded["gitsigns"] then
          return
        end
        local git_path = vim.fs.find(".git", {
          upward = true,
          type = "directory",
          path = vim.fn.expand("%:p:h")
        })
        if #git_path > 0 then
          require("gitsigns")
        end
      end
    })
  end,
  config = function()
    -- 清理Windows下的\r符号
    local function clear_windows_end_char()
      vim.cmd([[silent %s/\r$//g]])
    end
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
				buf_map("n", "]c", function()
					if vim.wo.diff then return "]c" end
					vim.schedule(function() gs.next_hunk{preview = true} end)
					return "<Ignore>"
				end, { expr = true, desc = "git: Next hunk" }, bufnr)

       buf_map("n", "[c", function()
					if vim.wo.diff then return "[c" end
					vim.schedule(function() gs.prev_hunk{preview = true} end)
					return "<Ignore>"
				end, { expr = true, desc = "git: Previous hunk" }, bufnr)
        -- git暂存
        buf_map("n", "<leader>gs", gs.stage_hunk, "git: Stage hunk", bufnr)
        buf_map("n", "<leader>gr", gs.reset_hunk, "git: Reset hunk", bufnr)
        buf_map("v", "<leader>gs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, "git: Stage hunk", bufnr)
        buf_map("v", "<leader>gr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, "git: Reset hunk", bufnr)
        buf_map("n", "<leader>gS", gs.stage_buffer, "git: Stage buffer", bufnr)
        buf_map("n", "<leader>gu", gs.undo_stage_hunk, "git: Undo stage buffer", bufnr)
        buf_map("n", "<leader>gR", function()
          gs.reset_buffer()
          if _G.IS_WINDOWS then
            clear_windows_end_char()
          end
        end, "git: Reset buffer", bufnr)

        -- 预览
        buf_map("n", "<leader>gp", gs.preview_hunk, "git: Preview hunk", bufnr)
        buf_map("n", "<leader>gb", function() gs.blame_line{full=true} end, "git: Preview blame line", bufnr)
        -- gitdiff
        buf_map("n", "<leader>gd", function() gs.diffthis(nil, {
          split = "belowright"
        }) end, "git: Diff this", bufnr)
        -- buf_map("n", "<leader>gd", gs.toggle_deleted)
        -- 开关
        buf_map("n", "<leader>g1", gs.toggle_current_line_blame, "git: Toggle current line blame", bufnr)
        -- 文本对象
        buf_map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", "git: Text object select hunk", bufnr)
      end
    }

    if _G.IS_WINDOWS then
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "gitsigns://*",
        callback = function(e)
          local bufnr = e.buf
          local buf_map = require("utils.keymap").buf_map
          vim.api.nvim_buf_call(bufnr, clear_windows_end_char)
          vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
          buf_map("n", "<M-q>", "<cmd>q!<cr>", "quit not write", bufnr)
        end
      })
    end
    -- diff设置
    -- diff颜色加深版
    -- Add #536232 Change #1c7ca1 Delete #771b1b
    vim.api.nvim_set_hl(0, "DiffAdd", { fg = "", bg = "#414733" })
    vim.api.nvim_set_hl(0, "DiffChange", { fg = "", bg = "#215e76" })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "", bg = "#552222" })
    vim.api.nvim_set_hl(0, "DiffText", { fg = "", bg = "#414733" })
    -- gitsign内置颜色配置
    vim.api.nvim_set_hl(0, "GitSignsAddInline", { fg = "", bg = "#536232" })
    vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { fg = "", bg = "#771b1b" })
    vim.api.nvim_set_hl(0, "GitSignsChangeInline", { fg = "", bg = "#1c7ca1" })
  end
}
