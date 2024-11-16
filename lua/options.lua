--#############################################################################
--#                                                                           #
--#                                 基础配置                                  #
--#                                                                           #
--#############################################################################

vim.opt.number = true                            -- 行号
vim.opt.relativenumber = true                    -- 设置相对行号
vim.opt.clipboard = "unnamedplus"                -- 设置和剪贴板共用
vim.opt.tabstop = 4	                             -- tab键相关
vim.opt.shiftwidth = 4                           -- shift宽度
vim.opt.smartindent = true                       -- 智能缩进
vim.opt.termguicolors = true                     -- 开启终端颜色
vim.opt.cursorline = true                        -- 游标
vim.opt.incsearch = true                         -- 增量搜索
vim.opt.smartindent = true                       -- 智能匹配
vim.opt.ignorecase = true	                       -- 搜索忽略大小写
vim.opt.wrap = false                             -- 禁止折行显示文本
vim.opt.scrolloff = 4                            -- 光标移动时保持上下有4行的间隔
vim.opt.sidescrolloff = 8                        -- 光标移动时保持左右有8个字符的间隔
vim.opt.mouse = "a"                              -- 支持鼠标
vim.opt.foldmethod = "manual"                    -- 根据缩进折叠
vim.opt.foldenable = false                       -- 打开文件时自动折叠
vim.opt.foldlevel = 99                           -- 最大折叠深度
vim.opt.syntax = "on"                            -- 语法检测
vim.opt.splitbelow = true                        -- 分割水平新窗口默认在下边
vim.opt.splitright = true                        -- 分割垂直新窗口默认在右
vim.opt.shell = _G.IS_WINDOWS and "cmd" or "zsh" -- 目前windows下设置后toggleterm插件就无法使用了
vim.opt.undofile = true                          -- 启用保存undofile的功能
vim.opt.fillchars = { eob = ' ' }                -- 去掉没有文字的行左边会显示的～号，
vim.opt.colorcolumn = "80"                       -- 限制列宽
vim.opt.inccommand = "split"                     -- 替换时底部显示所有匹配的列
vim.opt.timeout = true                           -- leaderkey按键延时 
vim.opt.timeoutlen = 700                         -- leaderkey按键延时间，毫秒
vim.opt.shortmess:append({I = true})             -- 关闭intro

vim.cmd([[
silent! set guifont=Cascadia\ Code:h12
silent! set guifontwide=Microsoft\ YaHei:h12
]])

-- 显示空白字符
vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab:  "
vim.opt.listchars:append "trail: "

vim.wo.signcolumn = "yes"                        -- 显示左侧图标指示列

vim.g.mapleader = " "                            -- leader 键

-- netrw相关
vim.g.netrw_winsize = 20                         -- 设置文件管理器打开时默认的宽度
