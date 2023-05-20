
-- leader 键
vim.g.mapleader = " "
require("util")
-- 切换到visual line模式
.n("<leader>v", "V")
-- 向下粘贴一行
.n("<leader>j", "yyp")
-- 向上粘贴一行
.n("<leader>k", "yyP")
-- 删除一行
.n("<A-d>", "dd")
-- 设置窗口大小
.n("<C-left>", "<C-w><")
.n("<C-right>", "<C-w>>")
.n("<C-up>", "<C-w>-")
.n("<C-down>", "<C-w>+")
-- 从系统切板粘贴
.n("<leader>p", "\"+p")
-- normal模式下保存操作
.n("<C-s>", ":w<CR>")
-- 设置搜索后取消高亮
.n("<leader>h", "<Esc>:nohlsearch<CR>")
-- 普通模式下上下移动文本
.n("<A-j>", "V:m '>+1<CR>gv=gv'<Esc>")
.n("<A-k>", "V:m '>-2<CR>gv=gv'<Esc>")
.n("<leader>l", "=G")
-- 可视模式下选择行上下移动
.v("<A-j>", ":m '>+1<CR>gv=gv'<Esc>")
.v("<A-k>", ":m '>-2<CR>gv=gv'<Esc>")
-- visual 模式下复制到系统剪切版
.v("<leader>y", "\"+y")
-- insert 模式下快捷键
.m("i", "<C-s>", "<Esc>:w<CR>a")
