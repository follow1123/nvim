local util = require("extensions.util")

---@meta
---@class Project
---@field dir string
---@field session_file_path string
local Project = {}

Project.session_options = { "curdir", "buffers", "tabpages", "winsize", "folds" }
Project.session_root = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")
Project.root_path_patterns = { "cargo.toml", "package.json", "makefile", "lua", "lazy-lock.json", ".git" }

---replace path separator to %
---`/a/b/c` -> `%a%b%c`
---`C:/a/b/c` -> `C%%a%b%c` on windows
---@param path string
---@return string
function Project.path2name(path)
  path = vim.fs.normalize(path)
  local pattern = _G.IS_WINDOWS and "[/:]" or "/"
  local session_name = string.gsub(path, pattern, "%%")
  return session_name
end

---restore path separator
---`%a%b%c` -> `/a/b/c`
---`C%%a%b%c` -> `C:/a/b/c` on windows
---@param name string
---@return string
function Project.name2path(name)
  local path, count = string.gsub(name, "%%", "/")
  assert(count > 0, "name is not contains %")
  if _G.IS_WINDOWS then
    path = string.gsub(path, "//", ":/", 1)
  end
  return path
end

---@param path string
---@return string root_path
function Project.find_root(path)
  local results = vim.fs.find(Project.root_path_patterns, {
    path = path,
    upward = true
  })
  path = (results and #results == 1) and results[1] or path
  return vim.fn.fnamemodify(path, ":h")
end

---@param project_dir string
---@return string session_file_path
function Project:generate_session_file_path(project_dir)
  return self.session_root .. self.path2name(project_dir) .. ".vim"
end

---@param session_filename string
---@return string project_dir
function Project:parse_project_dir(session_filename)
  return self.name2path(vim.fn.fnamemodify(session_filename, ":t:r"))
end

function Project.init_session_root()
  if not util.is_dir(Project.session_root) then
    local success, err_name, err_msg = vim.uv.fs_mkdir(Project.session_root, tonumber("755", 8))
    assert(success, string.format("create session root error. %s, %s", err_name, err_msg))
  end
end

---@param project_dir string
---@return Project
function Project:new(project_dir)
  assert(util.is_dir(project_dir), string.format("project_dir: %s not exists or not a directory", project_dir))
  self.__index = self
  project_dir = vim.fs.normalize(project_dir)
  local project = setmetatable({ dir = project_dir }, self)
  project.session_file_path = project:generate_session_file_path(project_dir)
  return project
end

---@param session_filename string
---@return Project
function Project:from_session(session_filename)
  local project_dir = self.name2path(vim.fn.fnamemodify(session_filename, ":t:r"))
  return self:new(project_dir)
end

---@return boolean
function Project:save()
  local def_opts = vim.opt.sessionoptions:get()
  vim.opt.sessionoptions = self.session_options
  local success = pcall(vim.cmd.mksession, {
    args = { vim.fn.fnameescape(self.session_file_path) },
    bang = true
  })
  vim.opt.sessionoptions = def_opts
  return success
end

---@return boolean
function Project:is_saved()
  return util.is_file(self.session_file_path)
end

---@return boolean
function Project:delete()
  assert(self:is_saved(), string.format("session file: %s not exists", self.session_file_path))
  local success = vim.uv.fs_unlink(self.session_file_path)
  return success ~= nil
end

---@return boolean
function Project:load()
  assert(self:is_saved(), string.format("session file: %s not exists", self.session_file_path))
  local success = pcall(vim.cmd.source, {
    args = { vim.fn.fnameescape(self.session_file_path) },
    mods = { silent = true }
  })
  return success
end

---@param other Project
function Project:__lt(other)
  local self_stat = vim.uv.fs_stat(self.session_file_path)
  local other_stat = vim.uv.fs_stat(other.session_file_path)
  assert(self_stat and other_stat, "session file not exists")
  return self_stat.mtime.sec < other_stat.mtime.sec
end

return Project
