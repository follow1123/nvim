---@alias ext.terminal.WindowSize
---| '"full"' # full screen
---| '"max"' # max screen
---| '"min"' # min screen
---| '"auto"' # auto screen size

local M = {}

---@param size ext.terminal.WindowSize
---@return vim.api.keyset.win_config
function M.generate_win_config(size)
  assert(size, "size not be nil")
  local win_height = vim.api.nvim_get_option_value("lines", {}) - vim.o.cmdheight
  local win_width = vim.api.nvim_get_option_value("columns", {})
  if size == "auto" then
    if win_height <= 30 or win_width <= 70 then
      size = "full"
    elseif win_height >= 80 and win_width >= 280 then
      size = "min"
    else
      size = "max"
    end
  end


  if size == "full" then
    return {
      relative = "editor",
      width = win_width,
      height = win_height,
      row = 0,
      col = 0,
      style = "minimal",
      border = "none",
    }
  elseif size == "max" then
    local height = math.floor(win_height * 0.8)
    local width = math.floor(win_width * 0.9)
    local row = math.floor((win_height - height) / 2)
    local col = math.floor((win_width - width) / 2)
    return {
      relative = "editor",
      height = height,
      width = width,
      row = row,
      col = col,
      border = "single",
      style = "minimal",
    }
  elseif size == "min" then
    local height = math.floor(win_height * 0.6)
    local width = math.floor(win_width * 0.7)
    local row = math.floor((win_height - height) / 2)
    local col = math.floor((win_width - width) / 2)
    return {
      relative = "editor",
      height = height,
      width = width,
      row = row,
      col = col,
      border = "single",
      style = "minimal",
    }
  else
    error("invalid window size: " .. size)
  end
end

---@param buf integer|nil
---@param key string
---@param value string
---@return boolean
function M.check_buf(buf, key, value)
  return buf ~= nil
      and vim.api.nvim_buf_is_valid(buf)
      and value == vim.api.nvim_buf_get_var(buf, key)
end

---@param win_id integer|nil
---@param key string
---@param value string
---@return boolean
function M.check_win(win_id, key, value)
  return win_id ~= nil
      and vim.api.nvim_win_is_valid(win_id)
      and value == vim.api.nvim_win_get_var(win_id, key)
end

return M
