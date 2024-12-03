local Project = require("extensions.project-manager.project")
local View = require("extensions.project-manager.view")
local util = require("extensions.util")
local nmap = require("utils.keymap").nmap
local project_manager_group = vim.api.nvim_create_augroup("PROJECT_MANAGER", { clear = true })


---@class ProjectManager
---@field current_project Project|nil
---@field view ManagementView
local ProjectManager = {}

function ProjectManager:init()
  -- 创建 session 文件根目录
  Project.init_session_root()

  -- 退出 vim 时保存当前项目
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = project_manager_group,
    desc = "save current project when vim leave",
    callback = function() self:save_current_project() end
  })

  -- view 的 buffer 创建时设置相关配置
  View.on_buf_created = function() self:set_view_config() end

  -- 获取项目的显示路径
  View.on_list_projects = function(callback)
    local projects = self:get_projects()
    for i, project in ipairs(projects) do
      callback(i, project)
    end
  end

  self.view = View
end

function ProjectManager:set_view_config()
  assert(self.view.buf, "recent project window is not open")
  nmap("<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local project = self:find_project(line)
    if project == nil then
      vim.notify("no project found", vim.log.levels.WARN)
      return
    end
    if vim.fs.normalize(vim.fn.getcwd()) == project.dir then
      local choice = vim.fn.confirm("already in this project", "&Cancel\n&Reload")
      if choice == 1 then return end
    end
    self:save_current_project()
    self:load_project(project)
  end, "projects: Close recent project window", self.view.buf)
  nmap("q", function() self.view:close() end, "projects: Close recent project window", self.view.buf)
  nmap("<M-q>", function() self.view:close() end, "projects: Close recent project window", self.view.buf)
  nmap("<ESC>", function() self.view:close() end, "projects: Close recent project window", self.view.buf)
  nmap("K", function()
    local line = vim.api.nvim_get_current_line()
    local project = self:find_project(line)
    if project == nil then
      vim.notify("invalid project", vim.log.levels.WARN)
      return
    end
    vim.notify(project.dir, vim.log.levels.INFO)
  end, "projects: Show project full path", self.view.buf)
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = self.view.buf,
    group = project_manager_group,
    desc = "update project when buffer write",
    callback = function() self:update_projects() end
  })
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = self.view.buf,
    group = project_manager_group,
    desc = "resize recene projects window when vim resized",
    callback = function() self.view:resize() end
  })
end

---@return table<Project> insert_projects # add projects
---@return table<Project> delete_projects # delete projects
function ProjectManager:check_projects()
  local project_path_list = self.view:get_all_path()
  local project_map = {}
  local projects = self:get_projects()
  for _, project in ipairs(projects) do
    project_map[project.dir] = project
  end

  local insert_projects = {}
  for _, path in ipairs(project_path_list) do
    if path == nil or #vim.trim(path) == 0 then goto continue end
    path = vim.fs.normalize(path)
    local project = project_map[path]
    if project == nil then
      assert(util.exists(path), string.format("invalid path: %s", path))
      path = Project.find_root(path)
      table.insert(insert_projects, Project:new(path))
    else
      project_map[path] = nil
    end
    ::continue::
  end
  local delete_projects = vim.tbl_values(project_map)
  return insert_projects, delete_projects
end

function ProjectManager:update_projects()
  local insert_projects, delete_projects = self:check_projects()
  local err_msg = {}
  for _, project in ipairs(insert_projects) do
    ---@cast project Project
    if not project:save() then
      table.insert(err_msg, string.format("add project：%s failed!", project.dir))
    end
  end
  for _, project in ipairs(delete_projects) do
    ---@cast project Project
    if not project:delete() then
      table.insert(err_msg, string.format("delete project：%s failed!", project.dir))
    end
  end
  if not vim.tbl_isempty(err_msg) then
    vim.notify(table.concat(err_msg, "\n"), vim.log.levels.ERROR)
    return
  end

  self.view:close()
end

function ProjectManager:stop_lsp()
  local ok = pcall(vim.lsp.stop_client, vim.lsp.get_active_clients())
  if not ok then return end

  -- 等待所有 lsp 停止完成
  local mill = 0
  while mill < 300 do
    local clients = vim.lsp.get_active_clients()
    if not clients or #clients == 0 then break end
    vim.wait(1)
    mill = mill + 1
  end
end

---@return boolean
function ProjectManager:check_unsaved_files()
  local bufs = vim.api.nvim_list_bufs()
  local unsaved_files = {}
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_get_option(buf, "modified") then
      local file_full_path = vim.api.nvim_buf_get_name(buf)
      if util.is_file(file_full_path) then
        table.insert(unsaved_files, file_full_path)
      end
    end
  end
  if not vim.tbl_isempty(unsaved_files) then
    table.insert(unsaved_files, "these files not saved yet")
    local choice = vim.fn.confirm(table.concat(unsaved_files, "\n"), "&Cancel\n&Save all\n&Discard all")
    if choice == 1 then return false end
    if choice == 2 then vim.cmd.wa { mods = { silent = true } } end
  end
  return true
end

function ProjectManager:clean_vim()
  -- 清除 buffer 内的跳转记录
  vim.cmd.clearjumps()
  -- 强制清除所有 buffer
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

---@param project Project
function ProjectManager:load_project(project)
  self.view:close()
  self:stop_lsp()
  if not self:check_unsaved_files() then return end
  self:clean_vim()
  if project:load() then
    vim.api.nvim_set_current_dir(project.dir)
  end
end

--- 加载上次的项目
function ProjectManager:load_last_project()
  self:load_project(self:get_last_project())
end

---@param project Project
function ProjectManager:save_project(project)
  if project == nil then return end
  if project:save() then
    vim.notify(string.format("project %s saved", project.dir))
  end
end

function ProjectManager:get_current_project()
  self:get_projects()
  return self.current_project
end

function ProjectManager:save_current_project()
  local current_project = self:get_current_project()
  if current_project == nil then return end
  self:save_project(current_project)
end

---@return Project
function ProjectManager:get_last_project()
  local last_project = self:get_projects()[1]
  assert(last_project, "no saved projects")
  return last_project
end

function ProjectManager:add_current_project()
  local current_project = self:get_current_project()
  if current_project ~= nil then
    vim.notify("current project already saved yet, use `<space>ps` to save current project session", vim.log.levels.INFO)
    return
  end
  local cwd = vim.fn.getcwd()
  local project = Project:new(cwd)
  self:add_project(project)
end

---@param project Project
function ProjectManager:add_project(project)
  if project == nil then return end
  if project:save() then
    vim.notify(string.format("add project %s", project.dir))
  end
end

---@param project_dir string
---@return Project|nil
function ProjectManager:find_project(project_dir)
  if project_dir == nil or #vim.trim(project_dir) == 0 then return nil end
  local projects = self:get_projects()
  for _, project in ipairs(projects) do
    ---@cast project Project
    if project_dir == project.dir then return project end
  end
  return nil
end

---@return table<Project>
function ProjectManager:get_projects()
  local fs, err_name, err_msg = vim.uv.fs_scandir(Project.session_root)
  assert(fs, string.format("can not open dir: %s. %s, %s", Project.session_root, err_name, err_msg))
  local projects = {}
  for file, t in vim.uv.fs_scandir_next, fs do
    if t == "file" and vim.fn.fnamemodify(file, ":e") == "vim" then
      local project = Project:from_session(file)
      if project.dir == vim.fs.normalize(vim.fn.getcwd()) then
        self.current_project = project
      end
      table.insert(projects, project)
    end
  end
  table.sort(projects, function(a, b) return a > b end)
  return projects
end

function ProjectManager:toggle()
  self.view:toggle()
end

return ProjectManager
