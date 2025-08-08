local COMMAND = "Explore"
local FILETYPE = "netrw"

---@class ext.netrwplus.Netrw
---@field previous_buf? integer
local Netrw = {}

---@private
Netrw.__index = Netrw

---@return ext.netrwplus.Netrw
function Netrw:new()
  return setmetatable({}, self)
end

function Netrw:toggle()
  if self:visible() then
    if not self:is_focused() then
      self:focus()
      return
    end
    self:close()
  else
    self:open()
  end
end

---@private
function Netrw:open()
  local buf = vim.api.nvim_get_current_buf()
  if self.is_netrw(buf) then return end
  self:set_previous_buf(buf)
  local buf_path = vim.api.nvim_buf_get_name(buf)
  local filename = vim.fn.fnamemodify(buf_path, ":t")
  vim.cmd(COMMAND)
  local row = vim.fn.search(filename)
  if row > 0 then vim.api.nvim_win_set_cursor(0, { row, 0 }) end
end

---@private
function Netrw:close()
  if not self.is_netrw(vim.api.nvim_get_current_buf()) then return end
  local prev_buf = self:get_previous_buf()
  if prev_buf == nil then
    vim.cmd.bwipeout()
  else
    vim.cmd.buffer(prev_buf)
  end
  self.previous_buf = nil
end

---@private
---@return boolean
function Netrw:visible()
  local it = vim.iter(vim.api.nvim_list_wins())
  return it:find(function(w)
    local buf = vim.api.nvim_win_get_buf(w)
    return FILETYPE == vim.api.nvim_get_option_value("filetype", { buf = buf })
  end) ~= nil
end

---@private
---@return boolean
function Netrw:is_focused()
  return vim.api.nvim_get_option_value("filetype", {}) == FILETYPE
end

---@private
function Netrw:focus()
  local wins = vim.api.nvim_list_wins()
  for _, win_id in ipairs(wins) do
    if FILETYPE == vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win_id) }) then
      vim.api.nvim_set_current_win(win_id)
      return
    end
  end
end

---@param buf integer
function Netrw:set_previous_buf(buf)
  if self.is_netrw(buf) then return end
  self.previous_buf = buf
end

---@return integer|nil
function Netrw:get_previous_buf()
  if self.previous_buf == nil or self.is_netrw(self.previous_buf) then
    -- 使用内置api查找上次访问的buffer
    local buf = vim.fn.bufnr("#")
    if vim.api.nvim_buf_is_valid(buf) then
      if self.is_netrw(buf) then return nil end
      return buf
    else
      return nil
    end
  end
  return self.previous_buf
end

---@private
---@param buf integer|nil
---@return boolean
function Netrw.is_netrw(buf)
  return buf ~= nil
      and vim.api.nvim_buf_is_valid(buf)
      and FILETYPE == vim.api.nvim_get_option_value("filetype", { buf = buf })
end

---@return string
function Netrw.get_file_path()
  return vim.fs.normalize(
    vim.fn['netrw#Call']('NetrwFile', vim.fn['netrw#Call']('NetrwGetWord')))
end

return Netrw
