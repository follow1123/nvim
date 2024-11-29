local TaskNameFactory = require("extensions.terminal.task_manager.task_name_factory")
local TaskTerminal = require("extensions.terminal.task_manager.task_terminal")
local util = require("extensions.util")

---@type WindowDirection
local def_direction = "bottom"
--
---@type table<WindowDirection, string>
local direction_map = {
  ["left"] = "topleft vsplit",
  ["right"] = "botright vsplit",
  ["top"] = "topleft split",
  ["bottom"] = "botright split"
}

---@class TaskManager
---@field tasks table<string, TaskTerminal>
---@field cur_task_name string
---@field win_id integer
---@field direction WindowDirection
---@field prev_win_id integer
local TaskManager = {}

---@return TaskManager
function TaskManager:new()
  self.__index = self
  return setmetatable({ tasks = {}, direction = def_direction }, self)
end

---@param task TaskTerminal
function TaskManager:open(task)
  task = task or assert(self:cur_task(), "no task")
  local buf = task.buf
  if self:visible() then
    vim.api.nvim_win_set_buf(self.win_id, buf)
    vim.schedule_wrap(self.set_task_status_line)(self, task)
    return
  end

  vim.cmd(direction_map[self.direction])
  self.win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(self.win_id, buf)
  vim.schedule_wrap(self.set_task_status_line)(self, task)
end

function TaskManager:close()
  vim.api.nvim_win_close(self.win_id, true)
  self.win_id = nil
end

function TaskManager:back_to_prev_win()
  if self.prev_win_id == vim.api.nvim_get_current_win() then
    self.prev_win_id = nil
    return
  end
  if not util.check_win(self.prev_win_id) then
    self.prev_win_id = vim.fn.win_id2win(vim.fn.winnr("#"))
  end
  if util.check_win(self.prev_win_id) then
    vim.fn.win_gotoid(self.prev_win_id)
  end
  self.prev_win_id = nil
end

-- 判断浮动终端是否显示
---@return boolean
function TaskManager:visible()
  if not util.check_win(self.win_id) then return false end
  local wins = vim.api.nvim_list_wins()
  for _, win_id in ipairs(wins) do
    if win_id == self.win_id then return true end
  end
  return false
end

function TaskManager:is_focused()
  return self.win_id == vim.api.nvim_get_current_win()
end

function TaskManager:focus()
  vim.fn.win_gotoid(self.win_id)
end

function TaskManager:toggle()
  local task = self:cur_task()
  if task == nil then
    self:create_term():start()
    return
  end
  if self:visible() then
    if self:is_focused() then
      self:close()
      self:back_to_prev_win()
    else
      self:focus()
    end
    return
  end

  if task:is_running() then
    self:open(task)
    return
  end

  vim.notify("task exists but not running", vim.log.levels.WARN)
end

---@param task_name string
function TaskManager:on_task_exit(task_name)
  TaskNameFactory:recycle(task_name)
  self.tasks[task_name] = nil
  local prev_task = self:last_task()
  if prev_task then
    self:open(prev_task)
  else
    self:close()
  end
end

---@param task TaskTerminal
function TaskManager:on_task_buf_created(task)
  local buf = task.buf
  local map = require("utils.keymap").map
  local map_modes = { "n", "t" }
  map(map_modes, "<M-4>", function() self:toggle() end, "terminal: Toggle task terminal", buf)
  map(map_modes, "<C-t>n", function() self:new_term() end, "terminal: Create new task", buf)
  map(map_modes, "<C-t><C-n>", function() self:new_term() end, "terminal: Create new task", buf)
  if _G.IS_GUI then
    map(map_modes, "<M-x>n", function() self:new_term() end, "terminal: Create new task", buf)
  end
  map(map_modes, "<M-n>", function() self:goto_task(false) end, "terminal: Goto next task", buf)
  map(map_modes, "<M-p>", function() self:goto_task(true) end, "terminal: Goto previous task", buf)

end

---@param task TaskTerminal
function TaskManager:set_task_status_line(task)
  local pid = vim.fn.jobpid(task.chan_id)
  local task_name = task.name
  local task_count = vim.tbl_count(self.tasks)
  local status_table = { "%y%=", task_name, "/", task_count, " %t:", pid, "%=%-14.(%l,%c%V%) %P" }
  vim.opt_local.statusline = table.concat(status_table)
end

---@return TaskTerminal|nil
function TaskManager:last_task()
  local prev_task
  for _, task in pairs(self.tasks) do
    if prev_task == nil or task > prev_task then prev_task = task end
  end
  if prev_task ~= nil then self.cur_task_name = prev_task.name end
  return prev_task
end

function TaskManager:sort_tasks()
  local tasks = vim.tbl_values(self.tasks)
  table.sort(tasks)
  return tasks
end

---@param prev boolean previous: true, next: false
function TaskManager:goto_task(prev)
  ---@type TaskTerminal[]
  local sorted_tasks = self:sort_tasks()
  if #sorted_tasks <= 1 then return end
  local task = self:cur_task()
  if task == nil then return end

  -- 获取当前 task 在排序列表内的下标
  local task_idx
  for i, t in ipairs(sorted_tasks) do if task == t then task_idx = i end end
  if task_idx == nil then return end

  -- 获取当前 task 下标前后的下标
  task_idx = prev and task_idx - 1 or task_idx + 1
  task_idx = task_idx % #sorted_tasks
  task_idx = (task_idx == 0 and #sorted_tasks or task_idx)

  self:open_task(sorted_tasks[task_idx].name)
end

---@return TaskTerminal|nil
function TaskManager:cur_task()
  if self.cur_task_name == nil then return nil end
  return self.tasks[self.cur_task_name]
end

---@param task_name string
function TaskManager:open_task(task_name)
  assert(task_name and self.tasks[task_name], "not task: " .. tostring(task_name))
  local task = self.tasks[task_name]
  self:open(task)
  self.cur_task_name = task_name
end

---@return TaskTerminal task
function TaskManager:create_term()
  local task_name = TaskNameFactory:next_name()
  local task = TaskTerminal:new(task_name, self)
  self.tasks[task_name] = task
  self.cur_task_name = task_name
  return task
end

function TaskManager:new_term()
  local task = self:create_term()
  task:start()
end

return TaskManager
