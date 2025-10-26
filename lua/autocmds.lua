local custom_group = vim.api.nvim_create_augroup("custom_auto_commands", { clear = true })

-- windows下离开insert模式后、进入vim时输入法切换为英文模式
-- linux下离开insert模式数日发切换为英文模式
if vim.fn.has("linux") == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    desc = "switch to english input mode when insert mode leave",
    group = custom_group,
    command = "if system('fcitx5-remote') == 2 | call system('fcitx5-remote -c') | endif",
  })
else
  vim.api.nvim_create_autocmd("InsertLeave", {
    desc = "switch to english input mode when insert mode leave",
    group = custom_group,
    command = "call system('ims.exe 1')",
  })
end

-- 在终端模式下，vim退出后还原光标样式
if vim.fn.has("gui_running") ~= 1 then
  vim.api.nvim_create_autocmd("VimLeave", {
    desc = "set cursor sytle to bar when exit vim",
    group = custom_group,
    command = "set guicursor+=n-v-c:blinkon500-blinkoff500,a:ver25",
  })
end

-- 复制时高亮
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight yanked text",
  group = custom_group,
  callback = function()
    vim.hl.on_yank({ timeout = 100 })
  end,
})

-- check big file syntax off
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "disable syntax highlighting when entering large files",
  group = custom_group,
  callback = function(args)
    local max_file_size = 1024 * 1024 -- 1MB in bytes

    local stat, err = (vim.uv or vim.loop).fs_stat(args.match)
    if err or not stat then
      return
    end

    if stat.size > max_file_size then
      vim.opt_local.syntax = "off"
    end
  end,
})

-- 将 mdx 文件类型设置为 markdown 适配 markdown 的语法高亮和代码片段
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("set_mdx_file_type", { clear = true }),
  pattern = "*.mdx",
  desc = "set mdx file type",
  command = "set filetype=markdown"
})
