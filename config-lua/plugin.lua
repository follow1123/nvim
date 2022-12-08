vim.call('plug#begin', conf.pluginPath)

-- 目录树
Plug 'scrooloose/nerdtree'
-- 开始菜单美化
Plug 'mhinz/vim-startify'
-- 注释插件
Plug 'scrooloose/nerdcommenter'
-- 模糊搜索插件 
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mhartington/formatter.nvim'
-- jetbrain风格的主题插件
Plug 'doums/darcula'

vim.call('plug#end')

--------------------------------------- 目录树插件配置 ---------------------------------------

-- 开关文件树
map('n', '<leader>1', ':NERDTreeToggle<CR>', {noremap = true})


--------------------------------------- 注释插件配置 ---------------------------------------
vim.cmd[[
	let g:NERDSpaceDelims=1
]]
-- 注释插件按钮映射
map('n', '<leader>e', '<Plug>NERDCommenterToggle', {noremap = true})
map('v', '<leader>e', '<Plug>NERDCommenterToggle', {noremap = true})

--------------------------------------- 模糊搜索配置 ---------------------------------------
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

--------------------------------------- jetbrains主题插件配置 ---------------------------------------
vim.cmd[[
	colorscheme darcula 
]]
