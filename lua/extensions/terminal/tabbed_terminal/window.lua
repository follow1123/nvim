local WIN_KEY = "tabbed_terminal_window"
local WIN_VAL = "1"

---@class ext.terminal.tabbed.Window
---@field private id? integer
local Window = {}

---@private
Window.__index = Window

function Window:new()
  return setmetatable({}, self)
end

---@param buf integer
function Window:open(buf)
  local win_id = vim.api.nvim_open_win(buf, true, self.generate_config())

  vim.api.nvim_win_set_var(win_id, WIN_KEY, WIN_VAL)

  -- 这两个属性需要事件完成后执行才能正常设置
  vim.schedule_wrap(vim.api.nvim_set_option_value)("wrap", true, { win = win_id })
  vim.schedule_wrap(vim.api.nvim_set_option_value)("signcolumn", "no", { win = win_id })

  vim.api.nvim_set_option_value("number", false, { win = win_id })
  vim.api.nvim_set_option_value("relativenumber", false, { win = win_id })
  vim.api.nvim_set_option_value("winhighlight", "Normal:Normal", { win = win_id })
  self.id = win_id
end

function Window:close()
  vim.api.nvim_win_close(self.id, true)
  self.id = nil
end

---@return boolean
function Window:is_focused()
  return self.check_win(self.id) and vim.api.nvim_get_current_win() == self.id
end

function Window:focus()
  vim.api.nvim_set_current_win(self.id)
end

---@return boolean
function Window:visible()
  return self.check_win(self.id)
end

---@param buf integer
function Window:set_buf(buf)
  vim.api.nvim_win_set_buf(self.id, buf)
end

---@param title string
function Window:set_title(title)
  vim.api.nvim_win_set_config(self.id, { title = title, })
end

---@return integer
function Window:get_id()
  assert(self.check_win(self.id), "invalid window")
  return self.id
end

---@private
---@param win_id integer
---@return boolean
function Window.check_win(win_id)
  return win_id ~= nil
      and vim.api.nvim_win_is_valid(win_id)
      and WIN_VAL == vim.api.nvim_win_get_var(win_id, WIN_KEY)
end

---@private
function Window.generate_config(conf)
  local window_height = vim.api.nvim_get_option_value("lines", {})
  local window_width = vim.api.nvim_get_option_value("columns", {})
  local height = math.floor(window_height * 0.8)
  local width = math.floor(window_width * 0.9)
  local row = math.floor((window_height - height) / 2)
  local col = math.floor((window_width - width) / 2)

  local default_win_conf = {
    relative = "editor",
    height = height,
    width = width,
    row = row,
    col = col,
    border = "single",
    style = "minimal",
  }
  if conf == nil then return default_win_conf end
  return vim.tbl_extend("keep", conf, default_win_conf)
end

return Window
