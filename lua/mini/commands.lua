-- ###########################
-- #        command定义      #
-- ###########################

-- 新打开终端
vim.api.nvim_create_user_command("TermNew", "lua require('mini.extensions.terminal').new()", { desc = "New terminal" })

-- windows下保存管理员权限文件
if _G.IS_WINDOWS then
  vim.api.nvim_create_user_command("SudoSave", "lua require('mini.extensions').sudo_save()", { desc = "save readonly file" })
end


-- 设置文件类型
vim.api.nvim_create_user_command("Json", "set filetype=json", {bang = true})
vim.api.nvim_create_user_command("Xml", "set filetype=xml", {bang = true})

-- 默认格式化方式，以缩进格式化
vim.api.nvim_create_user_command("Format", "lua require('mini.extensions.formatter').format()", {bang = true})
