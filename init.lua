-- vim.cmd('set number')
-- 行号
vim.o.number = true
-- tab键相关
vim.o.tabstop = 4
vim.o.shiftwidth = 4
-- 智能缩进
vim.o.smartindent = true
vim.o.termguicolors = true
-- 游标
vim.o.cursorline = true
-- 增量搜索
vim.o.incsearch = true
-- 智能匹配
vim.o.smartindent = true
-- 搜索忽略大小写
vim.o.ignorecase = true
-- leader 键
vim.g.mapleader = " "
-- 定义变量
local Plug = vim.fn['plug#']
local map = vim.api.nvim_set_keymap
-- 开关文件树
map('n', '<leader>1', ':NERDTreeToggle<CR>', {noremap = true})
-- 切换到visual 块模式
map('n', '<leader>v', '<C-v>', {noremap = true})
-- 复制到系统剪切板
map('n', '<leader>y', '"+yy', {noremap = true})
-- 粘贴到系统剪切板
map('n', '<leader>p', '"+p', {noremap = true})
-- 向下粘贴一行
map('n', '<leader>j', 'yyp', {noremap = true})
-- 向上粘贴一行
map('n', '<leader>k', 'yyP', {noremap = true})
-- 删除一行
map('n', '<leader>d', 'dd', {noremap = true})
-- visual 模式下复制到系统剪切版
map('v', '<leader>y', '"+yy', {noremap = true})
-- 插件相关
vim.call('plug#begin', '~/AppData/Local/nvim/plugged')
-- Plug 'joshdick/onedark.vim'
--主题插件
Plug 'isobit/vim-darcula-colors'
-- 目录树
Plug 'scrooloose/nerdtree'
-- 开始菜单美化
Plug 'mhinz/vim-startify'
-- vim主题
Plug 'morhetz/gruvbox'
vim.call('plug#end')
-- 插件配置
-- gruvbox 主题插件
vim.cmd[[
	set background=dark
	let g:gruvbox_italic=1
	colorscheme gruvbox
	let g:gruvbox_contrast_dark = 'hard'
]]
