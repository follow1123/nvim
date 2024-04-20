-- ###########################
-- #        格式化插件       #
-- ###########################
local M = {}

-- 格式化配置，不同类型的文件使用不同的工具
local ft_formatter = {
  json = {
    cmd = "1,$!jq",
    check_cmd = "jq --version",
  },
  xml = {
    cmd = "1,$!xmllint --format %",
    check_cmd = "xmllint --version",
  }
}

---判断公式化文件使用的命令行工具是否存在
local function checkhealth(check_cmd)
  local msg = vim.fn.system(check_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return false
  end
  return true
end

---@param filetype string | nil 文件类型
--- 格式化操作
function M.format(filetype)
  filetype = vim.fn.empty(filetype) == 0 and filetype or vim.bo.filetype
  local file_formatter = ft_formatter[filetype]
  if file_formatter and checkhealth(file_formatter.check_cmd) then
    vim.cmd(file_formatter.cmd)
  else
    -- 没有配置格式化工具或则格式化工具不存在，则使用默认的格式化方式
    vim.cmd("normal gg=G")
  end
end

return M
