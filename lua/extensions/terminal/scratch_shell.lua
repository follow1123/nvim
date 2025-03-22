local Terminal = require("extensions.terminal.terminal")

local config = require("extensions.terminal.config")
local util = require("extensions.util")

---@class ext.terminal.ScratchShell
---@field terminal ext.terminal.Terminal
---@field toggle_key string
---@field buf? integer
---@field win_id? integer
---@field previous_buf? integer
local ScratchShell = {}

ScratchShell.__index = ScratchShell

---@return ext.terminal.ScratchShell
---@param toggle_key string
function ScratchShell:new(toggle_key)
  local instance = setmetatable({
    toggle_key = toggle_key,
    terminal = Terminal:new()
  }, self)
  instance.terminal.on_exit = function() instance:stop() end
  return instance
end

function ScratchShell:start()
  self.previous_buf = vim.api.nvim_get_current_buf()
  self.win_id = vim.api.nvim_get_current_win()
  self.buf = vim.api.nvim_create_buf(false, true)
  if self.buf == 0 then
    vim.notify("start float terminal failed", vim.log.levels.WARN)
    self.buf = nil
    return
  end
  vim.api.nvim_set_option_value("filetype", config.filetype, { buf = self.buf })
  self:on_buf_created()
  vim.cmd.buffer(self.buf)
  self.terminal:start()
end

---显示或隐藏浮动终端
function ScratchShell:toggle()
  if self:visible() then
    if self:is_focused() then
      self:hide()
    else
      self:focus()
    end
    return
  end
  if util.check_buf(self.buf) and self.terminal:is_running() then
    self:show()
    return
  end
  self:start()
end

---@return boolean
function ScratchShell:is_focused()
  return self.buf == vim.api.nvim_get_current_buf()
end

function ScratchShell:focus()
  if (util.check_win(self.win_id)) then
    vim.fn.win_gotoid(self.win_id)
  end
end

function ScratchShell:show()
  self.win_id = vim.api.nvim_get_current_win()
  self.previous_buf = vim.api.nvim_get_current_buf()
  vim.cmd.buffer(self.buf)
end

function ScratchShell:hide()
  vim.cmd.buffer(self.previous_buf)
  self.previous_buf = nil
end

---@return boolean
function ScratchShell:visible()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.fn.winbufnr(win)
    if (buf == self.buf) then return true end
  end
  return false
end

function ScratchShell:stop()
  self:hide()
  if util.check_buf(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end
  self.terminal:stop()
  self.buf = nil
  self.win_id = nil
end

function ScratchShell:on_buf_created()
  local tmap = require("utils.keymap").tmap
  tmap("<Esc>", [[<C-\><C-n>]], "terminal: enter normal mode in terminal", self.buf)
  tmap(self.toggle_key, function() self:toggle() end, "terminal: Toggle terminal", self.buf)
end

return ScratchShell
