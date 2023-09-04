-- #################################################################################
-- #                                                                               #
-- #                                  无插件配置                                   #
-- #                                                                               #
-- #################################################################################

-- ###########################
-- #    变量定义(variable)   #
-- ###########################

-- 全局变量

--判断使用为windows
_G.IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and true or false
-- 判断是否为linux
_G.IS_LINUX = vim.fn.has("unix") == 1 and true or false
-- 判断是否为gui方式启动
_G.IS_GUI = vim.fn.has("gui_running") == 1 and true or false

_G.CONFIG_PATH = vim.fn.stdpath("config")

_G.LANGUAGE = { }


-- 本地变量

-- ###########################
-- #    函数定义(function)   #
-- ###########################
_G.LANGUAGE.lua = {
	run_code_on_cursor = function()
		-- 获取当前光标所在行的文本
		local cur_code = vim.fn.getline('.'):match("^%s*(.-)%s*$")
		if cur_code == "" then
			vim.notify("no code on cursor")
		else
			vim.cmd("lua " .. cur_code)
		end
	end
}


-- ###########################
-- #    基础配置(options)    #
-- ###########################

local opt = vim.opt

opt.number = true                             -- 行号
opt.relativenumber = true                     -- 设置相对行号
-- vim.o.clipboard = "unnamed"                -- 设置和剪贴板共用
opt.tabstop = 4	                              -- tab键相关
opt.shiftwidth = 4
opt.smartindent = true                        -- 智能缩进
opt.termguicolors = true                      -- 开启终端颜色
opt.cursorline = true                         -- 游标
opt.incsearch = true                          -- 增量搜索
opt.smartindent = true                        -- 智能匹配
opt.ignorecase = true	                        -- 搜索忽略大小写
opt.wrap = false	                            -- 禁止折行显示文本
opt.scrolloff = 4                             -- 光标移动的时候始终保持上下左右至少有 4 个空格的间隔
opt.sidescrolloff = 8                         -- 光标所有移动时保持离边框8个字符时开始横向滚动
-- vim.wo.signcolumn = "yes"                     -- 显示左侧图标指示列
opt.mouse = "a"                               -- 支持鼠标
opt.foldmethod = "indent"                     -- 根据缩进折叠
opt.foldenable = false                        -- 打开文件时自动折叠
opt.foldlevel = 99                            -- 最大折叠深度
opt.syntax = "on"                             -- 语法检测
opt.splitbelow = true                         -- 分割水平新窗口默认在下边
opt.splitright = true                         -- 分割垂直新窗口默认在右
-- opt.guifont = "JetBrainsMono:h14"
opt.shell = _G.IS_WINDOWS and "cmd" or "zsh"  -- 目前windows下设置后toggleterm插件就无法使用了
opt.fillchars = { eob = ' ' }          -- 去掉没有文字的行左边会显示的～号，
opt.undofile = true
-- vim.wo.fillchars = 'eob: '

-- ###########################
-- #       目录树(netrw)     #
-- ###########################

vim.g.netrw_liststyle = 3                     -- 设置文件管理模式为tree模式
vim.g.netrw_winsize = 20                       -- 设置文件管理器打开时默认的宽度

-- ###########################
-- #      主题颜色(theme)    #
-- ###########################

vim.api.nvim_command([[
  colorscheme slate
  highlight Normal guibg=#1e1e1e
  highlight StatusLineNC guibg=#282828
  highlight StatusLine guibg=#04324f guifg=#bbbbbb
  highlight Visual guibg=#264f78 guifg=NONE
  highlight ModeMsg guibg=#e29f84
]])


-- ###########################
-- #   按键映射(keybinging)  #
-- ###########################

vim.g.mapleader = " "                                                   -- leader 键

local opts_keymap = { noremap = true, silent = true }

local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("n", "<C-f>", "<Nop>", opts_keymap)                                     -- 禁用翻页
keymap("n", "<C-b>", "<Nop>", opts_keymap)

keymap("n", "<C-h>", "<C-w>h", opts_keymap)                                    -- 切换窗口
keymap("n", "<C-j>", "<C-w>j", opts_keymap)
keymap("n", "<C-k>", "<C-w>k", opts_keymap)
keymap("n", "<C-l>", "<C-w>l", opts_keymap)

keymap("n", "<C-M-s>", "<cmd>e " .. _G.CONFIG_PATH .. "/init.lua <cr>", opts_keymap)   -- 打开配置文件

keymap("v", "<", "<gv", opts_keymap)                                           -- visual模式下tab        
keymap("v", ">", ">gv", opts_keymap)

-- keymap("t", "<Esc>", "<C-\\><C-N>", term_opts)                       -- terminal模式下使用Esc键退出insert模式
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)                 -- terminal模式下正常跳转窗口
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)                 
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

keymap("n", "<leader>v", "V", opts_keymap)                                     -- 修改进入visual line模式的快捷键

keymap("n", "<C-left>", "<C-w><", opts_keymap)                                 -- 设置窗口大小
keymap("n", "<C-right>", "<C-w>>", opts_keymap)
keymap("n", "<C-up>", "<C-w>-", opts_keymap)
keymap("n", "<C-down>", "<C-w>+", opts_keymap)

keymap("v", "<M-y>", "\"+y", opts_keymap)                                      -- 从系统剪贴板复制粘贴
keymap("n", "<M-p>", "\"+p", opts_keymap)
keymap("v", "<M-p>", "\"+p", opts_keymap)


keymap("n", "<C-s>", ":w<CR>", opts_keymap)                                    -- Ctrl+s保存
keymap("i", "<C-s>", "<ESC>:w<CR>", opts_keymap)

keymap("n", "<leader>n", "<Esc>:nohlsearch<CR>", opts_keymap)                  -- 取消高亮

keymap("n", "<M-j>", "V:m '>+1<CR>gv=gv'<Esc><Esc>", opts_keymap)              -- 上下移动选中的行
keymap("n", "<M-k>", "V:m '>-2<CR>gv=gv'<Esc><Esc>", opts_keymap)
keymap("v", "<M-j>", ":m '>-2<CR>gv=gv'<Esc>", opts_keymap)
keymap("v", "<M-k>", ":m '>+1<CR>gv=gv'<Esc>", opts_keymap)


keymap("n", "<C-d>", "<C-d>zz", opts_keymap)                                   -- 翻页时保持光标居中
keymap("n", "<C-u>", "<C-u>zz", opts_keymap)

keymap("n", "<C-Tab>", "<C-^>", opts_keymap)                                   -- 切换两个buffer

keymap("n", "n", "nzz", opts_keymap)                                           -- 搜索时保持光标居中
keymap("n", "N", "Nzz", opts_keymap)

keymap("n", "<M-q>", ":bdelete!<cr>", opts_keymap)

keymap("n", "<M-1>", "<cmd>Lexplore!<cr>", opts_keymap)


vim.keymap.set("n", "<leader>cr", function ()
  local lang_table = _G.LANGUAGE[vim.bo.filetype]
  if lang_table ~= nil then
    lang_table.run_code_on_cursor()
  else
    print("no run code config, FileType: " .. vim.bo.filetype)
  end
end, {
  desc = "run code on curcor",
  noremap = true,
  silent = true,
})

-- ###########################
-- #    命令定义(command)    #
-- ###########################

vim.api.nvim_create_user_command("RunCode", function ()
  local lang_table = _G.LANGUAGE[vim.bo.filetype]
  if lang_table ~= nil then
    lang_table.run_code_on_cursor()
  else
    print("no run code config, FileType: " .. vim.bo.filetype)
  end
end, { desc = "run code on cursor" })

-- 打开设置
vim.cmd("command! Setting :e " .. _G.CONFIG_PATH .. "/init_min.lua")

-- 格式化
-- vim.cmd("command! Format lua vim.lsp.buf.format()")

-- windows下保存只读文件
if _G.IS_WINDOWS then
  vim.api.nvim_create_user_command("SudoSave", function ()
    -- 获取备份文件路，如果不存在就创建
    local backup_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/sudo_backup")
    if vim.fn.isdirectory(backup_dir) == 0 then
      vim.fn.mkdir(backup_dir, "p")
    end
    backup_dir = backup_dir:gsub("/", "\\")

    -- 获取当前文件的绝对路径
    local cur_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    -- 根据当前文件的路径生产一个备份文件的名称
    local format_path =  backup_dir .. "\\" .. cur_path:gsub("[\\:]", "_")
    local backup_path = format_path .. ".bak"
    local new_file_path = format_path .. ".new"
    -- 执行cmd下的copy命令复制当前文件到备份文件路径
    vim.fn.system("copy /y " .. cur_path .. " " .. backup_path)
    -- 执行:w命令将当前buffer的内容保存到备份目录下的.new文件
    vim.cmd("silent w! " .. new_file_path)
    -- 使用powershell的Start-Process以管理员方式执行cmd下的type命令将.new文件覆盖当前文件
    local status = vim.fn.system("powershell -c \"Start-Process cmd -ArgumentList '/c type " .. new_file_path .. " > " .. cur_path .. "' -Wait -Verb RunAs\" & echo 1")
    -- 等待内部命令执行完后执行后续操作
    if tonumber(status) == 1 then
      -- 删除新建的文件
      vim.fn.system("del " .. new_file_path)
      -- 重新加载当前buffer
      vim.cmd("e!")
      print("save backup file in: " .. backup_path)
    end
  end, { desc = "save readonly file"})
end

-- 打开终端
if _G.IS_WINDOWS then
  vim.cmd("command! TermOpen term pwsh")
else
  vim.cmd("command! TermOpen term zsh")
end

-- ###########################
-- #  自动命令(autocommand)  #
-- ###########################

-- 去除回车后注释下一行
vim.api.nvim_create_autocmd({ "BufEnter" }, {
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
	vim.api.nvim_create_autocmd({ "InsertLeave", "VimEnter" }, {
		pattern = "*",
		callback = function()
			vim.fn.system("im_select.exe 1")
		end,
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

-- 退出insert模式和文本修改时保存
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*",
  nested = true,
	command = "silent! wall",
})

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

-- 打开终端时设置默认快捷键
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts_keymap)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<Right>]], opts_keymap)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-n>', [[<Down>]], opts_keymap)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-p>', [[<Up>]], opts_keymap)
  end
})

-- 复制时高亮
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 100, })
	end,
})

-- lua 文件单独配置
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function ()
    -- 设置lua文件的tab宽度
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end
})
