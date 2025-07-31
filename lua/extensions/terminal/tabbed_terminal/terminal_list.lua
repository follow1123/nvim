---@class ext.terminal.tabbed.TerminalList
---@field data ext.terminal.tabbed.Terminal[]
---@field current_idx integer
local TerminalList = {}

TerminalList.__index = TerminalList

function TerminalList:new()
  return setmetatable({ data = {}, current_idx = 1 }, self)
end

---@return ext.terminal.tabbed.Terminal
function TerminalList:current()
  assert(not self:is_empty(), "empty terminal list")
  assert(self.current_idx >= 1 and self.current_idx <= #self.data,
    string.format("invalid index: %d, data size: %d", self.current_idx, #self.data))
  local terminal = self.data[self.current_idx]
  assert(terminal:is_valid(), "invalid terminal")
  return terminal
end

---@param next boolean
---@return ext.terminal.tabbed.Terminal
function TerminalList:nav(next)
  self.current_idx = self.adjust_idx(self.current_idx, #self.data, next)
  return self:current()
end

---@param terminal ext.terminal.tabbed.Terminal
function TerminalList:add(terminal)
  table.insert(self.data, terminal)
  self.current_idx = #self.data
end

---@param buf integer
function TerminalList:remove(buf)
  for i, t in ipairs(self.data) do
    if t.buf == buf then
      table.remove(self.data, i)
      break
    end
  end
  if self.current_idx >= #self.data then
    self.current_idx = #self.data
  elseif self.current_idx <= 0 then
    self.current_idx = 1
  end
end

---@return boolean
function TerminalList:only_one()
  return #self.data == 1
end

---@return boolean
function TerminalList:is_empty()
  return #self.data == 0
end

---@return integer
function TerminalList:size()
  return #self.data
end

---@param idx integer
---@param len integer
---@param next boolean
---@return integer
function TerminalList.adjust_idx(idx, len, next)
  local target_idx = next and idx + 1 or idx - 1
  return (target_idx - 1) % len + 1
end

-- local function adjust_idx(idx, len, next)
--   local target_idx = next and idx + 1 or idx - 1
--   return (target_idx - 1) % len + 1
-- end
--
-- print(adjust_idx(4, 3, true))

return TerminalList
