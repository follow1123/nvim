--#############################################################################
--#                                                                           #
--#                                   keymap                                  #
--#                                                                           #
--#############################################################################

local keymap = require("utils.keymap")

local nmap = keymap.nmap
local vmap = keymap.vmap
local imap = keymap.imap

-- 禁用翻页键
nmap("<C-f>", "<Nop>", "base: Disable pagedown key")
nmap("<C-b>", "<Nop>", "base: Disable pageup key")

-- 切换窗口
nmap("<C-h>", "<C-w>h", "base: Move cursor to left window")
nmap("<C-l>", "<C-w>l", "base: Move cursor to right window")
nmap("<C-j>", "<C-w>j", "base: Move cursor to above window")
nmap("<C-k>", "<C-w>k", "base: Move cursor to below window")

-- 设置窗口大小
nmap("<C-left>", "<C-w><", "base: Decrease window width")
nmap("<C-right>", "<C-w>>", "base: Increase window width")
nmap("<C-up>", "<C-w>-", "base: Decrease window height")
nmap("<C-down>", "<C-w>+", "base: Increase window height")

-- 搜索历史
nmap("n", "'Nn'[v:searchforward]", { expr = true, desc = "base: Next search result" })
nmap("N", "'nN'[v:searchforward]", { expr = true, desc = "base: Prev search result" })

-- visual line模式
nmap("<leader>v", "V", "base: Visual line mode")

-- 清除搜索的高亮文本
imap("<esc>", "<cmd>noh<cr><esc>", "base: Clear lighlight search")
nmap("<esc>", "<cmd>noh<cr><esc>", "base: Clear lighlight search")

-- 添加保存存档点
imap(",", ",<c-g>u", "base: Add undo break-points")
imap(".", ".<c-g>u", "base: Add undo break-points")
imap(";", ";<c-g>u", "base: Add undo break-points")

-- 上下移动选中的行
vmap("<M-j>", function() return vim.bo.modifiable and ":m '>+1<cr>gv=gv" or "<Ignore>" end, { expr = true, desc = "base: Move down" })
vmap("<M-k>", function() return vim.bo.modifiable and ":m '<-2<cr>gv=gv" or "<Ignore>" end, { expr = true, desc = "base: Move up" })

-- 翻页时保持光标居中
nmap("<C-d>", "<C-d>zz", "base: Scroll dowm and page center")
nmap("<C-u>", "<C-u>zz", "base: Scroll up and page center")

-- 搜索时保持光标居中
nmap("n", "nzz", "base: Search next and page center")
nmap("N", "Nzz", "base: Search previous and page center")

-- quickfix list
nmap("[q", "<cmd>cprevious<cr>zz", "base: Prev quickfix")
nmap("]q", "<cmd>cnext<cr>zz", "base: Next quickfix")

nmap("<M-`>", "<C-^>", "base: Toggle switch buffer")

keymap.map("c", "<C-a>", function() vim.api.nvim_input("<Home>") end, "emacs keymap")
keymap.map("c", "<C-e>", function() vim.api.nvim_input("<End>") end, "emacs keymap")
keymap.map("c", "<C-f>", function() vim.api.nvim_input("<Right>") end, "emacs keymap")
keymap.map("c", "<C-b>", function() vim.api.nvim_input("<Left>") end, "emacs keymap")
keymap.map("c", "<M-f>", function() vim.api.nvim_input("<C-Right>") end, "emacs keymap")
keymap.map("c", "<M-b>", function() vim.api.nvim_input("<C-Left>") end, "emacs keymap")

--############ 扩展功能keymap
nmap("<M-q>", "<cmd>lua require('extensions').smart_quit()<cr>", "base: Close window or buffer")

nmap("<M-1>", "<cmd>lua require('extensions.netrw-plus').toggle()<cr>", "netrw: Open Netrw file manager")

-- 终端
nmap("<C-\\>", "<cmd>lua require('extensions.terminal').full_term:toggle()<cr>", "base: Open full terminal")
nmap("<M-4>", "<cmd>lua require('extensions.terminal').split_term:toggle()<cr>", "base: Open split terminal")
nmap("<M-6>", "<cmd>lua require('extensions.terminal').lazygit_term:toggle()<cr>", "base: Open lazygit terminal")

-- 注释
nmap("<M-e>", "<cmd>lua require('extensions.comment').toggle_comment_line()<cr>", "base: Comment line")
vmap("<M-e>", "<cmd>lua require('extensions.comment').toggle_comment_visual_mode()<cr>", "base: Comment line selected")
