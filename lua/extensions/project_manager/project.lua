---@class ext.projectmanager.Project
---@field root_path string
---@field session_path string
---@field mod_time integer
local Project = {}

---@private
Project.__index = Project

---@param session_root string
---@param root_path string
---@return ext.projectmanager.Project
function Project:new(session_root, root_path)
  local stat, err = vim.uv.fs_stat(root_path)
  assert(stat ~= nil and stat.type == "directory",
    string.format("create project %s error: %s", root_path, err))
  root_path = vim.fs.normalize(root_path)
  local session_name = Project.encode_session_name(root_path)
  local session_path = vim.fs.joinpath(session_root, session_name)
  session_path = vim.fs.normalize(session_path)
  return setmetatable({ root_path = root_path, session_path = session_path, mod_time = 0 }, self)
end

---@param session_root string
---@param session_name string
---@return ext.projectmanager.Project
function Project:from_session(session_root, session_name)
  local session_path = vim.fs.joinpath(session_root, session_name)
  local stat, err = vim.uv.fs_stat(session_path)
  assert(stat ~= nil and stat.type == "file",
    string.format("project from session %s error: %s", session_path, err))

  local root_path = Project.decode_session_name(session_name)
  return setmetatable({ root_path = root_path, session_path = session_path, mod_time = stat.mtime.sec }, self)
end

---@return boolean
function Project:init()
  return vim.fn.writefile({}, self.session_path) ~= -1
end

---@param session_options string[]
---@return boolean
---@return string|nil
function Project:save(session_options)
  assert(session_options, "session_options not be nil")
  local default_options = vim.opt.sessionoptions
  vim.opt.sessionoptions = session_options
  local success, err = pcall(vim.cmd.mksession, {
    args = { vim.fn.fnameescape(self.session_path) },
    bang = true
  })
  vim.opt.sessionoptions = default_options
  return success, err
end

---@return boolean
---@return string|nil
function Project:delete()
  local result, err = vim.uv.fs_unlink(self.session_path)
  return result ~= nil, err
end

---@return boolean
function Project:is_saved()
  local stat = vim.uv.fs_stat(self.session_path)
  return stat ~= nil and stat.type == "file"
end

---@return boolean
---@return string|nil
function Project:load()
  local success, err = pcall(vim.cmd.source, {
    args = { vim.fn.fnameescape(self.session_path) },
    mods = { silent = true }
  })
  return success, err
end

---replace path separator to %
---`/a/b/c` -> `%a%b%c`
---`C:/a/b/c` -> `C%%a%b%c` on windows
---@param path string
---@return string
function Project.encode_session_name(path)
  path = vim.fs.normalize(path)
  local pattern = vim.fn.has("unix") == 1 and "/" or "[/:]"
  local session_name = string.gsub(path, pattern, "%%")
  return session_name .. ".vim"
end

---restore path separator
---`%a%b%c` -> `/a/b/c`
---`C%%a%b%c` -> `C:/a/b/c` on windows
function Project.decode_session_name(name)
  name = vim.fn.fnamemodify(name, ":t:r")
  local path, count = string.gsub(name, "%%", "/")
  assert(count > 0, "name is not contains %")
  if vim.fn.has("unix") ~= 1 then
    path = string.gsub(path, "//", ":/", 1)
  end
  return path
end

return Project
