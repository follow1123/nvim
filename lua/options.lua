-- 行号
vim.o.number = true
-- 设置相对行号
vim.o.relativenumber = true
-- 设置和剪贴板共用
-- vim.o.clipboard = "unnamed"
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
-- 禁止折行显示文本
vim.o.wrap = false
-- 光标移动的时候始终保持上下左右至少有 4 个空格的间隔
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4
-- 显示左侧图标指示列
vim.wo.signcolumn = "yes"
-- 底部命令行行高，为0默认隐藏
--vim.o.cmdheight = 0
-- vim.o.showcmd = false
-- 支持鼠标
vim.o.mouse = "a"

-- 代码折叠相关
-- 根据缩进折叠
vim.o.foldmethod = "indent"
-- 打开文件时自动折叠
vim.o.foldenable = false
-- 最大折叠深度
vim.o.foldlevel = 99

vim.o.syntax = true
-- 分割水平新窗口默认在下边
vim.o.splitbelow = true
-- 分割垂直新窗口默认在右边
vim.o.splitright = true
