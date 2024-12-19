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
