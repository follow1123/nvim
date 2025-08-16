-- options --------------------------------------------------------------------

vim.opt.clipboard = "unnamedplus" -- selection 寄存器和系统剪切板共用
vim.opt.number = true -- 显示行号
vim.opt.wrap = false -- 禁止折行显示文本
vim.opt.scrolloff = 4 -- 上下移动光标时保持有4行间隔
vim.opt.sidescrolloff = 8 -- 左右移动光标时保持有8列间隔
vim.opt.tabstop = 4 -- 制表符占用几个空格
vim.opt.shiftwidth = 4 -- 一次缩进占用几个空格
vim.opt.smartindent = true -- 智能缩进
vim.opt.syntax = "on" -- 启用语法高亮
vim.opt.termguicolors = true -- 开启终端颜色
vim.opt.colorcolumn = "80" -- 限制列宽
vim.opt.cursorline = true -- 高亮光标所在行
vim.opt.incsearch = true -- 增量搜索
vim.opt.smartindent = true -- 智能匹配
vim.opt.ignorecase = true -- 搜索忽略大小写
vim.opt.inccommand = "split" -- 替换时预览
vim.opt.mouse = "a" -- 支持鼠标
vim.opt.foldmethod = "manual" -- 手动创建折叠块
vim.opt.foldenable = true -- 进入文件时自动将所有折叠块打开，默认 true 不打开，false 打开
vim.opt.foldlevel = 99 -- 最大折叠深度
vim.opt.splitbelow = true -- 水平分屏在下面打开
vim.opt.splitright = true -- 垂直分屏的右边打开
vim.opt.shell = vim.fn.has("linux") and "zsh" or "cmd" -- 命令模式下 ! 操作默认的 shell
vim.opt.undofile = true -- 启用保存undofile的功能
vim.opt.timeout = true -- leaderkey按键延时
vim.opt.timeoutlen = 700 -- leaderkey按键延时间，毫秒
vim.opt.laststatus = 3 -- 始终只显示一个状态栏
vim.opt.statusline = "%y%m%=%<%F %r%=%-14.(%l,%c%V%) %P"
vim.opt.pumheight = 15 -- 补全弹窗最大补全个数

vim.opt.list = true -- 显示空白字符
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴" -- 换行符合
vim.opt.listchars:append "tab:  " -- 制表符
vim.opt.listchars:append "trail: " -- 行尾空白符合

vim.wo.signcolumn = "yes" -- 显示左侧图标指示列

vim.g.mapleader = " " -- leader 键
