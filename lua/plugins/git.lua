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
      on_attach = function(bufnr)
        local map = require("utils.keymap").map
        local gs = package.loaded.gitsigns

        -- hunk移动
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule_wrap(gs.next_hunk){ preview = true }
          return "<Ignore>"
        end, "git(Gitsigns): Next hunk", bufnr, { expr = true })
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule_wrap(gs.prev_hunk){ preview = true }
          return "<Ignore>"
        end, "git(Gitsigns): Previous hunk", bufnr, { expr = true })
        -- 重置
        map("n", "<leader>gr", gs.reset_hunk, "git(Gitsigns): Reset hunk", bufnr)
        map("v", "<leader>gr", function()
          gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
        end, "git(Gitsigns): Reset hunk", bufnr)
        map("n", "<leader>gp", gs.preview_hunk, "git(Gitsigns): Preview hunk", bufnr)
        map("n", "<leader>gb", function()
          gs.blame_line{full=true}
        end, "git(Gitsigns): Preview blame line", bufnr)
        map("n", "<leader>gd", function()
          gs.diffthis(nil, { split = "belowright" })
        end, "git(Gitsigns): Diff this", bufnr)
        -- 文本对象
        map({"o", "x"}, "ih", "<cmd><C-u>Gitsigns select_hunk<cr>",
          "git(Gitsigns): Text object select hunk", bufnr)
      end
    }

    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "gitsigns://*",
      callback = function(e)
        -- 将gitsigns diff窗口设置为不可编辑
        vim.api.nvim_buf_set_option(e.buf, "modifiable", false)
      end
    })

    local colors = require("utils.colors")
    -- gitsign内置颜色配置
    -- 右侧git状态颜色
    vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green_02, bg = "NONE" })
    vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colors.blue_02, bg = "NONE"})
    vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.red_02, bg = "NONE"})
    vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = colors.red_02, bg = "NONE"})
    vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = colors.blue_02, bg = "NONE"})
    vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = colors.green_02, bg = "NONE"})

    -- diff预览框颜色
    vim.api.nvim_set_hl(0, "GitSignsAddInline", { fg = "NONE", bg = colors.green_02 })
    vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { fg = "NONE", bg = colors.red_02 })
    vim.api.nvim_set_hl(0, "GitSignsChangeInline", { fg = "NONE", bg = colors.blue_02 })
  end
}
