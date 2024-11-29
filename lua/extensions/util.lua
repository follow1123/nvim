local M = {}

-- 校验 buffer 是否有效
---@param buf integer
---@return boolean
function M.check_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

-- 校验 win_id 是否有效
---@param win_id integer
---@return boolean
function M.check_win(win_id)
  return win_id and vim.api.nvim_win_is_valid(win_id)
end

return M
