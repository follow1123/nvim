-- ###########################
-- #       目录树(netrw)     #
-- ###########################
local netrw = {}

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

netrw.toggle = function()
  vim.cmd(":Lex")
end

return netrw
