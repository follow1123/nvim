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

    -- 统一预览窗口的背景颜色
    local popup = require("gitsigns.popup")
    local defalut_impl = popup.create
    ---@diagnostic disable-next-line
    popup.create = function(lines_spec, opts, id)
      local win_id, buf = defalut_impl(lines_spec, opts, id)
      vim.api.nvim_set_option_value("winhighlight", "Normal:Pmenu", {
        win = win_id
      })
      return win_id, buf
    end

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
