-- keymaps --------------------------------------------------------------------
local keymap = require("utils.keymap")

local nmap = keymap.nmap
local vmap = keymap.vmap
local imap = keymap.imap
local cmap = keymap.cmap

-- 禁用翻页键
nmap("<C-f>", "<Nop>", "base: Disable pagedown key")
nmap("<C-b>", "<Nop>", "base: Disable pageup key")

-- window ---------------------------------------------------------------------

nmap("<C-h>", "<C-w>h", "base: Move cursor to left window")
nmap("<C-l>", "<C-w>l", "base: Move cursor to right window")
nmap("<C-j>", "<C-w>j", "base: Move cursor to above window")
nmap("<C-k>", "<C-w>k", "base: Move cursor to below window")
nmap("<M-q>", "<C-w>c", "base: Close current window")

-- search ---------------------------------------------------------------------
-- 搜索历史
nmap("n", "'Nn'[v:searchforward]", "base: Next search result", nil, { expr = true })
nmap("N", "'nN'[v:searchforward]", "base: Prev search result", nil, { expr = true })

-- 清除搜索的高亮文本
imap("<esc>", "<cmd>noh<cr><esc>", "base: Clear lighlight search")
nmap("<esc>", "<cmd>noh<cr><esc>", "base: Clear lighlight search")

-- 添加保存存档点
imap(",", ",<c-g>u", "base: Add undo break-points")
imap(".", ".<c-g>u", "base: Add undo break-points")
imap(";", ";<c-g>u", "base: Add undo break-points")

-- 翻页时保持光标居中
nmap("<C-d>", "<C-d>zz", "base: Scroll dowm and page center")
nmap("<C-u>", "<C-u>zz", "base: Scroll up and page center")

-- 搜索时保持光标居中
nmap("n", "nzz", "base: Search next and page center")
nmap("N", "Nzz", "base: Search previous and page center")

local function quickfix_move(key, quickfix_cmd)
  local wins = vim.api.nvim_list_wins()
  for _, win_id in ipairs(wins) do
    if "qf" == vim.api.nvim_get_option_value("filetype", {
      buf = vim.api.nvim_win_get_buf(win_id)
    }) then
      return quickfix_cmd
    end
  end
  return key
end

-- quickfix list
nmap("<C-n>", function() return quickfix_move("<C-n>", "<cmd>cnext<cr>zz") end,
  "base: Next quickfix item", nil, { expr = true })
nmap("<C-p>", function() return quickfix_move("<C-p>", "<cmd>cprevious<cr>zz") end,
  "base: Prev quickfix item", nil, { expr = true })

-- command mode emacs keymap --------------------------------------------------

cmap("<C-a>", function() vim.api.nvim_input("<Home>") end, "emacs keymap")
cmap("<C-e>", function() vim.api.nvim_input("<End>") end, "emacs keymap")
cmap("<C-f>", function() vim.api.nvim_input("<Right>") end, "emacs keymap")
cmap("<C-b>", function() vim.api.nvim_input("<Left>") end, "emacs keymap")
cmap("<C-d>", function() vim.api.nvim_input("<Delete>") end, "emacs keymap")
cmap("<M-f>", function() vim.api.nvim_input("<C-Right>") end, "emacs keymap")
cmap("<M-b>", function() vim.api.nvim_input("<C-Left>") end, "emacs keymap")

-- custom extension ------------------------------------------------------------

nmap("<M-1>", "<cmd>lua require('extensions.netrw-plus'):toggle()<cr>", "netrw: Open Netrw file manager")

-- 终端
nmap("<M-s>", function () require("extensions.terminal").toggle_float_shell("<M-s>") end, "base: Toggle float terminal")
nmap("<M-3>", function () require("extensions.terminal").toggle_float_lazygit("<M-3>") end, "base: Toggle lazygit terminal")
nmap("<M-4>", function () require("extensions.terminal").toggle_scratch_shell("<M-4>") end, "base: Toggle scratch terminal")

-- 注释
nmap("<M-e>", function() vim.api.nvim_input("gcc") end, "base: Comment line")
vmap("<M-e>", function() vim.api.nvim_input("gc") end, "base: Comment line selected")

-- 项目管理
nmap("<leader>pf", "<cmd>lua require('extensions.project-manager'):toggle()<cr>", "base: Open or close recent project list")
nmap("<leader>pr", "<cmd>lua require('extensions.project-manager'):load_last_project()<cr>", "base: Load last project")
nmap("<leader>ps", "<cmd>lua require('extensions.project-manager'):save_current_project()<cr>", "base: Load last project")
nmap("<leader>pa", "<cmd>lua require('extensions.project-manager'):add_current_project()<cr>", "base: Load last project")
