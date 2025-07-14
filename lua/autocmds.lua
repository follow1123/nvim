local custom_group = vim.api.nvim_create_augroup("custom_auto_commands", { clear = true })
local filetype_group = vim.api.nvim_create_augroup("custom_filetype_options", { clear = true })

-- windows下离开insert模式后、进入vim时输入法切换为英文模式
-- linux下离开insert模式数日发切换为英文模式
if _G.IS_WINDOWS then
  vim.api.nvim_create_autocmd("InsertLeave", {
    desc = "switch to english input mode when insert mode leave",
    group = custom_group,
    command = "call system('ims.exe 1')",
  })
else
  vim.api.nvim_create_autocmd("InsertLeave", {
    desc = "switch to english input mode when insert mode leave",
    group = custom_group,
    command = "if system('fcitx5-remote') == 2 | call system('fcitx5-remote -c') | endif",
  })
end

-- 在终端模式下，vim退出后还原光标样式
if not _G.IS_GUI then
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
    vim.highlight.on_yank({ timeout = 100 })
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

vim.api.nvim_create_autocmd("FileType", {
  desc = "set some options in fronted files",
  group = filetype_group,
  pattern = {
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "markdown",
    "markdown.mdx",
    "typescript",
    "typescriptreact",
    "astro"
  },
  callback = function(e)
    local buf = e.buf
    vim.wo[vim.fn.bufwinid(buf)].colorcolumn = "120"
    local group_name = "frontend-files-format-on-save:" .. buf

    local flag = true

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup(group_name, { clear = true }),
      buffer = buf,
      callback = function()
        if not flag then return end
        local cmd = vim.fn.exepath("prettier")
        if vim.fn.empty(cmd) == 1 then return end
        vim.cmd("silent !" .. cmd .. " % -w")
      end,
    })
    vim.api.nvim_buf_create_user_command(buf, "ToggleExecFrontendActOnSave", function()
      flag = not flag
    end, { desc = "toggle execute frontend action on save", })
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("set_mdx_file_type", { clear = true }),
  pattern = "*.mdx",
  desc = "set mdx file type",
  command = "set filetype=markdown.mdx"
})
