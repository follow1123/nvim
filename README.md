## Neovim Config

使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理插件

### 依赖

- Neovim >= **0.10.0**
- [Git](https://git-scm.com/)
- [Nerd Font](https://www.nerdfonts.com/) 字体 **_(可选)_**
- C 编译工具(用于编译 nvim-treesitter)
- [fd](https://github.com/sharkdp/fd) (文件查找)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (模糊搜索)
- [lazygit](https://github.com/jesseduffield/lazygit) (git管理)

### 安装

#### Windows

> 使用 powershell 安装

```powershell
git clone https://github.com/follow1123/nvim $ENV:LOCALAPPDATA\nvim
```

#### Linux

```bash
git clone https://github.com/follow1123/nvim ~/.config/nvim
```

### 按键映射

以下快捷键都是新增或修改的，不包含默认的快捷键

<kbd>Leader</kbd> 设置成 <kbd>Space</kbd>，禁用 <kbd>Ctrl</kbd>+<kbd>b</kbd> 和 <kbd>Ctrl</kbd>+<kbd>f</kbd> 使用 <kbd>Ctrl</kbd>+<kbd>d</kbd> 和 <kbd>Ctrl</kbd>+<kbd>u</kbd> 代替

#### 基础

##### 窗口

| 模式     | 按键                             | 说明                 |
| -------- | -------------------------------- | -------------------- |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>h</kbd>     | 光标移动到左边的窗口 |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>j</kbd>     | 光标移动到下边的窗口 |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>l</kbd>     | 光标移动到右边的窗口 |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>k</kbd>     | 光标移动到上边的窗口 |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>left</kbd>  | 减少垂直窗口大小     |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>right</kbd> | 增加垂直窗口大小     |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>up</kbd>    | 减少水平窗口大小     |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>down</kbd>  | 增加水平窗口大小     |
| `Normal` | <kbd>Alt</kbd>+<kbd>q</kbd>      | 退出窗口             |

##### 注释

| 模式     | 按键                        | 说明     |
| -------- | --------------------------- | -------- |
| `Normal` | <kbd>Alt</kbd>+<kbd>e</kbd> | 单行注释 |
| `Visual` | <kbd>Alt</kbd>+<kbd>e</kbd> | 多行注释 |

##### Quickfix List

只有 quickfix list 窗口打开的情况下这两个按键才有效

| 模式     | 按键                         | 说明                 |
| -------- | ---------------------------- | -------------------- |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>n</kbd> | 下一个 quickfix item |
| `Normal` | <kbd>Ctrl</kbd>+<kbd>p</kbd> | 上一个 quickfix item |

##### 帮助

基于 [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) 插件实现

| 模式     | 按键                                        | 说明                   |
| -------- | ------------------------------------------- | ---------------------- |
| `Normal` | <kbd>Leader</kbd>+<kbd>h</kbd>+<kbd>f</kbd> | 搜索通用帮助信息       |
| `Normal` | <kbd>Leader</kbd>+<kbd>h</kbd>+<kbd>k</kbd> | 显示所有按键信息       |
| `Normal` | <kbd>Leader</kbd>+<kbd>h</kbd>+<kbd>h</kbd> | 显示所有highlights信息 |

#### 文件管理

##### Netrw

基于内置插件 netrw 扩展的插件

| 模式     | 作用域（文件类型） | 按键                        | 说明                           |
| -------- | ------------------ | --------------------------- | ------------------------------ |
| `Normal` | `*`                | <kbd>Alt</kbd>+<kbd>1</kbd> | 开关或关闭目录树               |
| `Normal` | `netrw`            | <kbd>g</kbd>+<kbd>w</kbd>   | netrw 窗口定位到当前共做目录   |
| `Normal` | `netrw`            | <kbd>y</kbd>+<kbd>p</kbd>   | 复制当前文件的相对路径         |
| `Normal` | `netrw`            | <kbd>y</kbd>+<kbd>P</kbd>   | 复制当前文件的绝对路径         |
| `Normal` | `netrw`            | <kbd>Alt</kbd>+<kbd>f</kbd> | netrw 窗口内可以搜索文件或目录 |

##### 文件搜索

基于 [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) 插件实现

| 模式     | 按键                                        | 说明                             |
| -------- | ------------------------------------------- | -------------------------------- |
| `Normal` | <kbd>Alt</kbd>+<kbd>f</kbd>                 | 搜索当前项目内的文件             |
| `Normal` | <kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>f</kbd> | 在当前项目内搜索                 |
| `Normal` | <kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>w</kbd> | 在当前项目内搜索当前光标下的单词 |

##### Git

基于 [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) 插件实现

| 模式     | 按键                                        | 说明                              |
| -------- | ------------------------------------------- | --------------------------------- |
| `Normal` | <kbd>]</kbd>+<kbd>c</kbd>                   | 下一处变更                        |
| `Normal` | <kbd>[</kbd>+<kbd>c</kbd>                   | 上一处变更                        |
| `Normal` | <kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>r</kbd> | 重置光标所在位置的变更            |
| `Normal` | <kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>R</kbd> | 重置当前 buffer 内的所有变更      |
| `Normal` | <kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>s</kbd> | 显示当前项目的git status信息      |
| `Visual` | <kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>r</kbd> | 重置选中的所有变更                |
| `Normal` | <kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>p</kbd> | 弹出光标所在位置的变更的diff窗口  |
| `Normal` | <kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>b</kbd> | 弹出光标所在位置的变更的blame窗口 |
| `Normal` | <kbd>Leader</kbd>+<kbd>g</kbd>+<kbd>d</kbd> | diff 当前 buffer                  |

#### 开发

##### LSP

相关插件：

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - lsp 配置管理
- [mason.nvim](https://github.com/williamboman/mason.nvim) - lsp 包管理器
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) - lsp 配置和包管理器整合
- [lazydev.nvim](https://github.com/folke/lazydev.nvim) - neovim 开发提示

| 模式     | 按键                                        | 说明                           |
| -------- | ------------------------------------------- | ------------------------------ |
| `Normal` | <kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>d</kbd> | 显示当前buffer的所有的诊断信息 |
| `Normal` | <kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>D</kbd> | 显示当前项目的所有的诊断信息   |
| `Normal` | <kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>s</kbd> | 显示当前buffer的所有的符号信息 |
| `Normal` | <kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>S</kbd> | 显示当前项目的所有的符号信息   |
| `Normal` | <kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>r</kbd> | 重命名光标下的符号             |
| `Normal` | <kbd>Leader</kbd>+<kbd>l</kbd>+<kbd>p</kbd> | 弹窗显示当前光标下的诊断信息   |
| `Normal` | <kbd>Leader</kbd>+<kbd>c</kbd>+<kbd>a</kbd> | 显示code action                |
| `Normal` | <kbd>Leader</kbd>+<kbd>c</kbd>+<kbd>f</kbd> | 格式化代码                     |
| `Normal` | <kbd>g</kbd>+<kbd>i</kbd>                   | 跳转到实现                     |
| `Normal` | <kbd>g</kbd>+<kbd>d</kbd>                   | 跳转到定义                     |
| `Normal` | <kbd>g</kbd>+<kbd>t</kbd>                   | 跳转到类型定义                 |
| `Normal` | <kbd>g</kbd>+<kbd>D</kbd>                   | 跳转到声明                     |
| `Normal` | <kbd>g</kbd>+<kbd>r</kbd>                   | 跳转到引用                     |
| `Normal` | <kbd>[</kbd>+<kbd>d</kbd>                   | 上一处代码诊断                 |
| `Normal` | <kbd>]</kbd>+<kbd>d</kbd>                   | 下一处代码诊断                 |
| `Normal` | <kbd>Shift</kbd>+<kbd>k</kbd>               | 显示当前光标下符号的文档       |
| `Normal` | <kbd>Alt</kbd>+<kbd>Enter</kbd>             | 显示code action                |
| `Normal` | <kbd>F2</kbd>                               | 重命名光标下的符号             |

##### 代码补全

相关插件：

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - neovim 补全框架
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - 使用 lua 编写的代码片段引擎
- [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) - 补全框架的代码片段源，整合 LuaSnip
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) - 补全框架的 lsp 语法补全源
- [cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help) - 补全框架的 lsp 方法参数补全源
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - 一堆代码片段

| 模式              | 按键                            | 说明                       |
| ----------------- | ------------------------------- | -------------------------- |
| `Insert`          | <kbd>Ctrl</kbd>+<kbd>n</kbd>    | 下一个补全                 |
| `Insert`          | <kbd>Ctrl</kbd>+<kbd>p</kbd>    | 上一个补全                 |
| `Insert`          | <kbd>Ctrl</kbd>+<kbd>k</kbd>    | 开始补全                   |
| `Insert`          | <kbd>Ctrl</kbd>+<kbd>u</kbd>    | 文档弹窗内容向上滚动       |
| `Insert`          | <kbd>Ctrl</kbd>+<kbd>d</kbd>    | 文档弹窗内容向下滚动       |
| `Insert`          | <kbd>Enter</kbd>                | 完成补全                   |
| `Insert`          | <kbd>Ctrl</kbd>+<kbd>k</kbd>    | 显示补全弹窗或开关文档弹窗 |
| `Insert` `Select` | <kbd>Ctrl</kbd>+<kbd>c</kbd>    | 打断补全或代码片段         |
| `Insert` `Select` | <kbd>Tab</kbd>                  | 选择补全或代码片段的下一处 |
| `Insert` `Select` | <kbd>Shift</kbd>+<kbd>Tab</kbd> | 代码片段的上一处           |

#### 项目管理

##### Project Manager

基于自带的 session 功能开发的扩展

添加或删除项目的方式就像 [Harpoon](https://github.com/ThePrimeagen/harpoon) 或 [oil.nvim](https://github.com/stevearc/oil.nvim) 一样，直接操作 buffer 里面的路径即可

| 模式     | 作用域（文件类型） | 按键                                                    | 说明                             |
| -------- | ------------------ | ------------------------------------------------------- | -------------------------------- |
| `Normal` | `*`                | <kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>f</kbd>             | 打开或关闭项目管理窗口           |
| `Normal` | `*`                | <kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>r</kbd>             | 恢复最近一个打开的项目的 session |
| `Normal` | `*`                | <kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>s</kbd>             | 保存当前项目的 session           |
| `Normal` | `*`                | <kbd>Leader</kbd>+<kbd>p</kbd>+<kbd>a</kbd>             | 将当前项目添加进管理列表         |
| `Normal` | `projectmanager`   | <kbd>Enter</kbd>                                        | 打开选中的项目                   |
| `Normal` | `projectmanager`   | <kbd>q</kbd>/<kbd>Alt</kbd>+<kbd>q</kbd>/<kbd>Esc</kbd> | 退出项目管理窗口                 |

##### Harpoon

[harpoon](https://github.com/ThePrimeagen/harpoon) 插件，管理主要编辑的文件，防止多次 <kbd>Ctrl</kbd>+<kbd>i</kbd>，<kbd>Ctrl</kbd>+<kbd>o</kbd> 后找不到文件在哪里

| 模式     | 按键                                        | 说明                          |
| -------- | ------------------------------------------- | ----------------------------- |
| `Normal` | <kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>a</kbd> | 添加当前文件到harpoon list    |
| `Normal` | <kbd>Leader</kbd>+<kbd>f</kbd>+<kbd>l</kbd> | 弹窗显示harpoon list          |
| `Normal` | <kbd>Alt</kbd>+<kbd>j</kbd>                 | 打开harpoon list内的第1个文件 |
| `Normal` | <kbd>Alt</kbd>+<kbd>k</kbd>                 | 打开harpoon list内的第2个文件 |
| `Normal` | <kbd>Alt</kbd>+<kbd>l</kbd>                 | 打开harpoon list内的第3个文件 |
| `Normal` | <kbd>Alt</kbd>+<kbd>;</kbd>                 | 打开harpoon list内的第4个文件 |

#### 终端

基于内置的终端实现

- executable terminal - 封装 [lazygit](https://github.com/jesseduffield/lazygit) 之类的 TUI 程序
- scratch terminal - 草稿终端
- tabbed terminal - 多终端，浮动终端

| 模式                | 按键                        | 说明                        |
| ------------------- | --------------------------- | --------------------------- |
| `Normal` `Terminal` | <kbd>Alt</kbd>+<kbd>3</kbd> | 打开或关闭 lazygit 终端     |
| `Normal` `Terminal` | <kbd>Alt</kbd>+<kbd>4</kbd> | 打开或关闭 scratch terminal |
| `Normal` `Terminal` | <kbd>Alt</kbd>+<kbd>s</kbd> | 打开或关闭 tabbed terminal  |

#### 其他

- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) - markdown 文件预览
- [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - 颜色预览
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 代码语法解析，一般用于代码高亮等
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - 依赖插件，telescope 和 Harpoon 插件的依赖库
- [catppuccin](https://github.com/catppuccin/nvim) - 主题插件

| 模式     | 按键                                        | 说明                 |
| -------- | ------------------------------------------- | -------------------- |
| `Normal` | <kbd>Leader</kbd>+<kbd>m</kbd>+<kbd>p</kbd> | 开关markdown文件预览 |

### 参考

- [Neovim-from-scratch](https://github.com/LunarVim/Neovim-from-scratch)
- [LazyVim](https://github.com/LazyVim/LazyVim)
