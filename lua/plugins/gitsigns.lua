return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  init = function()
    vim.api.nvim_create_autocmd("BufWinEnter", {
      desc = "set gitsigns buffer nomodifiable",
      group = vim.api.nvim_create_augroup("gitsigns options", { clear = true }),
      pattern = "gitsigns://*",
      command = "setlocal nomodifiable"
    })
  end,
  opts = {
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
    on_attach = function(buf)
      local km = vim.keymap.set
      local gitsigns = require('gitsigns')

      ---@param diff_mode_key string
      ---@param direction "first"|"last"|"next"|"prev"
      local function hunk_navigation(diff_mode_key, direction)
        if vim.wo.diff then
          vim.cmd.normal({ diff_mode_key, bang = true })
        else
          gitsigns.nav_hunk(direction, { preview = true })
        end
      end

      -- hunk移动
      km("n", "]c", function() hunk_navigation("]c", "next") end, { desc = "git(Gitsigns): Next hunk", buffer = buf })
      km("n", "[c", function() hunk_navigation("[c", "prev") end,
        { desc = "git(Gitsigns): Previous hunk", buffer = buf })
      -- 重置
      km("n", "<leader>gr", gitsigns.reset_hunk, { desc = "git(Gitsigns): Reset hunk", buffer = buf })
      km("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git(Gitsigns): Reset buffer", buffer = buf })
      km("v", "<leader>gr", function() gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
        { desc = "git(Gitsigns): Reset hunk", buffer = buf })
      km("n", "<leader>gb", function() gitsigns.blame_line { full = true } end,
        { desc = "git(Gitsigns): Preview blame line", buffer = buf })
      km("n", "<leader>gd", function() gitsigns.diffthis(nil, { split = "belowright" }) end,
        { desc = "git(Gitsigns): Diff this", buffer = buf })
    end
  }
}
