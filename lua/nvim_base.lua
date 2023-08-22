-- ###########################
-- #        基础配置         #
-- ###########################
local opt = vim.o
opt.number = true                             -- 行号
opt.relativenumber = true                     -- 设置相对行号
-- vim.o.clipboard = "unnamed"                  -- 设置和剪贴板共用
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
vim.wo.signcolumn = "yes"                       -- 显示左侧图标指示列
--vim.o.cmdheight = 0                           -- 底部命令行行高，为0默认隐藏
opt.mouse = "a"                               -- 支持鼠标
opt.foldmethod = "indent"                     -- 根据缩进折叠
opt.foldenable = false                        -- 打开文件时自动折叠
opt.foldlevel = 99                            -- 最大折叠深度
opt.syntax = true                             -- 语法检测
opt.splitbelow = true                         -- 分割水平新窗口默认在下边
opt.splitright = true                         -- 分割垂直新窗口默认在右
opt.guifont = "FiraMono Nerd Font Mono:h16"
-- opt.shell = _G.IS_WINDOWS and "pwsh" or "zsh" -- 目前windows下设置后toggleterm插件就无法使用了
-- vim.opt.fillchars = { eob = ' ' }          -- 去掉没有文字的行左边会显示的～号，
-- vim.wo.fillchars = 'eob: '

-- 设置 .lua 文件缩进为两个空格
vim.cmd([[
  autocmd FileType lua setlocal tabstop=2 shiftwidth=2 expandtab
]])


-- ###########################
-- #        按键映射         #
-- ###########################

vim.g.mapleader = " "                           -- leader 键

local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("n", "<C-h>", "<C-w>h", opts)                                    -- 切换窗口
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<C-M-s>", ":e ~/AppData/Local/nvim/init.lua <cr>", opts)   -- 打开配置文件

keymap("v", "<", "<gv", opts)                                           -- visual模式下tab        
keymap("v", ">", ">gv", opts)

-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)                    -- terminal模式下正常跳转窗口
keymap("t", "<Esc>", "<C-\\><C-N>", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

keymap("n", "<leader>v", "V", opts)                                     -- 修改进入visual line模式的快捷键

keymap("n", "<C-left>", "<C-w><", opts)                                 -- 设置窗口大小
keymap("n", "<C-right>", "<C-w>>", opts)
keymap("n", "<C-up>", "<C-w>-", opts)
keymap("n", "<C-down>", "<C-w>+", opts)

keymap("v", "<M-y>", "\"+y", opts)                                      -- 从系统剪贴板复制粘贴
keymap("n", "<M-p>", "\"+p", opts)
keymap("v", "<M-p>", "\"+p", opts)


keymap("n", "<C-s>", ":w<CR>", opts)                                    -- Ctrl+s保存
keymap("i", "<C-s>", "<ESC>:w<CR>", opts)

keymap("n", "<leader>n", "<Esc>:nohlsearch<CR>", opts)                  -- 取消高亮

keymap("n", "<M-j>", "V:m '>+1<CR>gv=gv'<Esc><Esc>", opts)              -- 上下移动选中的行
keymap("n", "<M-k>", "V:m '>-2<CR>gv=gv'<Esc><Esc>", opts)
keymap("v", "<M-j>", ":m '>-2<CR>gv=gv'<Esc>", opts)
keymap("v", "<M-k>", ":m '>+1<CR>gv=gv'<Esc>", opts)


keymap("n", "<C-d>", "<C-d>zz", opts)                                   -- 翻页时保持光标居中
keymap("n", "<C-u>", "<C-u>zz", opts)

keymap("n", "<C-Tab>", "<C-^>", opts)                                   -- 切换两个buffer

keymap("n", "n", "nzz", opts)                                           -- 搜索时保持光标居中
keymap("n", "N", "Nzz", opts)
