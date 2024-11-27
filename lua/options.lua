-- options --------------------------------------------------------------------

vim.opt.clipboard = "unnamedplus"                -- selection 寄存器和系统剪切板共用
vim.opt.number = true                            -- 显示行号
vim.opt.relativenumber = true                    -- 显示相对行号
vim.opt.wrap = false                             -- 禁止折行显示文本
vim.opt.scrolloff = 4                            -- 上下移动光标时保持有4行间隔
vim.opt.sidescrolloff = 8                        -- 左右移动光标时保持有8列间隔
vim.opt.tabstop = 4	                             -- 制表符占用几个空格
vim.opt.shiftwidth = 4                           -- 一次缩进占用几个空格
vim.opt.smartindent = true                       -- 智能缩进
vim.opt.syntax = "on"                            -- 启用语法高亮
vim.opt.termguicolors = true                     -- 开启终端颜色
vim.opt.fillchars = { eob = ' ' }                -- 去掉无内容行显示的～
vim.opt.shortmess:append { I = true }            -- 关闭intro
vim.opt.colorcolumn = "80"                       -- 限制列宽
vim.opt.cursorline = true                        -- 高亮光标所在行
vim.opt.incsearch = true                         -- 增量搜索
vim.opt.smartindent = true                       -- 智能匹配
vim.opt.ignorecase = true                        -- 搜索忽略大小写
vim.opt.inccommand = "split"                     -- 替换时预览
vim.opt.mouse = "a"                              -- 支持鼠标
vim.opt.foldmethod = "manual"                    -- 手动创建折叠块
vim.opt.foldenable = true                        -- 进入文件时自动将所有折叠块打开，默认 true 不打开，false 打开
vim.opt.foldlevel = 99                           -- 最大折叠深度
vim.opt.splitbelow = true                        -- 水平分屏在下面打开
vim.opt.splitright = true                        -- 垂直分屏的右边打开
vim.opt.shell = _G.IS_WINDOWS and "cmd" or "zsh" -- 命令模式下 ! 操作默认的 shell
vim.opt.undofile = true                          -- 启用保存undofile的功能
vim.opt.timeout = true                           -- leaderkey按键延时 
vim.opt.timeoutlen = 700                         -- leaderkey按键延时间，毫秒

-- 配置 gui 模式下默认的中英文字体，防止系统没有字体时报错
vim.cmd([[
silent! set guifont=Cascadia\ Code:h12
silent! set guifontwide=Microsoft\ YaHei:h12
]])


vim.opt.list = true                              -- 显示空白字符
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"                 -- 换行符合
vim.opt.listchars:append "tab:  "               -- 制表符
vim.opt.listchars:append "trail: "               -- 行尾空白符合

vim.wo.signcolumn = "yes"                        -- 显示左侧图标指示列

vim.g.mapleader = " "                            -- leader 键
