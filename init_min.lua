-- #################################################################################
-- #                                                                               #
-- #                                  无插件配置                                   #
-- #                                                                               #
-- #################################################################################

-- ###########################
-- #    变量定义(variable)   #
-- ###########################

--判断使用为windows
_G.IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and true or false
-- 判断是否为linux
_G.IS_LINUX = vim.fn.has("unix") == 1 and true or false
-- 判断是否为gui方式启动
_G.IS_GUI = vim.fn.has("gui_running") == 1 and true or false

_G.CONFIG_PATH = vim.fn.stdpath("config")

_G.language = { }

_G.util = {
  -- 在visual模式选中文本后获取对应选中的区域处理
  handle_selected_region_content = function(callback)
    vim.api.nvim_input("<Esc>")
    vim.schedule(function ()
      -- 获取visual模式选择的行和列信息
      local start_line = vim.fn.line("'<")
      local end_line = vim.fn.line("'>")
      local start_col = vim.fn.col("'<")
      local end_col = vim.fn.col("'>")
      local region_contents = {}
      -- 获取选择的所有行
      local selected_lines = vim.fn.getline(start_line, end_line)
      -- 根据起始列和结束列位置截取第一行和最后一行
      for i, v in ipairs(selected_lines) do
        local line = v
        if i == 1 then line = string.sub(line, start_col) end
        if i == vim.tbl_count(selected_lines) then line = string.sub(line, 1, (start_line == end_line and end_col - start_col + 1 or end_col)) end
        table.insert(region_contents, i, line)
      end
      -- 获取选择的区域后执行回调方法
      if type(callback) == "function" then
        callback(region_contents)
      end
    end)
  end,
  -- 监听下一个输入的字符
  handle_input_char = function(callback)
    vim.schedule(function ()
      if type(callback) == "function" then
        callback(vim.fn.nr2char(vim.fn.getchar()))
      end
    end)
  end

}

-- ###########################
-- #    函数定义(function)   #
-- ###########################

-- ###########################
-- #    基础配置(options)    #
-- ###########################


vim.opt.number = true                            -- 行号
vim.opt.relativenumber = true                    -- 设置相对行号
-- vim.o.clipboard = "unnamed"                -- 设置和剪贴板共用
vim.opt.tabstop = 4                              -- tab宽度
vim.opt.shiftwidth = 4                           -- shift宽度
vim.opt.smartindent = true                       -- 智能缩进
vim.opt.termguicolors = true                     -- 开启终端颜色
vim.opt.cursorline = true                        -- 启用游标
vim.opt.incsearch = true                         -- 增量搜索
vim.opt.smartindent = true                       -- 智能匹配
vim.opt.ignorecase = true                        -- 搜索忽略大小写
vim.opt.wrap = false                             -- 禁止折行显示文本
vim.opt.scrolloff = 4                            -- 光标移动的时候始终保持上下左右至少有 4 个空格的间隔
vim.opt.sidescrolloff = 8                        -- 光标所有移动时保持离边框8个字符时开始横向滚动
-- vim.wo.signcolumn = "yes"                     -- 显示左侧图标指示列
vim.opt.mouse = "a"                              -- 支持鼠标
vim.opt.foldmethod = "indent"                    -- 根据缩进折叠
vim.opt.foldenable = false                       -- 打开文件时自动折叠
vim.opt.foldlevel = 99                           -- 最大折叠深度
vim.opt.syntax = "on"                            -- 语法检测
vim.opt.splitbelow = true                        -- 分割水平新窗口默认在下边
vim.opt.splitright = true                        -- 分割垂直新窗口默认在右
-- opt.guifont = "JetBrainsMono:h14"
vim.opt.shell = _G.IS_WINDOWS and "cmd" or "zsh" -- 目前windows下设置后toggleterm插件就无法使用了
vim.opt.fillchars = { eob = ' ' }                -- 去掉没有文字的行左边会显示的～号，
vim.opt.undofile = true                          -- 启用保存undofile的功能
vim.opt.path:append("**/*")                      -- 添加find查找所有子目录路径
vim.opt.wildmenu = true                          -- 搜索显示补全

-- ###########################
-- #      主题颜色(theme)    #
-- ###########################

vim.cmd("colorscheme slate") -- 默认主题

-- 默认主题颜色设置
vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e1e" }) -- 背景颜色
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#e9e9e9", bg = "#04324f" }) -- 底部状态栏颜色
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#282828" }) -- 模式状态颜色
vim.api.nvim_set_hl(0, "Visual", { fg = "NONE", bg = "#264f78" }) -- visual模式选中文本的颜色
vim.api.nvim_set_hl(0, "ModeMsg", { fg = "#e9e9e9", bold = true }) -- 切换模式时左下角显示的颜色
vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" }) -- 垂直分屏时分割线的背景颜色
vim.api.nvim_set_hl(0, "MatchParen", { -- 光标在括号上时高亮另一对括号
  bg = "NONE",
  fg = "Yellow",
  sp = "Yellow",
  underline = true,
  bold = true,
  italic = true,
})

-- ###########################
-- #   按键映射(keybinging)  #
-- ###########################



vim.g.mapleader = " " -- leader键<space>

local opts_keymap = { noremap = true, silent = true } -- keymap默认配置
local term_opts = { silent = true } -- terminal默认配置

vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-N>]], term_opts)                       -- terminal模式下使用Esc键退出insert模式

vim.api.nvim_set_keymap("n", "<C-f>", "<Nop>", opts_keymap) -- 禁用翻页
vim.api.nvim_set_keymap("n", "<C-b>", "<Nop>", opts_keymap)

vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", opts_keymap) -- 切换窗口
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", opts_keymap)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", opts_keymap)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", opts_keymap)

vim.api.nvim_set_keymap("v", "<", "<gv", opts_keymap)                                                 -- visual模式下tab
vim.api.nvim_set_keymap("v", ">", ">gv", opts_keymap)

vim.api.nvim_set_keymap("n", "<C-left>", "<C-w><", opts_keymap) -- 减少窗口宽度
vim.api.nvim_set_keymap("n", "<C-right>", "<C-w>>", opts_keymap) -- 增加窗口宽度
vim.api.nvim_set_keymap("n", "<C-up>", "<C-w>+", opts_keymap) -- 增加窗口高度
vim.api.nvim_set_keymap("n", "<C-down>", "<C-w>-", opts_keymap) -- 减少窗口高度

vim.api.nvim_set_keymap("v", "<M-y>", "\"+y", opts_keymap) -- 从系统剪贴板复制粘贴
vim.api.nvim_set_keymap("n", "<M-p>", "\"+p", opts_keymap) -- normal模式从系统剪贴板粘贴
vim.api.nvim_set_keymap("v", "<M-p>", "\"+p", opts_keymap) -- visual模式从系统剪贴板粘贴

vim.api.nvim_set_keymap("n", "<M-j>", "V:m '>+1<CR>gv=gv'<Esc><Esc>", opts_keymap) -- 上下移动选中的行
vim.api.nvim_set_keymap("n", "<M-k>", "V:m '>-2<CR>gv=gv'<Esc><Esc>", opts_keymap)
vim.api.nvim_set_keymap("v", "<M-j>", ":m '>-2<CR>gv=gv'<Esc>", opts_keymap)
vim.api.nvim_set_keymap("v", "<M-k>", ":m '>+1<CR>gv=gv'<Esc>", opts_keymap)

vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts_keymap) -- 翻页时保持光标居中
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts_keymap)

vim.api.nvim_set_keymap("n", "n", "nzz", opts_keymap)         -- 搜索时保持光标居中
vim.api.nvim_set_keymap("n", "N", "Nzz", opts_keymap)

vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", opts_keymap) -- Ctrl+s保存
vim.api.nvim_set_keymap("i", "<C-s>", "<ESC>:w<CR>", opts_keymap) -- 保存

vim.api.nvim_set_keymap("n", "<C-Tab>", "<C-^>", opts_keymap) -- 切换两个buffer

vim.api.nvim_set_keymap("n", "<leader>v", "V", opts_keymap)     -- 修改进入visual line模式的快捷键

vim.api.nvim_set_keymap("n", "<leader>n", "<Esc>:nohlsearch<CR>", opts_keymap)     -- 取消高亮

vim.api.nvim_set_keymap("n", "<M-q>", ":bdelete!<cr>", opts_keymap)

vim.api.nvim_set_keymap("n", "<C-M-s>", "<cmd>e " .. _G.CONFIG_PATH .. "/init.lua <cr>", opts_keymap) -- 打开配置文件

vim.keymap.set("n", "<M-1>", function() vim.cmd(":Lex") end, opts_keymap)

vim.keymap.set("n", "<leader>r", function()
  local lang_table = _G.language[vim.bo.filetype]
  if lang_table and type(lang_table.run_code_on_cursor) == "function" then
    lang_table.run_code_on_cursor()
  else
    vim.notify("not implement the run code function, define a function on _G.language." .. vim.bo.filetype .. ".run_code_on_cursor function", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts_keymap, { desc = "run code on cursor" }))

vim.keymap.set("v", "<leader>r", function()
  local lang_table = _G.language[vim.bo.filetype]
  if lang_table and type(lang_table.run_selected_code) == "function" then
    lang_table.run_selected_code()
  else
    vim.notify("not implement the run code function, define a function on _G.language." .. vim.bo.filetype .. ".run_selected_code function", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts_keymap, { desc = "run selected code" }))

-- ###########################
-- #    命令定义(command)    #
-- ###########################

-- 打开设置
vim.cmd("command! Setting :e " .. _G.CONFIG_PATH .. "/init_min.lua")

-- windows下保存管理员权限文件
if _G.IS_WINDOWS then
  vim.api.nvim_create_user_command("SudoSave", function()
    -- 获取备份文件路，如果不存在就创建
    local backup_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/sudo_backup")
    if vim.fn.isdirectory(backup_dir) == 0 then
      vim.fn.mkdir(backup_dir, "p")
    end
    backup_dir = backup_dir:gsub("/", "\\")

    -- 获取当前文件的绝对路径
    local cur_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    -- 根据当前文件的路径生产一个备份文件的名称
    local format_path = backup_dir .. "\\" .. cur_path:gsub("[\\:]", "_")
    local backup_path = format_path .. ".bak"
    local new_file_path = format_path .. ".new"
    -- 执行cmd下的copy命令复制当前文件到备份文件路径
    vim.fn.system("copy /y " .. cur_path .. " " .. backup_path)
    -- 执行:w命令将当前buffer的内容保存到备份目录下的.new文件
    vim.cmd("silent w! " .. new_file_path)
    -- 使用powershell的Start-Process以管理员方式执行cmd下的type命令将.new文件覆盖当前文件
    vim.fn.system("powershell -c \"Start-Process cmd -ArgumentList '/c type " .. new_file_path .. " > " .. cur_path .. "' -Wait -Verb RunAs\"")
    -- 等待内部命令执行完后执行后续操作
    -- 删除新建的文件
    vim.fn.delete(new_file_path)
    -- 重新加载当前buffer
    vim.cmd("e!")
    print("save backup file in: " .. backup_path)
  end, { desc = "save readonly file" })
end

-- 打开终端
vim.cmd("command! TerminalOpen term " .. (_G.IS_WINDOWS and "pwsh" or "zsh"))

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
  nested = true,
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
    nested = true,
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


-- 复制时高亮
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 100, })
  end,
})


-- ###########################
-- #    补全(completion)     #
-- ###########################

-- 补全相关颜色
vim.api.nvim_set_hl(0, "Pmenu", { fg = "#cccccc", bg = "#252526" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#042e48" } )
vim.api.nvim_set_hl(0, "PmenuSBar", { bg = "#252525" } )
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#808080" } )

vim.api.nvim_set_keymap("i", "<C-j>", "<C-n>", opts_keymap) -- 修改补全弹窗的快捷键
vim.api.nvim_set_keymap("i", "<C-k>", "<C-p>", opts_keymap)
vim.api.nvim_set_keymap("i", "<C-n>", "<Nop>", opts_keymap) -- 进入insert模式下禁用
vim.api.nvim_set_keymap("i", "<C-p>", "<Nop>", opts_keymap)


-- ###########################
-- #       目录树(netrw)     #
-- ###########################

vim.g.netrw_liststyle = 3                     -- 设置文件管理模式为tree模式
vim.g.netrw_winsize = 20                       -- 设置文件管理器打开时默认的宽度
vim.g.netrw_banner = 0                        -- 不显示顶部的信息
vim.g.netrw_browse_split = 4                  -- 默认在上一个窗口打开文件(同一个窗口)
vim.g.netrw_altv = 1
vim.g.netrw_preview = 1


vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local netrw_keymap_opt = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(0, "n", "<C-l>", "<C-w>l", netrw_keymap_opt) -- 设置ctrl+l移动窗口
  end
})


-- require("utils.diff")

-- ###########################
-- #          lua            #
-- ###########################

--[[
在vim内执行lua代码，实现方式默认调用lua命令

单行直接执行
多行每行后面拼接\n后使用 lua << EOF codes EOF格式执行
]]
local function run_lua_code(codes)
  if vim.fn.empty(codes) == 1 then
    vim.notify('no code on cursor', vim.log.levels.WARN)
  elseif type(codes) == "table" then
    vim.cmd("lua << EOF\n" .. table.concat(codes, "\n") .. "\nEOF")
  elseif type(codes) == "string" then
    vim.cmd("lua " .. codes)
  end
end

_G.language.lua = {
  run_code_on_cursor = function ()
    run_lua_code(vim.trim(vim.api.nvim_get_current_line()))
  end,
  run_selected_code = function ()
    _G.util.handle_selected_region_content(function (content)
      run_lua_code(vim.tbl_map(vim.trim, content))
    end)
  end
}

-- lua 文件单独配置
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    -- 设置lua文件的tab宽度
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end
})
