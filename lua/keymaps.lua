-- keymaps --------------------------------------------------------------------
local km = vim.keymap.set

-- 禁用翻页键
km("n", "<C-f>", "<Nop>", { desc = "base: Disable pagedown key" })
km("n", "<C-b>", "<Nop>", { desc = "base: Disable pageup key" })

-- window ---------------------------------------------------------------------
km("n", "<C-h>", "<C-w>h", { desc = "base: Move cursor to left window" })
km("n", "<C-l>", "<C-w>l", { desc = "base: Move cursor to right window" })
km("n", "<C-j>", "<C-w>j", { desc = "base: Move cursor to above window" })
km("n", "<C-k>", "<C-w>k", { desc = "base: Move cursor to below window" })
km("n", "<M-q>", "<C-w>c", { desc = "base: Close current window" })

-- search ---------------------------------------------------------------------
-- 搜索历史
km("n", "n", "'Nn'[v:searchforward]", { desc = "base: Next search result", expr = true })
km("n", "N", "'nN'[v:searchforward]", { desc = "base: Prev search result", expr = true })

-- 清除搜索的高亮文本
km({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "base: Clear lighlight search" })

-- 添加保存存档点
km("i", ",", ",<c-g>u", { desc = "base: Add undo break points" })
km("i", ".", ".<c-g>u", { desc = "base: Add undo break points" })
km("i", ";", ";<c-g>u", { desc = "base: Add undo break points" })

-- 翻页时保持光标居中
km("n", "<C-d>", "<C-d>zz", { desc = "base: Scroll down and center cursor" })
km("n", "<C-u>", "<C-u>zz", { desc = "base: Scroll up and center cursor" })

-- 搜索时保持光标居中
km("n", "n", "nzz", { desc = "base: Search next and center cursor" })
km("n", "N", "Nzz", { desc = "base: Search previous and center cursor" })

---@param key string
---@param nav_key string
---@param desc string
local function quickfix_nav_keymap(key, nav_key, desc)
  km("n", key, function()
    local wins = vim.api.nvim_list_wins()
    for _, win_id in ipairs(wins) do
      if "qf" == vim.api.nvim_get_option_value("filetype", {
            buf = vim.api.nvim_win_get_buf(win_id)
          }) then
        return nav_key
      end
    end
    return key
  end, { desc = desc, expr = true })
end

-- quickfix list
quickfix_nav_keymap("<C-n>", "<cmd>cnext<cr>zz", "base: Next quickfix item")
quickfix_nav_keymap("<C-p>", "<cmd>cprevious<cr>zz", "base: Prev quickfix item")

-- command mode emacs keymap --------------------------------------------------
km("c", "<C-a>", "<Home>", { desc = "base: emacs keymap" })
km("c", "<C-e>", "<End>", { desc = "base: emacs keymap" })
km("c", "<C-f>", "<Right>", { desc = "base: emacs keymap" })
km("c", "<C-b>", "<Left>", { desc = "base: emacs keymap" })
km("c", "<C-d>", "<Delete>", { desc = "base: emacs keymap" })
km("c", "<M-f>", "<C-Right>", { desc = "base: emacs keymap" })
km("c", "<M-b>", "<C-Left>", { desc = "base: emacs keymap" })

-- custom extension ------------------------------------------------------------
km("n", "<M-1>", function() require("extensions.netrw-plus"):toggle() end, { desc = "netrw: Open Netrw file manager" })

-- terminal 终端
km("n", "<M-s>", function()
  require("extensions.terminal").toggle_tabbed_terminal({ keys = { toggle = "<M-s>", } })
end, { desc = "base: Toggle float terminal" })
km("n", "<M-3>", function()
  require("extensions.terminal").toggle_executable({ toggle_key = "<M-3>", exe_path = "lazygit", win_size = "full" })
end, { desc = "base: Toggle lazygit terminal" })
km("n", "<M-4>", function()
  require("extensions.terminal").toggle_scratch_terminal({ toggle_key = "<M-4>" })
end, { desc = "base: Toggle scratch terminal" })

-- comment 注释
km("n", "<M-e>", function() vim.api.nvim_input("gcc") end, { desc = "base: Comment line" })
km("v", "<M-e>", function() vim.api.nvim_input("gc") end, { desc = "base: Comment selected line" })

-- project management 项目管理
km("n", "<leader>pf", function() require("extensions.project-manager"):toggle() end,
  { desc = "base: Open or close recent project list" })
km("n", "<leader>pr", function() require("extensions.project-manager"):load_last_project() end,
  { desc = "base: Load last project" })
km("n", "<leader>ps", function() require("extensions.project-manager"):save_current_project() end,
  { desc = "base: Save current project" })
km("n", "<leader>pa", function() require("extensions.project-manager"):add_current_project() end,
  { desc = "base: Add current project" })
