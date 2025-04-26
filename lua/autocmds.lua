local base_group = vim.api.nvim_create_augroup("base_auto_command", { clear = true })
-- windows下离开insert模式后、进入vim时输入法切换为英文模式
-- linux下离开insert模式数日发切换为英文模式
if _G.IS_WINDOWS then
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = base_group,
    command = "call system('ims.exe 1')"
  })
else
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = base_group,
    command = "if system('fcitx5-remote') == 2 | call system('fcitx5-remote -c') | endif"
  })
end

-- 在终端模式下，vim退出后还原光标样式
if not _G.IS_GUI then
  vim.api.nvim_create_autocmd("VimLeave", {
    group = base_group,
    command = "set guicursor+=n-v-c:blinkon500-blinkoff500,a:ver25"
  })
end

-- 复制时高亮
vim.api.nvim_create_autocmd("TextYankPost", {
  group = base_group,
  callback = function()
    vim.highlight.on_yank({ timeout = 100, })
  end,
})

-- check big file syntax off
vim.api.nvim_create_autocmd("BufEnter", {
  group = base_group,
  callback = function(args)
    local max_file_size = 1024 * 1024  -- 1MB in bytes

    local stat, err = (vim.uv or vim.loop).fs_stat(args.match)
    if err or not stat then return end

    if stat.size > max_file_size then
      vim.opt_local.syntax = "off"
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = base_group,
  pattern = { "html", "javascriptreact", "typescriptreact" },
  desc = "set some options",
  callback = function()
    vim.opt.colorcolumn = "120" -- 限制列宽
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = base_group,
  pattern = "query",
  desc = "set some options in query filetype",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = base_group,
  pattern = "lua",
  desc = "set some options in lua file",
  callback = function(args)
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    local nmap = require("utils.keymap").nmap
    local vmap = require("utils.keymap").vmap

    nmap("<space>x", ":.lua<cr>", "lua: execute code", args.buf)
    vmap("<space>x", ":lua<cr>", "lua: execute selected code", args.buf)
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = base_group,
  pattern = "sh",
  desc = "set some options in shell file",
  callback = function(args)
    local nmap = require("utils.keymap").nmap
    local vmap = require("utils.keymap").vmap

    nmap("<space>x", ":execute '!' . getline('.')<cr>", "shell: execute code", args.buf)
    vmap("<space>x", function()
      vim.api.nvim_input("<esc>")
      vim.schedule(function ()
        -- 获取选区的起止行（注意 Lua 下标从 1 开始，get_lines 是从 0 开始）
        local start_pos = vim.api.nvim_buf_get_mark(0, "<")
        local end_pos = vim.api.nvim_buf_get_mark(0, ">")
        local start_line = start_pos[1] - 1
        local end_line = end_pos[1]

        -- 获取选中的行内容
        local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

        -- 拼接为一整个 bash 命令
        local cmd = table.concat(lines, "\n")

        -- 执行命令
        local result = vim.fn.system({ "bash", "-c", cmd })

        -- 显示输出结果
        vim.notify(result, vim.log.levels.INFO)
      end)
    end, "shell: execute selected code", args.buf)
  end
})
