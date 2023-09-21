-- ###########################
-- #        command定义      #
-- ###########################

-- 打开设置
vim.cmd("command! Setting :e " .. _G.CONFIG_PATH .. "/init.lua")

-- 格式化
vim.cmd("command! Format lua vim.lsp.buf.format()")

-- 新打开终端
vim.api.nvim_create_user_command("TermNew", "lua require('extensions.terminal').new()", { desc = "New terminal" })

-- windows下保存管理员权限文件
if _G.IS_WINDOWS then
  vim.api.nvim_create_user_command("SudoSave", "lua require('extensions').sudo_save()", { desc = "save readonly file" })
end
