local M = {}

-- 获取文件的绝对路径
---@return string
function M.get_file_path()
  return vim.fs.normalize(
    vim.fn['netrw#Call']('NetrwFile', vim.fn['netrw#Call']('NetrwGetWord')))
end

-- 复制绝对路径
function M.copy_absolute_path()
  vim.fn.setreg("+", M.get_file_path())
end

-- 复制相对路径
function M.copy_relative_path()
  vim.fn.setreg("+", vim.fn.fnamemodify(M.get_file_path(), ":."))
end

-- 获取可见窗口内是否有 netrw 窗口
---@return integer|nil winid
function M.get_visible_netrw_winid()
  local wins = vim.api.nvim_list_wins()
  for _, winid in ipairs(wins) do
    local ft = vim.api.nvim_get_option_value("filetype", { win = winid })
    if ft == "netrw" then
      return winid
    end
  end
  return nil
end

-- 判断路径是否属于当前工作路径
---@param cwd string current working directory
---@param path string
---@return boolean
function M.in_cwd(cwd, path)
  local cwd_pattern = "^" .. vim.fs.normalize(cwd) .. "/"
  path = vim.fs.normalize(path)
  return path:match(cwd_pattern) ~= nil
end

return M
