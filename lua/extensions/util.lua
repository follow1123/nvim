local M = {}

-- 校验 buffer 是否有效
---@param buf integer|nil
---@return boolean
function M.check_buf(buf)
  return buf ~= nil and vim.api.nvim_buf_is_valid(buf)
end

-- 校验 win_id 是否有效
---@param win_id integer|nil
---@return boolean
function M.check_win(win_id)
  return win_id ~= nil and vim.api.nvim_win_is_valid(win_id)
end

-- 判断路径对应的文件或目录是否存在
---@param path string
---@return boolean
function M.exists(path)
  if type(path) ~= "string" then return false end
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil
end

-- 判断是否是已存在的目录
---@param path string
---@return boolean
function M.is_dir(path)
  if type(path) ~= "string" then return false end
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil and stat.type == "directory"
end

-- 判断是否是已存在文件
---@param path string
---@return boolean
function M.is_file(path)
  if type(path) ~= "string" then return false end
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

return M
