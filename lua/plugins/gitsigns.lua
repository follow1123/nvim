return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = function()
    require("gitsigns").setup {
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      preview_config = { border = "none" },
      on_attach = function(bufnr)
        local map = require("utils.keymap").map
        local gitsigns = require('gitsigns')

        ---@param diff_mode_key string
        ---@param direction "first"|"last"|"next"|"prev"
        local function hunk_navigation(diff_mode_key, direction)
           if vim.wo.diff then
             vim.cmd.normal({diff_mode_key, bang = true})
           else
             gitsigns.nav_hunk(direction, { preview = true })
           end
        end

        -- hunk移动
        map("n", "]c", function() hunk_navigation("]c", "next") end, "git(Gitsigns): Next hunk", bufnr)
        map("n", "[c", function() hunk_navigation("[c", "prev") end, "git(Gitsigns): Previous hunk", bufnr)
        -- 重置
        map("n", "<leader>gr", gitsigns.reset_hunk, "git(Gitsigns): Reset hunk", bufnr)
        map("n", "<leader>gR", gitsigns.reset_buffer, "git(Gitsigns): Reset buffer", bufnr)
        map("v", "<leader>gr", function() gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, "git(Gitsigns): Reset hunk", bufnr)
        map("n", "<leader>gb", function() gitsigns.blame_line{full=true} end, "git(Gitsigns): Preview blame line", bufnr)
        map("n", "<leader>gd", function() gitsigns.diffthis(nil, { split = "belowright" }) end, "git(Gitsigns): Diff this", bufnr)
      end
    }

    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "gitsigns://*",
      command = "setlocal nomodifiable"
    })
  end
}
