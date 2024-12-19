"################################# 最小化配置
"
" root用户配置
" sudo ln -s ./vimrc /root/.vimrc
" sudo ln -s ./vimrc /root/.config/nvim/init.vim
"
" 用户配置
" ln -s ./vimrc ~/.vimrc
" ln -s ./vimrc ~/.config/nvim/init.vim
"
" 使用silent!防止某些版本的vim不兼容某个配置，导致报错

"################################# 基础配置

set nocompatible          " 无法删除问题
set number                " 行号
set ruler                 " 右下角显示行号和列号
set relativenumber        " 设置相对行号
set clipboard=unnamedplus " 设置和剪贴板共用
set tabstop=4             " tab键相关
set shiftwidth=4          " shift宽度
set smartindent           " 智能缩进
set cursorline            " 游标
set incsearch             " 增量搜索
set smartindent           " 智能匹配
set ignorecase            " 搜索忽略大小写
set nowrap                " 禁止折行显示文本
set scrolloff=4           " 光标移动时保持上下有4行的间隔
set sidescrolloff=8       " 光标移动时保持左右有8个字符的间隔
silent! syntax enable     " 语法检测
set splitbelow            " 分割水平新窗口默认在下边
set splitright            " 分割垂直新窗口默认在右
set fillchars+=eob:\      " 去掉没有文字的行左边会显示的～
set pumheight=15          " 补全弹窗最大补全个数
set colorcolumn=80        " 限制列宽
silent! set inccommand=nosplit    " 替换时底部显示所有匹配的列

"################################# keymap

" 禁用翻页键
nnoremap <C-f> <Nop>
nnoremap <C-b> <Nop>

nnoremap <esc> <cmd>noh<cr><esc>
inoremap <esc> <cmd>noh<cr><esc>
" 切换窗口
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" 设置窗口大小
nnoremap <C-left> <C-w><
nnoremap <C-right> <C-w>>
nnoremap <C-up> <C-w>-
nnoremap <C-down> <C-w>+

" 添加保存存档点
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ; ;<c-g>u

" 翻页时保持光标居中
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" 搜索时保持光标居中
nnoremap n nzz
nnoremap N Nzz

"################################# colorscheme
highlight Visual ctermbg=Gray ctermfg=Black
silent! colorscheme habamax
