--#############################################################################
--#                                                                           #
--#                                最小化配置                                 #
--#                                                                           #
--#############################################################################

--判断使用为windows
_G.IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1)
-- 判断是否为linux
_G.IS_LINUX = vim.fn.has("unix") == 1
-- 判断是否为gui方式启动
_G.IS_GUI = vim.fn.has("gui_running") == 1

_G.CONFIG_PATH = vim.fn.stdpath("config")

--#############################################################################
--#                                                                           #
--#                                基础配置                                   #
--#                                                                           #
--#############################################################################

vim.opt.number = true             -- 行号
vim.opt.relativenumber = true     -- 设置相对行号
vim.opt.clipboard = "unnamedplus" -- 设置和剪贴板共用
vim.opt.tabstop = 4	              -- tab键相关
vim.opt.shiftwidth = 4            -- shift宽度
vim.opt.smartindent = true        -- 智能缩进
vim.opt.termguicolors = true      -- 开启终端颜色
vim.opt.cursorline = true         -- 游标
vim.opt.incsearch = true          -- 增量搜索
vim.opt.smartindent = true        -- 智能匹配
vim.opt.ignorecase = true	        -- 搜索忽略大小写
vim.opt.wrap = false	            -- 禁止折行显示文本
vim.opt.scrolloff = 4             -- 光标移动的时候始终保持上下左右至少有 4 个空格的间隔
vim.opt.sidescrolloff = 8         -- 光标所有移动时保持离边框8个字符时开始横向滚动
vim.opt.mouse = "a"               -- 支持鼠标
vim.opt.foldmethod = "indent"     -- 根据缩进折叠
vim.opt.foldenable = false        -- 打开文件时自动折叠
vim.opt.foldlevel = 99            -- 最大折叠深度
vim.opt.syntax = "on"             -- 语法检测
vim.opt.splitbelow = true         -- 分割水平新窗口默认在下边
vim.opt.splitright = true         -- 分割垂直新窗口默认在右
vim.opt.undofile = true           -- 启用保存undofile的功能
vim.opt.fillchars = { eob = ' ' } -- 去掉没有文字的行左边会显示的～号，
vim.opt.pumheight = 15            -- 补全弹窗最大补全个数
vim.opt.path:append("**/*")       -- 添加find查找所有子目录路径
vim.opt.wildmenu = true           -- 搜索显示补全
vim.opt.colorcolumn = "80"        -- 限制列宽

vim.g.mapleader = " "             -- leader键

--#############################################################################
--#                                                                           #
--#                                  keymap                                   #
--#                                                                           #
--#############################################################################

local keymap_opts = { noremap = true, silent = true }

-- 禁用翻页键
vim.keymap.set("n","<C-f>", "<Nop>", keymap_opts)
vim.keymap.set("n","<C-b>", "<Nop>", keymap_opts)

-- 切换窗口
vim.keymap.set("n","<C-h>", "<C-w>h", keymap_opts)
vim.keymap.set("n","<C-l>", "<C-w>l", keymap_opts)
vim.keymap.set("n","<C-j>", "<C-w>j", keymap_opts)
vim.keymap.set("n","<C-k>", "<C-w>k", keymap_opts)

-- 设置窗口大小
vim.keymap.set("n","<C-left>", "<C-w><", keymap_opts)
vim.keymap.set("n","<C-right>", "<C-w>>", keymap_opts)
vim.keymap.set("n","<C-up>", "<C-w>-", keymap_opts)
vim.keymap.set("n","<C-down>", "<C-w>+", keymap_opts)

-- 搜索历史
vim.keymap.set("n","n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true })

-- visual line模式
vim.keymap.set("n","<leader>v", "V", keymap_opts)

-- 清除搜索的高亮文本
vim.keymap.set("i","<esc>", "<cmd>noh<cr><esc>", keymap_opts)
vim.keymap.set("n","<esc>", "<cmd>noh<cr><esc>", keymap_opts)

-- 添加保存存档点
vim.keymap.set("i",",", ",<c-g>u", keymap_opts)
vim.keymap.set("i",".", ".<c-g>u", keymap_opts)
vim.keymap.set("i",";", ";<c-g>u", keymap_opts)

-- 上下移动选中的行
vim.keymap.set("v","<M-j>", function() return vim.bo.modifiable and ":m '>+1<cr>gv=gv" or "<Ignore>" end, { expr = true })
vim.keymap.set("v","<M-k>", function() return vim.bo.modifiable and ":m '<-2<cr>gv=gv" or "<Ignore>" end, { expr = true })

-- 翻页时保持光标居中
vim.keymap.set("n","<C-d>", "<C-d>zz", keymap_opts)
vim.keymap.set("n","<C-u>", "<C-u>zz", keymap_opts)

-- quickfix list
vim.keymap.set("n", "[q", "<cmd>cprevious<cr>zz", keymap_opts)
vim.keymap.set("n", "]q", "<cmd>cnext<cr>zz", keymap_opts)

vim.keymap.set("n", "<M-`>", "<C-^>", keymap_opts)

-- 搜索时保持光标居中
vim.keymap.set("n","n", "nzz", keymap_opts)
vim.keymap.set("n","N", "Nzz", keymap_opts)

-- 补全快捷键
vim.keymap.set("i", "<C-j>", "<C-n>", keymap_opts) -- 修改补全弹窗的快捷键
vim.keymap.set("i", "<C-k>", "<C-p>", keymap_opts)
vim.keymap.set("i", "<C-n>", "<Nop>", keymap_opts) -- 进入insert模式下禁用
vim.keymap.set("i", "<C-p>", "<Nop>", keymap_opts)

-- command模式快捷键
vim.keymap.set("c", "<C-a>", function() vim.api.nvim_input("<Home>") end, keymap_opts)
vim.keymap.set("c", "<C-e>", function() vim.api.nvim_input("<End>") end, keymap_opts)
vim.keymap.set("c", "<C-f>", function() vim.api.nvim_input("<Right>") end, keymap_opts)
vim.keymap.set("c", "<C-b>", function() vim.api.nvim_input("<Left>") end, keymap_opts)
vim.keymap.set("c", "<M-f>", function() vim.api.nvim_input("<C-Right>") end, keymap_opts)
vim.keymap.set("c", "<M-b>", function() vim.api.nvim_input("<C-Left>") end, keymap_opts)


--#############################################################################
--#                                                                           #
--#                                autocommand                                #
--#                                                                           #
--#############################################################################

-- 去除回车后注释下一行
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
	end,
})

-- 使用:terminal命令打开终端时默认关闭行号，并直接进入insert模式
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert!")
	end,
})

-- windows下离开insert模式后、进入vim时输入法切换为英文模式
-- linux下离开insert模式数日发切换为英文模式
if _G.IS_WINDOWS then
	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = "*",
    nested = true, -- 允许嵌套
		callback = function() vim.fn.system("im_select.exe 1") end,
	})
else
	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = "*",
		callback = function()
			if tonumber(vim.fn.system("fcitx5-remote")) == 2 then
				vim.fn.system("fcitx5-remote -c")
			end
		end,
	})
end

-- 在终端模式下，vim退出后还原光标样式
if not _G.IS_GUI then
	vim.api.nvim_create_autocmd("VimLeave", {
		pattern = "*",
    nested = true,
		callback = function()
      vim.cmd("set guicursor+=a:ver25,a:blinkon1,a:blinkoff1")
		end,
	})
end

-- 复制时高亮
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 100, })
	end,
})

--#############################################################################
--#                                                                           #
--#                                  colorscheme                              #
--#                                                                           #
--#############################################################################

-- visual模式选中文本的颜色
vim.api.nvim_set_hl(0, "Visual", { fg = "NONE", bg = "#4b4b4b" })

-- visual模式选中文本的颜色
vim.api.nvim_set_hl(0, "ColorColumn", { link = "CursorLine" })
