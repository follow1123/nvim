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
  callback = function()
    vim.opt.colorcolumn = "120" -- 限制列宽
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "netrw" },
  callback = require("extensions.netrw-plus.netrw-filetype")
})
