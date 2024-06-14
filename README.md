# Neovim Config

## 特性

* 使用[lazy.vim](https://github.com/folke/lazy.nvim)插件管理，优化启动速度
* 内置无插件配置，和vimscript配置


## 依赖

* Neovim >= **0.9.0** 
* [Git](https://git-scm.com/)
* [Nerd Font](https://www.nerdfonts.com/)字体 **_(可选)_**
* C编译工具 (用于编译nvim-treesitter)
* [fd](https://github.com/sharkdp/fd) (文件查找) **_(可选)_**
* [ripgrep](https://github.com/BurntSushi/ripgrep) (模糊搜索)
* [lazygit](https://github.com/jesseduffield/lazygit) (git管理)

## 安装

### Windows

* 在powershell下安装

```powershell
git clone https://github.com/follow1123/nvim $env:LOCALAPPDATA\nvim

# 如果下载插件后打开nvim下载插件后报错，使用:Lazy restore命令将所有插件的版本都恢复到lazy-lock文件里面的版本
# 如果还是报错可能是插件删库了，在plugin目录内找到对应插件的位置去除
```
### Linux
```bash
git clone https://github.com/follow1123/nvim ~/.config/nvim
```

## 按键映射

> 以下快捷键都是新增或修改的，不包含默认的快捷键

* <kbd>Leader</kbd> 键为 <kbd>Space</kbd>

* 禁用 <kbd>Ctrl</kbd>+<kbd>b</kbd> 和 <kbd>Ctrl</kbd>+<kbd>f</kbd> 使用 <kbd>Ctrl</kbd>+<kbd>d</kbd> 和 <kbd>Ctrl</kbd>+<kbd>u</kbd> 代替

<table>
    <tr>
        <th>功能</th>
        <th>模式</th>
        <th>按键</th>
        <th>描述</th>
    </tr>
    <tr>
        <td rowspan="8" style="vertical-align: middle"><strong>窗口</strong></td>
        <td rowspan="8" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Ctrl</kbd>+<kbd>h</kbd></td>
        <td>光标移动到左边的窗口</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>j</kbd></td>
        <td>光标移动到下边的窗口</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>k</kbd></td>
        <td>光标移动到上边的窗口</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>l</kbd></td>
        <td>光标移动到右边的窗口</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>left</kbd></td>
        <td>减少垂直窗口大小</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>right</kbd></td>
        <td>增加垂直窗口大小</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>up</kbd></td>
        <td>减少水平窗口大小</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>down</kbd></td>
        <td>增加水平窗口大小</td>
    </tr>
    <tr>
        <td rowspan="4" style="vertical-align: middle"><strong>Buffer</strong></td>
        <td rowspan="4" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Alt</kbd>+<kbd>n</kbd></td>
        <td>切换到下一个buffer</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>p</kbd></td>
        <td>切换到上一个buffer</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>&#96;</kbd></td>
        <td>来回切换两个buffer</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>b</kbd>+<kbd>f</kbd></td>
        <td>列出所有的buffer</td>
    </tr>
    <tr>
        <td><strong>目录树</strong></td>
        <td><code>Normal</code></td>
        <td><kbd>Leader</kbd>+<kbd>1</kbd></td>
        <td>开关目录树</td>
    </tr>
    <tr>
        <td rowspan="3" style="vertical-align: middle"><strong>终端</strong></td>
        <td rowspan="3" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Ctrl</kbd>+<kbd>&#92;</kbd></td>
        <td>全屏终端</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>4</kbd></td>
        <td>底部终端</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>6</kbd></td>
        <td>lazygit终端</td>
    </tr>
    <tr>
        <td rowspan="2" style="vertical-align: middle"><strong>注释</strong></td>
        <td><code>Normal</code></td>
        <td><kbd>Alt</kbd>+<kbd>e</kbd></td>
        <td>单行注释</td>
    </tr>
    <tr>
        <td><code>Visual</code></td>
        <td><kbd>Alt</kbd>+<kbd>e</kbd></td>
        <td>多行注释</td>
    </tr>
    <tr>
        <td rowspan="2" style="vertical-align: middle"><strong>Quickfix</strong></td>
        <td rowspan="2" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>[</kbd>+<kbd>q</kbd></td>
        <td>上一个quickfix</td>
    </tr>
    <tr>
        <td><kbd>]</kbd>+<kbd>q</kbd></td>
        <td>下一个quickfix</td>
    </tr>
    <tr>
        <td rowspan="8" style="vertical-align: middle"><strong>Git</strong></td>
        <td rowspan="4" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>]</kbd>+<kbd>c</kbd></td>
        <td>下一处变更</td>
    </tr>
    <tr>
        <td><kbd>[</kbd>+<kbd>c</kbd></td>
        <td>上一处变更</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>r</kbd></td>
        <td>重置光标所在位置的变更</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>s</kbd></td>
        <td>显示当前项目的git status信息</td>
    </tr>
    <tr>
        <td><code>Visual</code></td>
        <td><kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>r</kbd></td>
        <td>重置选中的所有变更</td>
    </tr>
    <tr>
        <td rowspan="3" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>p</kbd></td>
        <td>弹出光标所在位置的变更的diff窗口</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>b</kbd></td>
        <td>弹出光标所在位置的变更的blame窗口</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>d</kbd></td>
        <td>diff当前buffer</td>
    </tr>
    <tr>
        <td rowspan="5" style="vertical-align: middle"><strong>文件</strong></td>
        <td rowspan="5" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Alt</kbd>+<kbd>f</kbd></td>
        <td>搜索当前项目内的文件</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>f</kbd></td>
        <td>在当前项目内搜索</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>w</kbd></td>
        <td>在当前项目内搜索当前光标下的单词</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>W</kbd></td>
        <td>在当前项目内搜索当前光标下的单词</br>包含左右空白</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>t</kbd></td>
        <td>根据指定的文件类型在当前项目内搜索</td>
    </tr>
    <tr>
        <td rowspan="4" style="vertical-align: middle"><strong>帮助</strong></td>
        <td rowspan="4" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Leader</kbd>+<kbd>h</kbd>+<kbd>f</kbd></td>
        <td>搜索通用帮助信息</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>h</kbd>+<kbd>k</kbd></td>
        <td>显示所有按键信息</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>h</kbd>+<kbd>r</kbd></td>
        <td>显示所有registers信息</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>h</kbd>+<kbd>h</kbd></td>
        <td>显示所有highlights信息</td>
    </tr>
    <tr>
        <td rowspan="6" style="vertical-align: middle"><strong>Harpoon</strong></td>
        <td rowspan="6" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>a</kbd></td>
        <td>添加当前文件到harpoon list</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>l</kbd></td>
        <td>弹窗显示harpoon list</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>j</kbd></td>
        <td>打开harpoon list内的第1个文件</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>k</kbd></td>
        <td>打开harpoon list内的第2个文件</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>l</kbd></td>
        <td>打开harpoon list内的第3个文件</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>;</kbd></td>
        <td>打开harpoon list内的第4个文件</td>
    </tr>
    <tr>
        <td rowspan="5" style="vertical-align: middle"><strong>Project</strong></td>
        <td rowspan="5" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>f</kbd></td>
        <td>显示所有项目</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>r</kbd></td>
        <td>加载上一次打开的项目</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>a</kbd></td>
        <td>将当前项目添加到项目列表</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>o</kbd></td>
        <td>打开输入的项目路径</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>s</kbd></td>
        <td>保存当前项目（只保存已经存在的项目）</td>
    </tr>
    <tr>
        <td rowspan="18" style="vertical-align: middle"><strong>LSP</strong></td>
        <td rowspan="18" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>d</kbd></td>
        <td>显示当前buffer的所有的诊断信息</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>D</kbd></td>
        <td>显示当前项目的所有的诊断信息</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>s</kbd></td>
        <td>显示当前buffer的所有的符号信息</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>S</kbd></td>
        <td>显示当前项目的所有的符号信息</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>r</kbd></td>
        <td>重命名光标下的符号</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>p</kbd></td>
        <td>弹窗显示当前光标下的诊断信息</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>c</kbd>+<kbd>a</kbd></td>
        <td>显示code action</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>c</kbd>+<kbd>f</kbd></td>
        <td>格式化代码</td>
    </tr>
    <tr>
        <td><kbd>g</kbd>+<kbd>i</kbd></td>
        <td>跳转到实现</td>
    </tr>
    <tr>
        <td><kbd>g</kbd>+<kbd>d</kbd></td>
        <td>跳转到定义</td>
    </tr>
    <tr>
        <td><kbd>g</kbd>+<kbd>t</kbd></td>
        <td>跳转到类型定义</td>
    </tr>
    <tr>
        <td><kbd>g</kbd>+<kbd>D</kbd></td>
        <td>跳转到声明</td>
    </tr>
    <tr>
        <td><kbd>g</kbd>+<kbd>r</kbd></td>
        <td>跳转到引用</td>
    </tr>
    <tr>
        <td><kbd>[</kbd>+<kbd>d</kbd></td>
        <td>上一处代码诊断</td>
    </tr>
    <tr>
        <td><kbd>]</kbd>+<kbd>d</kbd></td>
        <td>下一处代码诊断</td>
    </tr>
    <tr>
        <td><kbd>Shift</kbd>+<kbd>k</kbd></td>
        <td>显示当前光标下符号的文档</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>Enter</kbd></td>
        <td>显示code action</td>
    </tr>
    <tr>
        <td><kbd>F2</kbd></td>
        <td>重命名光标下的符号</td>
    </tr>
    <tr>
        <td rowspan="9" style="vertical-align: middle"><strong>代码补全</strong></td>
        <td rowspan="6" style="vertical-align: middle"><code>Insert</code></td>
        <td><kbd>Ctrl</kbd>+<kbd>n</kbd></td>
        <td>下一个补全</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>p</kbd></td>
        <td>上一个补全</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>u</kbd></td>
        <td>文档弹窗内容向上滚动</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>d</kbd></td>
        <td>文档弹窗内容向下滚动</td>
    </tr>
    <tr>
        <td><kbd>Enter</kbd></td>
        <td>完成补全</td>
    </tr>
    <tr>
        <td><kbd>Ctrl</kbd>+<kbd>k</kbd></td>
        <td>显示补全弹窗或开关文档弹窗</td>
    </tr>
    <tr>
        <td rowspan="3" style="vertical-align: middle"><code>Insert</code>|<code>Select</code></td>
        <td><kbd>Ctrl</kbd>+<kbd>c</kbd></td>
        <td>打断补全或代码片段</td>
    </tr>
    <tr>
        <td><kbd>Tab</kbd></td>
        <td>选择补全或代码片段的下一处</td>
    </tr>
    <tr>
        <td><kbd>Shift</kbd>+<kbd>Tab</kbd></td>
        <td>代码片段的上一处</td>
    </tr>
    <tr>
        <td rowspan="5" style="vertical-align: middle"><strong>其他</strong></td>
        <td rowspan="2" style="vertical-align: middle"><code>Visual</code></td>
        <td><kbd>Alt</kbd>+<kbd>j</kbd></td>
        <td>将选中的行向下移动</td>
    </tr>
    <tr>
        <td><kbd>Alt</kbd>+<kbd>k</kbd></td>
        <td>将选中的行向上移动</td>
    </tr>
    <tr>
        <td rowspan="3" style="vertical-align: middle"><code>Normal</code></td>
        <td><kbd>Alt</kbd>+<kbd>q</kbd></td>
        <td>退出窗口，不会退出vim</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>5</kbd></td>
        <td>开关基于treesitter的代码高亮</td>
    </tr>
    <tr>
        <td><kbd>Leader</kbd>+<kbd>m</kbd>+<kbd>p</kbd></td>
        <td>开关markdown文件预览</td>
    </tr>
</table>

## 插件

### 插件管理器

* [lazy.nvim](https://github.com/folke/lazy.nvim)

### Git

* [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

### 代码补全

* [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
* [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
* [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
* [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
* [cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)
* [cmp-path](https://github.com/hrsh7th/cmp-path)
* [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
* [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)

### LSP

* [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
* [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
* [mason.nvim](https://github.com/williamboman/mason.nvim)
* [fidget.nvim](https://github.com/j-hui/fidget.nvim)
* [neodev.nvim](https://github.com/folke/neodev.nvim)

### 文件管理

* [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
* [harpoon](https://github.com/ThePrimeagen/harpoon)

### 项目管理

* [project_session.nvim](https://github.com/follow1123/project_session.nvim)

### 其他

* [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
* [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)
* [nvim-lastplace](https://github.com/ethanholz/nvim-lastplace)
* [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## 参考

* [Neovim-from-scratch](https://github.com/LunarVim/Neovim-from-scratch)
* [LazyVim](https://github.com/LazyVim/LazyVim)
