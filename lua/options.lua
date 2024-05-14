--#############################################################################
--#                                                                           #
--#                                 基础配置                                  #
--#                                                                           #
--#############################################################################

vim.opt.number = true                            -- 行号
vim.opt.relativenumber = true                    -- 设置相对行号
vim.opt.clipboard = "unnamedplus"                -- 设置和剪贴板共用
vim.opt.expandtab = true                         -- tab使用空格代替
vim.opt.tabstop = 4	                             -- tab键相关
vim.opt.shiftwidth = 4                           -- shift宽度
vim.opt.smartindent = true                       -- 智能缩进
vim.opt.termguicolors = true                     -- 开启终端颜色
vim.opt.cursorline = true                        -- 游标
vim.opt.incsearch = true                         -- 增量搜索
vim.opt.smartindent = true                       -- 智能匹配
vim.opt.ignorecase = true	                       -- 搜索忽略大小写
vim.opt.wrap = false	                           -- 禁止折行显示文本
vim.opt.scrolloff = 4                            -- 光标移动的时候始终保持上下左右至少有 4 个空格的间隔
vim.opt.sidescrolloff = 8                        -- 光标所有移动时保持离边框8个字符时开始横向滚动
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
vim.opt.inccommand = "split"      -- 替换时底部显示所有匹配的列

vim.wo.signcolumn = "yes"                        -- 显示左侧图标指示列
vim.g.mapleader = " "                            -- leader 键

-- netrw 文件树配置
vim.g.netrw_liststyle = 3                        -- 设置文件管理模式为tree模式
vim.g.netrw_winsize = 20                         -- 设置文件管理器打开时默认的宽度
vim.g.netrw_banner = 0                           -- 不显示顶部的信息
vim.g.netrw_browse_split = 4                     -- 默认在上一个窗口打开文件(同一个窗口)
vim.g.netrw_altv = 1
vim.g.netrw_preview = 1
