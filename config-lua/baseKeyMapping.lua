-- leader 键
vim.g.mapleader = " "
-- 定义变量
-- 切换到visual 块模式
map('n', '<leader>v', '<C-v>', {noremap = true})
-- 从系统切板粘贴
map('n', '<leader>p', '"+p', {noremap = true})
-- 向下粘贴一行
map('n', '<leader>j', 'yyp', {noremap = true})
-- 向上粘贴一行
map('n', '<leader>k', 'yyP', {noremap = true})
-- 删除一行
map('n', '<leader>d', 'dd', {noremap = true})
-- 设置窗口大小
map('n', '<C-left>', '<C-w><', {noremap = true})
map('n', '<C-right>', '<C-w>>', {noremap = true})
-- visual 模式下复制到系统剪切版
map('v', '<leader>y', '"+y', {noremap = true})
-- normal和visual模式下退出操作
map('n', '<leader>q', '<Esc>:q<Enter>', {noremap = true})
map('v', '<leader>q', '<Esc>:q<Enter>', {noremap = true})
map('i', '<C-enter>', '<Esc>o', {noremap = true})
-- normal模式下保存操作
map('n', '<leader>s', '<Esc>:w<Enter>', {noremap = true})
-- 设置搜索后取消高亮
map('n', '<leader>h', '<Esc>:nohlsearch<Enter>', {noremap = true})
-- map('n', '<leader><Esc>', '<Esc>:set nohlsearch<Enter><Esc>:set hlsearch<Enter>', {noremap = true})
