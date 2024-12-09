local util = require("extensions.util")

---@class Netrw
---@field prev_buf integer 打开 netrw 窗口的 buffer
---@field netrw_buffer_map table<string, integer> key: netrw 路径，路径必须使用 / 分割。 value: netrw buffer
local Netrw = {}

local netrw_cmd = "Explore"
local netrw_filetype = "netrw"

---@param path string
---@param parent string
---@return boolean
function Netrw.is_sub_folder(path, parent)
  path = vim.fs.normalize(path)
  parent = vim.fs.normalize(parent)
  if _G.IS_WINDOWS then
    path = path:lower()
    parent = parent:lower()
  end
  local parent_pattern = parent .. "/"
  return path:sub(1, #parent_pattern) == parent_pattern
end

-- 判断路径是否属于当前工作路径
---@param path string
---@return boolean
function Netrw.in_working_dir(path)
  return Netrw.is_sub_folder(path, vim.fn.getcwd())
end

---@return Netrw
function Netrw:new()
  self.__index = self
  return setmetatable({}, self)
end

---@param path string
---@param buf integer
---@return boolean succeed
function Netrw:put_netrw_buffer(path, buf)
  if self.netrw_buffer_map == nil then self.netrw_buffer_map = {} end
  if not self:check_netrw_buffer(buf) then return false end
  if not util.is_dir(path) then return false end
  path = vim.fs.normalize(path)
  self.netrw_buffer_map[path] = buf
  return true
end

---@param path string
---@return integer|nil buf
function Netrw:get_netrw_buffer(path)
  if self.netrw_buffer_map == nil then return nil end
  if not util.is_dir(path) then return nil end
  return self.netrw_buffer_map[vim.fs.normalize(path)]
end

---@param buf integer
---@return boolean
function Netrw:check_netrw_buffer(buf)
  local ok = util.check_buf(buf)
  if not ok then return false end
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
  return ft == netrw_filetype
end

-- 打开或创建 path 路径对应的 netrw buffer
---@param path string 需要使用 netrw 打开的目录路径
---@return integer netrw_buf 返回一个已经存在的 netrw buffer handle 或创建一个并返回
function Netrw:open_netrw(path)
  local netrw_buf = self:get_netrw_buffer(path)
  if netrw_buf == nil or not self:check_netrw_buffer(netrw_buf) then
    vim.cmd { cmd = netrw_cmd, args = { path } }
    netrw_buf = vim.api.nvim_get_current_buf()
    self:put_netrw_buffer(path, netrw_buf)
  else
    vim.cmd.buffer(netrw_buf)
  end
  return netrw_buf
end

---@param buf integer
function Netrw:set_prev_buf(buf)
  if self:check_netrw_buffer(buf) then return end
  local path = vim.api.nvim_buf_get_name(buf)
  if not util.is_file(path) then return end
  self.prev_buf = buf
end

---@return integer|nil buf
function Netrw:get_prev_buf()
  if self.prev_buf ~= nil then return self.prev_buf end
  local buf = vim.fn.bufnr("#")
  if buf == -1 then return nil end
  local path = vim.api.nvim_buf_get_name(buf)
  return util.is_file(path) and buf or nil
end

function Netrw:open()
  self:set_prev_buf(vim.api.nvim_get_current_buf())
  if self.prev_buf == nil then
    self:open_netrw(vim.fn.getcwd())
    return
  end
  local full_path = vim.api.nvim_buf_get_name(self.prev_buf)
  local dir = self:get_target_dir(full_path)
  if dir == nil then
    self:open_netrw(vim.fn.getcwd())
  else
    self:open_netrw(dir)
    vim.fn.search(vim.fn.fnamemodify(full_path, ":t"))
  end
end

function Netrw:close()
  local buf = self:get_prev_buf()
  if buf == nil then
    vim.cmd.bwipeout()
  else
    vim.cmd.buffer(buf)
  end
end

---@return integer|nil
function Netrw:get_visible_netrw()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.fn.winbufnr(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if netrw_filetype == ft then return buf end
  end
  return nil
end

---@return boolean
function Netrw:is_focused()
  return vim.o.filetype == netrw_filetype
end

---@param buf integer|nil
function Netrw:focus(buf)
  assert(buf, "buf is nil")
  local win_id = vim.fn.bufwinid(buf)
  vim.fn.win_gotoid(win_id)
end

function Netrw:toggle()
  local netrw_buf = self:get_visible_netrw()
  if netrw_buf == nil then self:open() return end
  if self:is_focused() then
    self:close()
  else
    self:focus(netrw_buf)
  end
end

---@param path string
---@return string|nil
function Netrw:get_target_dir(path)
  assert(path ~= nil, "path is nil")
  local dir = vim.fs.normalize(vim.fn.fnamemodify(path, ":h"))
  if not self.in_working_dir(path) then return nil end
  return dir
end

function Netrw:get_file_path()
  return vim.fs.normalize(
    vim.fn['netrw#Call']('NetrwFile', vim.fn['netrw#Call']('NetrwGetWord')))
end

---@param file_full_path string
---@param netrw_buf? integer
function Netrw:locate_file(file_full_path, netrw_buf)
  local in_netrw_buffer
  if netrw_buf == nil then
    netrw_buf = vim.api.nvim_get_current_buf()
    in_netrw_buffer = true
  end
  if not util.is_file(file_full_path) then return end
  if not self:check_netrw_buffer(netrw_buf) then return end
  local netrw_path = vim.api.nvim_buf_get_name(netrw_buf)
  local file_dir = vim.fn.fnamemodify(file_full_path, ":h")
  local filename = vim.fn.fnamemodify(file_full_path, ":t")
  -- 在 netrw buffer 内定位指定的文件
  local function focus_filename()
    -- 如果 netrw buffer 所在的文件夹和指定文件不是同一个，先打开指定文件夹
    if not self.is_sub_folder(file_full_path, netrw_path) then
      self:open_netrw(file_dir)
    end
    local row = vim.fn.search(filename)
    if row > 0 then vim.api.nvim_win_set_cursor(0 or 0, { row, 0 }) end
  end
  if in_netrw_buffer then
    focus_filename()
  else
    vim.api.nvim_buf_call(netrw_buf, focus_filename)
  end
end

return Netrw
