local extensions = {}

local finders = require("telescope.finders")
local actions = require("telescope.actions")
local state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local entry_display = require("telescope.pickers.entry_display")

local history = require("project_nvim.utils.history")
local project = require("project_nvim.project")
local config = require("project_nvim.config")

local persistence = require("persistence")
local Config = require("persistence.config")

local e = vim.fn.fnameescape

-- ###########################
-- #        扩展工具方法     #
-- ###########################

-- 将session格式的路径
local function format_path(path)
  local session_dir = Config.options.dir
  path = path:sub(session_dir:len() + 1, path:len())
  path = path:gsub("%%", ":", 1)
  path = path:gsub("%%", "/")
  return path:sub(1, path:len() - 4)
end

-- 根据项目路径查找对应的session路径
local function find_session(project_path)
  print("project_path: " .. project_path)
  local session_list = persistence.list()
  for _, value in pairs(session_list) do
    local f_path =  format_path(value)
    print("session_path: " .. f_path)
    if string.match(project_path, f_path) then
      return value
    end
  end
end

-- ###########################
-- #        原版方法         #
-- ###########################
local function create_finder()
  local results = history.get_recent_projects()

  -- Reverse results
  for i = 1, math.floor(#results / 2) do
    results[i], results[#results - i + 1] = results[#results - i + 1], results[i]
  end
  local displayer = entry_display.create({
    separator = " ",
    items = {
      {
        width = 30,
      },
      {
        remaining = true,
      },
    },
  })

  local function make_display(entry)
    return displayer({ entry.name, { entry.value, "Comment" } })
  end

  return finders.new_table({
    results = results,
    entry_maker = function(entry)
      local name = vim.fn.fnamemodify(entry, ":t")
      return {
        display = make_display,
        name = name,
        value = entry,
        ordinal = name .. " " .. entry,
      }
    end,
  })
end

local function change_working_directory(prompt_bufnr, prompt)
  local selected_entry = state.get_selected_entry(prompt_bufnr)
  if selected_entry == nil then
    actions.close(prompt_bufnr)
    return
  end
  local project_path = selected_entry.value
  if prompt == true then
    actions._close(prompt_bufnr, true)
  else
    actions.close(prompt_bufnr)
  end
  local cd_successful = project.set_pwd(project_path, "telescope")
  return project_path, cd_successful
end

local function find_project_files(prompt_bufnr)
  local project_path, cd_successful = change_working_directory(prompt_bufnr, true)
  local opt = {
    cwd = project_path,
    hidden = config.options.show_hidden,
    mode = "insert",
  }
  if cd_successful then
    builtin.find_files(opt)
  end
end

-- ###########################
-- #        扩展功能         #
-- ###########################

-- 删除项目并删除对应的session
local function delete_session(selectedEntry)
  local path = selectedEntry.value
  local session_path = find_session(path)
  if session_path then
    vim.fn.delete(vim.fs.normalize(session_path))
  end
end

-- 删除project原版方法，，并删除对应的session
local function delete_project(prompt_bufnr)
  local selectedEntry = state.get_selected_entry(prompt_bufnr)
  if selectedEntry == nil then
    actions.close(prompt_bufnr)
    return
  end
  local choice = vim.fn.confirm("Delete '" .. selectedEntry.value .. "' from project list?", "&Yes\n&No", 2)

  if choice == 1 then
    history.delete_project(selectedEntry)

    delete_session(selectedEntry)
    local finder = create_finder()
    state.get_current_picker(prompt_bufnr):refresh(finder, {
      reset_prompt = true,
    })
  end
end

-- 加载project和对应的session
local function load_project(opts)
  local last = opts.last
  local path = last and format_path(persistence.get_last()) or opts.path
  local prompt_bufnr = opts.prompt_bufnr
  local session_path = find_session(path)
  if session_path and vim.fn.filereadable(session_path) ~= 0 then
    print("matched session path: " .. session_path)
    vim.cmd("silent! source " .. e(session_path))
  elseif prompt_bufnr then
    find_project_files(prompt_bufnr)
  end
end

-- 打开选中的项目，如果有session则直接打开
local function open_selected_project(prompt_bufnr)
  -- 获取选项的值
  local selected_entry = state.get_selected_entry(prompt_bufnr)
  if selected_entry == nil then
    actions.close(prompt_bufnr)
    return
  end
  local project_path = selected_entry.value
  actions.close(prompt_bufnr)
  -- 查找对应的session并打开
  load_project({
    path = project_path,
    last = false,
    prompt_bufnr = prompt_bufnr,
  })
  project.set_pwd(project_path, "manual") -- 切换当前工作目录
end

-- ###########################
-- #   对外暴露的扩展方法    #
-- ###########################

-- 加载最后一个项目
extensions.load_last_project = function()
  load_project({
    last = true
  })
end

-- 由于project.nvim插件实现的telescope扩展不规范，需要使用这种方式修改自定义按键
extensions.select_projects = function()
  require('telescope').extensions.projects.projects{
    attach_mappings = function(prompt_bufnr, map) -- telescope配置按键映射方法
      map("i", "<M-d>", delete_project)
      -- telescope选择后执行的回调方法
      local function on_selected_project()
        open_selected_project(prompt_bufnr)
      end
      actions.select_default:replace(on_selected_project)
      return true
    end,
  }
end

-- 定位当前文件的root路径
extensions.locate_project_root = function()
  project.on_buf_enter()
end

extensions.add_cur_project = function()
  project.on_buf_enter()
end

return extensions
