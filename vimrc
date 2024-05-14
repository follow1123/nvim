"##############################################################################
"#                                                                            #
"#                               最小化配置                                   #
"#                                                                            #
"##############################################################################

"##############################################################################
"#                                                                            #
"#                                基础配置                                    #
"#                                                                            #
"##############################################################################

set nocompatible          " 无法删除问题
set number                " 行号
set ruler                 " 右下角显示行号和列号
set relativenumber        " 设置相对行号
set clipboard=unnamedplus " 设置和剪贴板共用
set expandtab             " 空格代替tab
set tabstop=4             " tab键相关
set shiftwidth=4          " shift宽度
set smartindent           " 智能缩进
set cursorline            " 游标
set incsearch             " 增量搜索
set smartindent           " 智能匹配
set ignorecase            " 搜索忽略大小写
set nowrap                " 禁止折行显示文本
set scrolloff=4           " 光标移动的时候始终保持上下左右至少有 4 个空格的间隔
set sidescrolloff=8       " 光标所有移动时保持离边框8个字符时开始横向滚动
" syntax enable             " 语法检测
set splitbelow            " 分割水平新窗口默认在下边
set splitright            " 分割垂直新窗口默认在右
set fillchars+=eob:\      " 去掉没有文字的行左边会显示的～号，
set pumheight=15          " 补全弹窗最大补全个数
set colorcolumn=80        " 限制列宽
set inccommand=nosplit    " 替换时底部显示所有匹配的列

" let g:mapleader=" "                         " leader 键

"##############################################################################
"#                                                                            #
"#                                  keymap                                    #
"#                                                                            #
"##############################################################################

" 禁用翻页键
nnoremap <C-f> <Nop>
nnoremap <C-b> <Nop>

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

" visual line模式
nnoremap <space>v V
" nnoremap <leader>v V

" 清除搜索的高亮文本
" inoremap  <esc> <cmd>noh<cr><esc>
" nnoremap  <esc> <cmd>noh<cr><esc>

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

"##############################################################################
"#                                                                            #
"#                               colorscheme                                  #
"#                                                                            #
"##############################################################################

highlight Visual ctermbg=Gray ctermfg=Black
