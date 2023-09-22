-- ###########################
-- #        扩展小功能       #
-- ###########################

local ext = {}

-- windows下保存管理员权限文件
if _G.IS_WINDOWS then
  -- 获取备份文件路径，如果不存在就创建
  local backup_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/sudo_backup")
  if vim.fn.isdirectory(backup_dir) == 0 then
    vim.fn.mkdir(backup_dir, "p")
  end
  backup_dir = backup_dir:gsub("/", "\\")
  ext.sudo_save = function ()
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
    vim.cmd("silent w! " .. new_file_path)
    -- 使用powershell的Start-Process以管理员方式执行cmd下的type命令将.new文件覆盖当前文件
    local result = vim.fn.system("powershell -c \"Start-Process cmd -ArgumentList '/c type " .. new_file_path .. " > " .. cur_path .. "' -Wait -Verb RunAs\"")
    if vim.v.shell_error ~= 0 then
      vim.notify("save file error:\n" .. result, vim.log.levels.WARN)
      return
    end
    -- 删除新建的文件
    vim.fn.delete(new_file_path)
    -- 重新加载当前buffer
    vim.cmd("e!")
    vim.notify("save backup file in: " .. backup_path, vim.log.levels.INFO)
  end
end

-- 快捷关闭窗口或Buffer
-- 如果当前窗口的buffer是共享的，则只关闭当前窗口，否则直接关闭当前的buffer
-- 如果当前buffer是最后一个listed的buffer则提示使用:q方式关闭
ext.smart_quit = function ()
  local cur_bufnr = vim.api.nvim_get_current_buf()
  local listed_buf = vim.fn.getbufinfo({buflisted = 1})
  local is_listed_buf = false
  for _, buf in ipairs(listed_buf) do
    if buf.bufnr == cur_bufnr then
      --  如果当前窗口是listed的buffer，并且是Command Line窗口，或有共享当前buffer的窗口，则使用wincmd c关闭窗口
      if #buf.windows > 1 or string.match(buf.name, "Command Line") then
        vim.cmd("wincmd c")
        return
      end
      is_listed_buf = true
      break
    end
  end
  -- 判断是否为listed的buffer
  if not is_listed_buf then
    local ok, _ = pcall(vim.api.nvim_command, "wincmd c")
    if not ok then
      vim.cmd("bdelete!")
    end
  end
  -- 判断是否还有其他的buffer
  if #listed_buf <= 1 then
    vim.notify("is last buffer, use :q to exit vim", vim.log.levels.WARN)
    return
  end
  -- 直接删除buffer
  vim.cmd("bdelete!")
end

return ext
