# Neovim Config

## 特性

* lua、rust、c/c++相关配置
* 使用[lazy.vim](https://github.com/folke/lazy.nvim)插件管理，优化启动速度
* 存在无插件配置和最小化配置，以及vimrc文件适应各vim或neovim


## 依赖

* Neovim >= **0.8.0** 
* Git >= **2.19.0** 
* [Nerd Font](https://www.nerdfonts.com/) 字体 **_(可选)_**
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

# 无插件配置init文件为init_noplugin.lua
# 最小化配置init文件为init_mini.lua
# vimrc配置文件为vimrc
```
### Linux
```bash
git clone https://github.com/follow1123/nvim ~/.config/nvim
```

## 按键映射

> 使用[which-key](https://github.com/folke/which-key.nvim)插件管理按键

* 按键大部部分使用原版vim的方式，只是添加了新功能

* 使用`:WhichKey`命令插件按键配置

### 基础按键

* `<M-1>` 切换目录树
* `<M-4>` 切换底部终端
* `<M-6>` 切换lazygit终端
* `<C-f>` 在当前buffer内搜索文本
* `<M-f>` 在当前项目内搜索文件

### leader按键

#### 代码相关`<leader>c` 

* `<leader>ca` 执行lsp的code action操作
* `<leader>cf` 代码格式化

#### LSP `<leader>l` 

* `<leader>lp` 预览代码诊断信息
* `<leader>ls` 列出当前buffer内的所有符号
* `<leader>lS` 列出当前项目内的所有符号

#### Buffer `<leader>b` 

* `<leader>bb` 切换到上一个buffer，和`<C-^>`一样
* `<leader>bf` 列出当前的buffer

#### File 文件相关 `<leader>f`

* `<leader>ff` 模糊搜索当前项目内的所有文本

#### Git `<leader>g`

* `<leader>gr` 还原当前的修改
* `<leader>gd` 分屏对比当前的修改
* `<leader>gb` 显示当前提交人信息

#### Help `<leader>h`
> 帮助内大部分使用telescope的搜索框

* `<leader>hh` 高亮帮助
* `<leader>hk` 按键映射帮助
* `<leader>hf` 帮助搜索

#### Project `<leader>p`

* `<leader>pf` 列出最近打开的项目并搜索
* `<leader>po` 打开一个项目

## 参考

* [Neovim-from-scratch](https://github.com/LunarVim/Neovim-from-scratch)
* [LazyVim](https://github.com/LazyVim/LazyVim)
