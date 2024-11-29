---@class TaskNameFactory
---@field num integer
---@field name_pool string[]
local TaskNameFactory = { num = 1, name_pool = {} }

---@return string task_name
function TaskNameFactory:next_name()
  if #self.name_pool > 0 then
    return self:name_from_pool()
  end
  local name = "task-" .. self.num
  self.num = self.num + 1
  return name
end

function TaskNameFactory:name_from_pool()
  local name = self.name_pool[1]
  table.remove(self.name_pool, 1)
  return name
end

---@param task_name string
function TaskNameFactory:recycle(task_name)
  table.insert(self.name_pool, task_name)
  table.sort(self.name_pool)
end

return TaskNameFactory
