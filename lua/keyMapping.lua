local u = require('util')

-- leader 键
vim.g.mapleader = " "
-- 切换到visual 块模式
u.m('n', '<leader>v', '<C-v>', {noremap = true})
-- 从系统切板粘贴
u.m('n', '<leader>p', '"+p', {noremap = true})
-- 向下粘贴一行
u.m('n', '<leader>j', 'yyp', {noremap = true})
-- 向上粘贴一行
u.m('n', '<leader>k', 'yyP', {noremap = true})
-- 删除一行
u.m('n', '<leader>d', 'dd', {noremap = true})
-- 设置窗口大小
u.m('n', '<C-left>', '<C-w><', {noremap = true})
u.m('n', '<C-right>', '<C-w>>', {noremap = true})
-- visual 模式下复制到系统剪切版
u.m('v', '<leader>y', '"+y', {noremap = true})
-- normal和visual模式下退出操作
u.m('n', '<leader>q', '<Esc>:q<Enter>', {noremap = true})
u.m('v', '<leader>q', '<Esc>:q<Enter>', {noremap = true})
u.m('i', '<C-enter>', '<Esc>o', {noremap = true})
-- normal模式下保存操作
u.m('n', '<leader>s', '<Esc>:w<Enter>', {noremap = true})
-- 设置搜索后取消高亮
u.m('n', '<leader>h', '<Esc>:nohlsearch<Enter>', {noremap = true})
-- 可视模式下选择行上下移动
u.m('v', 'J', ":m '>+1<CR>gv=gv'", {noremap = true})
u.m('v', 'K', ":m '>-2<CR>gv=gv'", {noremap = true})
