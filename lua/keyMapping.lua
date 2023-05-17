
-- leader 键
vim.g.mapleader = " "
require('util')
-- 切换到visual 块模式
.n('<leader>v', '<C-v>')
-- 向下粘贴一行
.n('<leader>j', 'yyp')
-- 向上粘贴一行
.n('<leader>k', 'yyP')
-- 删除一行
.n('<A-d>', 'dd')
-- 设置窗口大小
.n('<C-left>', '<C-w><')
.n('<C-right>', '<C-w>>')
-- 从系统切板粘贴
.n('<leader>p', '"+p')
-- normal模式下保存操作
.n('<C-s>', '<Esc>:w<Enter>')
-- 设置搜索后取消高亮
.n('<leader>h', '<Esc>:nohlsearch<Enter>')
-- 普通模式下上下移动文本
.n('J', "V:m '>+1<CR>gv=gv'<Esc>")
.n('K', "V:m '>-2<CR>gv=gv'<Esc>")

-- 可视模式下选择行上下移动
.v('J', ":m '>+1<CR>gv=gv'<Esc>")
.v('K', ":m '>-2<CR>gv=gv'<Esc>")
-- visual 模式下复制到系统剪切版
.v('<leader>y', '"+y')
