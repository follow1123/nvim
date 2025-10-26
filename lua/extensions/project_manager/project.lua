local uv = vim.uv

---@class ext.projectmanager.Project
---@field path string
---@field private session? string
---@field mod_time integer
local Project = {}

---@private
Project.__index = Project

---@param path string
---@return ext.projectmanager.Project
function Project:new(path)
  path = vim.fs.normalize(path)
  local stat = assert(uv.fs_stat(path))
  assert(stat.type == "directory", string.format("project path '%s' is not directory", path))
  return setmetatable({ path = path, mod_time = 0 }, self)
end

---@param obj any
---@return ext.projectmanager.Project
function Project:from_json_obj(obj)
  local path = assert(obj.path, "path cannot be empty")
  local session = assert(obj.session, "session cannot be empty")

  local project = Project:new(path)
  local session_stat = assert(uv.fs_stat(session))
  project.session = session
  project.mod_time = session_stat.mtime.sec
  return project
end

---@return any
function Project:to_json_obj()
  return {
    path = self.path,
    session = self.session
  }
end

---@param session_root string
function Project:init(session_root)
  -- session 文件存在直接退出
  if self.session then return end

  -- 生成 session 名称
  local project_name = vim.fs.basename(self.path)
  local session_name = string.format("%s_%d.vim", project_name, math.random(10000, 99999))
  local session_path = vim.fs.joinpath(session_root, session_name)

  -- 创建空 session 文件
  local fd = assert(uv.fs_open(session_path, "wx", tonumber("660", 8)))
  local session_stat = assert(uv.fs_fstat(fd))
  assert(uv.fs_close(fd))
  self.mod_time = session_stat.mtime.sec
  self.session = session_path
end

---@param session_root string
---@param session_options string[]
function Project:save(session_root, session_options)
  if not self.session then
    self:init(session_root)
  end
  local default_options = vim.opt.sessionoptions
  vim.opt.sessionoptions = session_options
  local success, err = pcall(vim.cmd.mksession, {
    args = { vim.fn.fnameescape(self.session) },
    bang = true
  })
  vim.opt.sessionoptions = default_options
  assert(success, string.format("save project '%s' error: %s", self.path, tostring(err)))
end

function Project:delete()
  assert(uv.fs_unlink(self.session))
end

function Project:load()
  if not self.session then return end

  local success, err = pcall(vim.cmd.source, {
    args = { vim.fn.fnameescape(self.session) },
    mods = { silent = true }
  })
  assert(success, string.format("load project '%s' error: %s", self.path, tostring(err)))
end

return Project
