-- ###########################
-- #        格式化插件       #
-- ###########################
local formatter = {}

-- 临时文件存放路径
local format_tmp_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/format_tmp")

-- 加载这个插件时判断临时文件是否存在，不存在就创建
if vim.fn.isdirectory(format_tmp_path) == 0 then
  vim.schedule_wrap(vim.fn.mkdir)(format_tmp_path)
end

-- 根据文件类型生成临时文件路径
local function get_tmp_format_file(filetype)
  return vim.fs.normalize(format_tmp_path .. "/" .. filetype .. "_" .. vim.fn.strftime("%d%I%M%S") .. "." .. filetype)
end

-- 格式化配置，不同类型的文件使用不同的工具
local ft_formatter = {
  json = {
    cmd = _G.IS_WINDOWS and "jq \".\" %s" or "jq '.' %s",
    check_cmd = "jq --version",
    handle_result = function(result)
      return vim.split(result, "\n")
    end
  },
  xml = {
    cmd = "xmllint --format %s",
    check_cmd = "xmllint --version",
    handle_result = function(result)
      local text_list = vim.split(result, "\n")
      table.remove(text_list, 1)
      return text_list
    end
  }
}

-- 判断公式化文件使用的命令行工具是否存在
local function checkhealth(check_cmd)
  local msg = vim.fn.system(check_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return false
  end
  return true
end

-- 格式化操作
formatter.format = function ()
  local filetype = vim.bo.filetype
  local file_formatter = ft_formatter[filetype]
  if file_formatter and checkhealth(file_formatter.check_cmd) then
    -- 使用vim的事件loop执行这个操作
    vim.schedule(function ()
      -- 保存当前文件到临时文件路径
      local tmp_path = get_tmp_format_file(filetype)
      vim.cmd("silent w! " .. tmp_path)
      -- 执行格式化命令
      local result = vim.fn.system(string.format(file_formatter.cmd, tmp_path))
      if vim.v.shell_error == 0 then
        -- 替换当前buffer内的文本
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
        vim.api.nvim_buf_set_lines(0, 0, -1, false, file_formatter.handle_result(result))
      else
        vim.notify(result, vim.log.levels.WARN)
      end
      -- 删除临时文件
      vim.fn.delete(tmp_path)
    end)
  else
    -- 没有配置格式化工具或则格式化工具不存在，则使用默认的格式化方式
    vim.cmd("normal gg=G")
  end
end

return formatter
