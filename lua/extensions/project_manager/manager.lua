local Project = require("extensions.project_manager.project")

---@class ext.projectmanager.Pattern
---@field name string
---@field dir boolean|nil

---@class ext.projectmanager.ManagerConfig
---@field session_options string[]
---@field session_root string
---@field project_root_patterns ext.projectmanager.Pattern[]

---@class ext.projectmanager.Manager
---@field config ext.projectmanager.ManagerConfig
---@field projects ext.projectmanager.Project[]
---@field data_path string
local Manager = {}

---@private
Manager.__index = Manager

---@param config ext.projectmanager.ManagerConfig
---@return ext.projectmanager.Manager
function Manager:new(config)
  assert(config, "config not be nil")
  assert(config.session_options, "session_options not be nil")
  assert(config.session_root, "session_root not be nil")
  assert(config.project_root_patterns, "project_root_patterns not be nil")
  config.session_root = vim.fs.normalize(config.session_root)

  -- 初始化 session root 路径
  local stat, stat_err = vim.uv.fs_stat(config.session_root)
  if stat ~= nil then
    assert(stat.type == "directory",
      string.format("invalid session root %s, error: %s", config.session_root, stat_err))
  else
    local result, mkdir_err = vim.uv.fs_mkdir(config.session_root, tonumber("755", 8))
    assert(result,
      string.format("init session root %s error: %s", config.session_root, mkdir_err))
  end

  local data_path = vim.fs.joinpath(config.session_root, "sessions.json")

  return setmetatable({
    data_path = data_path,
    config = config,
    projects = Manager.load_projects(data_path)
  }, self)
end

---@param path string
---@return ext.projectmanager.Project|nil
function Manager:find(path)
  return vim.iter(self.projects):find(function(v)
    ---@type ext.projectmanager.Project
    local project = v
    return project.path == path
  end)
end

function Manager:save_current_project()
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  ---@type ext.projectmanager.Project
  local current_project = vim.iter(self.projects):find(function(p)
    ---@cast p ext.projectmanager.Project
    return p.path == cwd
  end)
  if current_project == nil then return end

  local unsaved_files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("buflisted", { buf = buf })
        and vim.api.nvim_get_option_value("modified", { buf = buf }) then
      table.insert(unsaved_files, vim.api.nvim_buf_get_name(buf))
    end
  end
  if #unsaved_files > 0 then
    table.insert(unsaved_files, "these files not saved yet")
    local choice = vim.fn.confirm(table.concat(unsaved_files, "\n"), "&Save all\n&Discard all")
    if choice == 1 then
      vim.cmd.wa { mods = { silent = true } }
    elseif choice == 2 then
      vim.notify(string.format("Discard project %s all files", current_project.path), vim.log.levels.WARN)
    end
  end

  current_project:save(self.config.session_root, self.config.session_options)
  Manager.save_projects(self.data_path, self.projects)
end

---@param project ext.projectmanager.Project
function Manager:load(project)
  -- 清除 buffer 内的跳转记录
  vim.cmd.clearjumps()
  -- 强制清除所有 buffer
  local wins = vim.api.nvim_list_wins()
  for _, win_id in ipairs(wins) do
    pcall(vim.api.nvim_win_close, win_id, true)
  end
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  local stop_clients_ok = pcall(vim.lsp.stop_client, vim.lsp.get_clients())
  if stop_clients_ok then
    -- 等待所有 lsp 停止完成
    local mill = 0
    while mill < 300 do
      local clients = vim.lsp.get_clients()
      if not clients or #clients == 0 then break end
      vim.wait(1)
      mill = mill + 1
    end
  end

  project:load()
  vim.api.nvim_set_current_dir(project.path)
end

function Manager:load_last_project()
  if #self.projects == 0 then
    vim.notify("no project sessions", vim.log.levels.WARN)
    return
  end
  self:load(self.projects[1])
end

---@param root_paths string[]
function Manager:update_projects(root_paths)
  -- 去除空行
  root_paths = vim.iter(root_paths):filter(function(p)
    return #vim.trim(p) > 0
  end):totable()

  ---@type table<string, ext.projectmanager.Project>
  local project_map = vim.iter(self.projects):fold({}, function(acc, p)
    ---@cast p ext.projectmanager.Project
    acc[p.path] = p
    return acc
  end)

  ---@type table<string, ext.projectmanager.Project>
  local new_project_map = {}

  for _, path in ipairs(root_paths) do
    path = vim.fs.normalize(path)
    -- 没有已保存的就直接初始化
    if not project_map[path] then
      -- 没有添加过才添加
      if not new_project_map[path] then
        -- 判断路径是否合法
        local project = Project:new(path)
        project:init(self.config.session_root)
        new_project_map[path] = project
      end
    else
      new_project_map[path] = project_map[path]
      -- 有就删除
      project_map[path] = nil
    end
  end

  -- 删除多出的项目
  for _, p in pairs(project_map) do p:delete() end

  local projects = vim.iter(new_project_map):map(function(_, v) return v end):totable()

  -- 排序，保存
  Manager.sort_projects(projects)
  Manager.save_projects(self.data_path, projects)
  self.projects = projects
end

function Manager:add_project(path)
  path = vim.fs.normalize(path)
  for _, project in ipairs(self.projects) do
    if project.path == path then
      error(string.format("project %s already added", path))
    end
  end
  local newProject = Project:new(path)
  newProject:init(self.config.session_root)
  table.insert(self.projects, 1, newProject)
  Manager.save_projects(self.data_path, self.projects)
end

---@param dir string
---@param patterns ext.projectmanager.Pattern[]
---@return boolean
function Manager.dir_match_patterns(dir, patterns)
  local found = false
  for _, p in ipairs(patterns) do
    if found then break end

    local path = vim.fs.joinpath(dir, p.name)
    local stat = vim.uv.fs_stat(path)
    if p.dir then
      found = stat ~= nil and stat.type == "directory"
    else
      found = stat ~= nil
    end
  end
  return found
end

---@param path string
---@return string|nil
function Manager:find_project_root(path)
  local stat = assert(vim.uv.fs_stat(path))
  -- 当前是文件夹的情况下，先判断当前目录
  if stat.type == "directory" then
    if Manager.dir_match_patterns(path, self.config.project_root_patterns) then
      return path
    end
  end

  for dir in vim.fs.parents(path) do
    if Manager.dir_match_patterns(dir, self.config.project_root_patterns) then
      return dir
    end
  end
  return nil
end

function Manager:add_current_project()
  local root_dir = self:find_project_root(vim.api.nvim_buf_get_name(0))
  if not root_dir then
    root_dir = vim.fs.normalize(assert(vim.uv.cwd()))
  end

  vim.notify(string.format("add project '%s'", root_dir), vim.log.levels.INFO)
  self:add_project(root_dir)
end

---@param data_path string
---@return any
function Manager.load_json_data(data_path)
  local fd = assert(vim.uv.fs_open(data_path, "r", tonumber("660", 8)))
  local stat = assert(vim.uv.fs_fstat(fd))
  local data = assert(vim.uv.fs_read(fd, stat.size, 0))
  assert(vim.uv.fs_close(fd))
  return vim.json.decode(data)
end

---@param data_path string
---@param data any
function Manager.save_json_data(data_path, data)
  local content = vim.json.encode(data)
  local fd = assert(vim.uv.fs_open(data_path, "w", tonumber("660", 8)))
  assert(vim.uv.fs_write(fd, content, 0))
  assert(vim.uv.fs_close(fd))
end

---@param data_path string
---@return ext.projectmanager.Project[]
function Manager.load_projects(data_path)
  ---@type ext.projectmanager.Project[]
  local projects = {}

  local success, json_data = pcall(Manager.load_json_data, data_path)
  if not success then return projects end

  assert(json_data.projects and type(json_data.projects) == "table",
    "sessions data '%s' must has array properties projects")

  for _, obj in ipairs(json_data.projects) do
    local createSuccess, result = pcall(Project.from_json_obj, Project, obj)
    if not createSuccess then
      vim.notify(tostring(result), vim.log.levels.WARN)
    else
      table.insert(projects, result)
    end
  end

  Manager.sort_projects(projects)
  return projects
end

---@param data_path string
---@param projects ext.projectmanager.Project[]
function Manager.save_projects(data_path, projects)
  local data = { projects = {} }
  for _, project in ipairs(projects) do
    table.insert(data.projects, project:to_json_obj())
  end

  Manager.save_json_data(data_path, data)
end

---@param projects ext.projectmanager.Project[]
function Manager.sort_projects(projects)
  table.sort(projects, function(a, b) return a.mod_time > b.mod_time end)
end

return Manager
