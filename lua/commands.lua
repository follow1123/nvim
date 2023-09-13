-- ###########################
-- #        command定义      #
-- ###########################

-- 打开设置
vim.cmd("command! Setting :e " .. _G.CONFIG_PATH .. "/init.lua")

-- 格式化
vim.cmd("command! Format lua vim.lsp.buf.format()")

-- 打开终端
if _G.IS_WINDOWS then
  vim.cmd("command! TermOpen term pwsh")
else
  vim.cmd("command! TermOpen term zsh")
end

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

