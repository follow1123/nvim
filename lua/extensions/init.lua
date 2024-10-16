-- ###########################
-- #        扩展小功能       #
-- ###########################

local M = {}

-- windows下保存管理员权限文件
if _G.IS_WINDOWS then
  -- 获取备份文件路径，如果不存在就创建
  local backup_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/sudo_backup")
  if vim.fn.isdirectory(backup_dir) == 0 then
    vim.fn.mkdir(backup_dir, "p")
  end
  backup_dir = backup_dir:gsub("/", "\\")
  function M.sudo_save()
    -- 获取当前文件的绝对路径
    local cur_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    -- 根据当前文件的路径生产一个备份文件的名称
    local format_path = backup_dir .. "\\" .. cur_path:gsub("[\\:]", "_")
    local backup_path = format_path .. ".bak"
    local new_file_path = format_path .. ".new"
    -- 备份文件
    local status = vim.loop.fs_copyfile(cur_path, backup_path)
    if not status then
      vim.notify("copy backup file failed", vim.log.levels.WARN)
      return
    end
    -- 执行:w命令将当前buffer的内容保存到备份目录下的.new文件
    vim.cmd.w({
      bang = true,
      mods = { silent = true },
      args = { new_file_path }
    })
    -- 使用powershell的Start-Process以管理员方式执行cmd下的type命令将.new文件覆盖当前文件
    local result = vim.fn.system("powershell -c \"Start-Process cmd -ArgumentList '/c type " .. new_file_path .. " > " .. cur_path .. "' -Wait -Verb RunAs\"")
    if vim.v.shell_error ~= 0 then
      vim.notify("save file error:\n" .. result, vim.log.levels.WARN)
      return
    end
    -- 删除新建的文件
    vim.fn.delete(new_file_path)
    -- 重新加载当前buffer
    vim.cmd.e({ bang = true })
    vim.notify("save backup file in: " .. backup_path, vim.log.levels.INFO)
  end
end

return M
