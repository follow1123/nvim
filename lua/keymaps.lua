-- ###########################
-- #        按键映射         #
-- ###########################

local keymap_util = require("utils.keymap")

local map = keymap_util.map
local nmap = keymap_util.nmap
local vmap = keymap_util.vmap
local imap = keymap_util.imap

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

-- visual模式下tab        
vmap("<", "<gv", "base: Left tab")
vmap(">", ">gv", "base: Right tab")

-- buffer
nmap("<S-h>", "<cmd>bprevious<cr>", "base: Prev buffer")
nmap("<S-l>", "<cmd>bnext<cr>", "base: Next buffer")
nmap("[b", "<cmd>bprevious<cr>","base: Prev buffer")
nmap("]b", "<cmd>bnext<cr>", "base: Next buffer")

-- 切换两个buffer
nmap("<leader>bb", "<cmd>e #<cr>", "buffer: Switch to Other Buffer")
nmap("<leader>`", "<cmd>e #<cr>", "base: Switch to Other Buffer")
nmap("<C-Tab>", "<C-^>", "base: Switch to Other Buffer")

-- 搜索历史
nmap("n", "'Nn'[v:searchforward]", { expr = true, desc = "base: Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "base: Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "base: Next search result" })
nmap("N", "'nN'[v:searchforward]", { expr = true, desc = "base: Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "base: Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "base: Prev search result" })

-- visual line模式
nmap("<leader>v", "V", "base: Visual line mode")

-- 清除搜索的高亮文本
imap("<esc>", "<cmd>noh<cr><esc>", "base: Clear lighlight search")
nmap("<esc>", "<cmd>noh<cr><esc>", "base: Clear lighlight search")

-- Ctrl+s保存
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", "base: Save file")

-- 添加保存存档点
imap(",", ",<c-g>u", "base: Add undo break-points")
imap(".", ".<c-g>u", "base: Add undo break-points")
imap(";", ";<c-g>u", "base: Add undo break-points")

-- 上下移动选中的行
nmap("<M-j>", function() return vim.bo.modifiable and "<cmd>m .+1<cr>==" or "<Ignore>" end, { expr = true, desc = "base: Move down" })
nmap("<M-k>", function() return vim.bo.modifiable and "<cmd>m .-2<cr>==" or "<Ignore>" end, { expr = true, desc = "base: Move up" })
vmap("<M-j>", ":m '>+1<cr>gv=gv", "base: Move up")
vmap("<M-k>", ":m '<-2<cr>gv=gv", "base: Move down")

-- 翻页时保持光标居中
nmap("<C-d>", "<C-d>zz", "base: Scroll dowm and page center")
nmap("<C-u>", "<C-u>zz", "base: Scroll up and page center")

-- 搜索时保持光标居中
nmap("n", "nzz", "base: Search next and page center")
nmap("N", "Nzz", "base: Search previous and page center")


-- 打开配置文件
nmap("<C-M-s>", "<cmd>e " .. _G.CONFIG_PATH .. "/init.lua <cr>", "base: Open setting file")

nmap("<M-q>", "<cmd>lua require('extensions').smart_quit()<cr>", "base: Close window or buffer")

-- 终端
nmap("<C-\\>", "<cmd>lua require('extensions.terminal').toggle('full_term')<cr>", "base: Open full terminal")
nmap("<M-4>", "<cmd>lua require('extensions.terminal').toggle('below_term')<cr>", "base: Open below terminal")
nmap("<M-6>", "<cmd>lua require('extensions.terminal').toggle('lazygit_term')<cr>", "base: Open lazygit terminal")

-- quickfix list
nmap("[q", "<cmd>cprevious<cr>zz","base: Prev quickfix")
nmap("]q", "<cmd>cnext<cr>zz", "base: Next quickfix")
