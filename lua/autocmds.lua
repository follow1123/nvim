-- windows下离开insert模式后、进入vim时输入法切换为英文模式
-- linux下离开insert模式数日发切换为英文模式
if _G.IS_WINDOWS then
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    nested = true, -- 允许嵌套
    callback = function() vim.fn.system("ims.exe 1") end,
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

-- 在终端模式下，vim退出后还原光标样式
if not _G.IS_GUI then
  vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    nested = true,
    callback = function()
      vim.opt.guicursor:append("a:ver25")
      vim.opt.guicursor:append("a:blinkon1")
      vim.opt.guicursor:append("a:blinkoff1")
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

-- check big file syntax off
vim.api.nvim_create_autocmd("BufEnter", {
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
  pattern = { "html", "javascriptreact", "typescriptreact" },
  desc = "set some options",
  callback = function()
    vim.opt.colorcolumn = "120" -- 限制列宽
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "query",
  desc = "set some options in query filetype",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  desc = "set some options in lua file",
  callback = function(args)
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    local nmap = require("utils.keymap").nmap
    local vmap = require("utils.keymap").vmap

    nmap("<M-r>", "<cmd>lua require('utils.lang.lua').run_code()<cr>", "lua: execute code", args.buf)

    vmap("<M-r>", "<cmd>lua require('utils.lang.lua').run_selected_code()<cr>",
      "lua: execute selected code", args.buf)
  end
})
