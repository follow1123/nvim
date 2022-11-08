-- vim.cmd('set number')
-- 行号
vim.o.number = true
-- 设置相对行号
vim.o.relativenumber = true
-- 设置和剪贴板共用
-- vim.o.clipboard = 'unnamed'
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

-- 插件相关 start
vim.call('plug#begin', '~/AppData/Local/nvim/plugged')
-- #1#主题插件
-- Plug 'morhetz/gruvbox'
-- #2# 目录树
Plug 'scrooloose/nerdtree'
-- #3# 开始菜单美化
Plug 'mhinz/vim-startify'
-- #4# 注释插件
Plug 'scrooloose/nerdcommenter'
-- #5# 模糊搜索插件 
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mhartington/formatter.nvim'
-- #6# jetbrain风格的主题插件
Plug 'doums/darcula'
vim.call('plug#end')
-- 插件相关 end

-- 插件配置 start
-- #1# gruvbox 主题插件
-- vim.cmd[[
	-- set background=dark
	-- let g:gruvbox_italic=1
	-- colorscheme gruvbox
	-- let g:gruvbox_contrast_dark = 'hard'
-- ]]
-- #4# 注释插件
vim.cmd[[
	let g:NERDSpaceDelims=1
]]
-- 注释插件按钮映射
map('n', '<leader>e', '<Plug>NERDCommenterToggle', {noremap = true})
map('v', '<leader>e', '<Plug>NERDCommenterToggle', {noremap = true})

-- #5# 模糊搜索配置
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- 设置搜索时忽略的文件夹
require('telescope').setup{
	defaults = {
		file_ignore_patterns = {
			"node_modules","target",".git"
		}
	} 
}
-- jetbrains主题配置
vim.cmd[[
	colorscheme darcula 
]]

-- 插件设置 end
