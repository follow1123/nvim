local options = {}
options.init = function()
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
	vim.o.sidescrolloff = 8
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
	-- 分割垂直新窗口默认在右
	vim.o.splitright = true
	-- leader 键
	vim.g.mapleader = " "
	-- gui模式设置字体
	if options.is_gui() then
		vim.cmd([[set guifont=JetBrainsMono\ NF:h12]])
	end
	-- 去掉没有文字的行左边会显示的～号，
	vim.opt.fillchars = { eob = ' ' }
	-- vim.wo.fillchars = 'eob: '
	-- 设置 .lua 文件缩进为两个空格
	vim.cmd([[
	  autocmd FileType lua setlocal tabstop=2 shiftwidth=2 expandtab
	]])
end

-- 判断是否为windwos系统
options.is_windows = function()
	return (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and true or false
end
-- 判断是否为gui运行
options.is_gui = function()
	return vim.fn.has("gui_running") == 1 and true or false
end

options.get_cur_file_name = function()
	return vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
end
-- 浮动终端相关配置
options.terminal = {
	def_shell = options.is_windows() and "pwsh" or "zsh",
	get_width = function()
		return math.floor(vim.o.columns * 0.9)
	end,
	get_height = function()
		return math.floor(vim.o.lines * 0.9)
	end,
	def_direction = "float",
}
options.terminal.def_float_opts = {
	-- border = "single" | "double" | "shadow" | "curved" | ... other options supported by win open
	border = "curved",
	-- 默认占终端长宽的90%
	width = options.terminal.get_width,
	height = options.terminal.get_height,
	winblend = 3
}


return options
