local Manager = require("extensions.project_manager.manager")
local UI = require("extensions.project_manager.ui")

local manager = Manager:new({
  session_root = vim.fs.joinpath(vim.fn.stdpath("state"), "sessions"),
  session_options = { "curdir", "buffers", "tabpages", "winsize", "folds" },
  project_root_patterns = {
    { name = ".git",          dir = true },
    { name = "src",           dir = true },
    { name = ".editorconfig" },
    { name = "cargo.toml" },
    { name = "package.json" },
    { name = "tsconfig.json" },
    { name = "makefile" },
    { name = "lua",           dir = true },
    { name = "lazy-lock.json" },
    { name = "go.mod" },
    { name = "go.sum" },
    { name = "build.zig" },
    { name = ".gitignore" },
    { name = "README.md" },
  }
})

local ui = UI:new({
  on_select = function(project_root)
    project_root = vim.trim(project_root)
    if #project_root == 0 then return end

    project_root = vim.fs.normalize(project_root)
    local project = manager:find(project_root)
    if project == nil then
      vim.notify(string.format("project '%s' not add", project_root), vim.log.levels.WARN)
      return
    end
    if vim.fs.normalize(vim.fn.getcwd()) == project.path then
      vim.notify(string.format("already in this project: %s", project_root), vim.log.levels.INFO)
      return
    end
    manager:save_current_project()
    manager:load(project)
  end,
  on_save = function(root_paths) manager:update_projects(root_paths) end,
  get_contents = function()
    return vim.iter(manager.projects):map(function(v) return v.path end):totable()
  end
})

-- 退出 vim 时保存当前项目
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("project_manager", { clear = true }),
  desc = "save current project when vim leave",
  callback = function()
    manager:save_current_project()
  end
})

return {
  toggle = function() ui:toggle() end,
  load_last_project = function()
    manager:load_last_project()
  end,
  save_current_project = function()
    manager:save_current_project()
  end,
  add_current_project = function()
    manager:add_current_project()
  end
}
