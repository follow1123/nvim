local util = require("extensions.terminal.util")

local WIN_KEY = "tabbed_terminal_window"
local WIN_VAL = "1"

---@class ext.terminal.tabbed.Window
---@field private id? integer
---@field private size ext.terminal.WindowSize
local Window = {}

---@private
Window.__index = Window

---@param size ext.terminal.WindowSize
---@return ext.terminal.tabbed.Window
function Window:new(size)
  return setmetatable({ size = size }, self)
end

---@param buf integer
function Window:open(buf)
  local win_id = vim.api.nvim_open_win(buf, true, util.generate_win_config(self.size))

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
  return self:visible() and vim.api.nvim_get_current_win() == self.id
end

function Window:focus()
  vim.api.nvim_set_current_win(self.id)
end

---@return boolean
function Window:visible()
  return util.check_win(self.id, WIN_KEY, WIN_VAL)
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
  assert(self:visible(), "invalid window")
  return self.id
end

return Window
