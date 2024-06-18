-- ###########################
-- #        格式化插件       #
-- ###########################
local M = {}

-- 格式化配置，不同类型的文件使用不同的工具
local ft_formatter = {
  json = {
    name = "jq",
    cmd = "1,$!jq",
  },
  xml = {
    name = "xmllint",
    cmd = "1,$!xmllint --format %",
  }
}

---@param filetype string | nil 文件类型
--- 格式化操作
function M.format(filetype)
  filetype = vim.fn.empty(filetype) == 0 and filetype or vim.bo.filetype
  local file_formatter = ft_formatter[filetype]
  if file_formatter and vim.fn.executable(file_formatter.name) == 1 then
    vim.cmd(file_formatter.cmd)
  else
    vim.cmd.normal("gg=G")
  end
end

return M
