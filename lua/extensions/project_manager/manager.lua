local UI = require("extensions.project_manager.ui")
local Project = require("extensions.project_manager.project")

---@class ext.projectmanager.ManagerConfig
---@field session_options string[]
---@field session_root string
---@field project_root_patterns string[]

---@class ext.projectmanager.Manager
---@field config ext.projectmanager.ManagerConfig
---@field project_list ext.projectmanager.Project[]
---@field ui ext.projectmanager.UI
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

  local m = setmetatable({ config = config }, self)

  m:load_project_list()

  m.ui = UI:new({
    on_select = function(project_root)
      local project = m:find(project_root)
      if project == nil then
        vim.notify("invalid path: " .. project_root, vim.log.levels.WARN)
        return
      end
      if vim.fs.normalize(vim.fn.getcwd()) == project.root_path then
        vim.notify("already in this project: " .. project_root, vim.log.levels.INFO)
        return
      end
      if m:save_current_project() then
        m:load(project)
      end
    end,
    on_save = function(root_paths) m:update_projects(root_paths) end,
    get_contents = function()
      return vim.iter(m.project_list):map(function(v)
        ---@cast v ext.projectmanager.Project
        return v.root_path
      end):totable()
    end
  })

  -- 退出 vim 时保存当前项目
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("project_manager", { clear = true }),
    desc = "save current project when vim leave",
    callback = function()
      assert(m:save_current_project(), "save current project error")
    end
  })

  return m
end

function Manager:toggle() self.ui:toggle() end

---@param root_path string
---@return ext.projectmanager.Project|nil
function Manager:find(root_path)
  return vim.iter(self.project_list):find(function(v)
    ---@type ext.projectmanager.Project
    local project = v
    return project.root_path == root_path
  end)
end

---@return boolean
function Manager:save_current_project()
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  ---@type ext.projectmanager.Project
  local current_project = vim.iter(self.project_list):find(function(p)
    ---@cast p ext.projectmanager.Project
    return p.root_path == cwd
  end)

  if current_project ~= nil then
    local unsaved_files = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_get_option_value("buflisted", { buf = buf })
          and vim.api.nvim_get_option_value("modified", { buf = buf }) then
        table.insert(unsaved_files, vim.api.nvim_buf_get_name(buf))
      end
    end
    if #unsaved_files > 0 then
      table.insert(unsaved_files, "these files not saved yet")
      local choice = vim.fn.confirm(table.concat(unsaved_files, "\n"), "&Cancel\n&Save all\n&Discard all")
      if choice == 2 then
        vim.cmd.wa { mods = { silent = true } }
      elseif choice == 3 then
        vim.notify(string.format("Discard project %s all files", current_project.root_path), vim.log.levels.WARN)
      else
        return false
      end
    end

    local ok, err = current_project:save(self.config.session_options)
    if not ok then
      error(string.format("save project: '%s' error: %s", current_project.root_path, err))
    end
  end
  return true
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

  local ok, err = project:load()
  assert(ok, string.format("load project '%s' error: %s", project.root_path, err))
  vim.api.nvim_set_current_dir(project.root_path)
end

function Manager:load_last_project()
  assert(#self.project_list > 0, "no project")
  self:load(self.project_list[1])
end

---@param root_paths string[]
function Manager:update_projects(root_paths)
  ---@type table<string, ext.projectmanager.Project>
  local project_map = vim.iter(self.project_list):fold({}, function(acc, p)
    ---@cast p ext.projectmanager.Project
    acc[p.root_path] = p
    return acc
  end)

  ---@type table<string, boolean>
  local paths = {}
  for _, path in ipairs(root_paths) do
    local stat, err = vim.uv.fs_stat(path)
    assert(stat, string.format("check project root '%s' error: %s", root_paths, err))
    assert(stat.type == "directory", string.format("path '%s' must be a directory", root_paths))
    paths[path] = true
  end
  paths = vim.iter(paths):map(function(k) return k end):totable()

  for _, path in ipairs(paths) do
    if project_map[path] == nil then
      self:add_project(self:find_parent_path(path))
    else
      project_map[path] = nil
    end
  end

  for _, p in pairs(project_map) do
    local ok, err = p:delete()
    assert(ok, string.format("delete project error: %s", err))
  end
  self:load_project_list()
end

function Manager:add_project(path)
  local newProject = Project:new(self.config.session_root, path)
  assert(newProject:init(), string.format("init project '%s' error", newProject.root_path))
  table.insert(self.project_list, newProject)
end

---@param path string
---@return string
function Manager:find_parent_path(path)
  local results = vim.fs.find(self.config.project_root_patterns, {
    path = path,
    upward = true
  })
  path = (results and #results == 1) and results[1] or path
  return vim.fn.fnamemodify(path, ":h")
end

function Manager:add_current_project() self:add_project(vim.fs.normalize(vim.fn.getcwd())) end

function Manager:load_project_list()
  local session_root = self.config.session_root
  local fs, scandir_err = vim.uv.fs_scandir(session_root)
  assert(fs,
    string.format("scan session root %s error: %s", session_root, scandir_err))

  ---@type ext.projectmanager.Project[]
  local project_list = {}

  for file, type in vim.uv.fs_scandir_next, fs do
    if type == "file" and vim.fn.fnamemodify(file, ":e") == "vim" then
      local project = Project:from_session(session_root, file)
      table.insert(project_list, project)
    end
  end

  table.sort(project_list, function(a, b) return a.mod_time > b.mod_time end)
  self.project_list = project_list
end

return Manager
