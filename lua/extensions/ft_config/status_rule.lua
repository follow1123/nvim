local M = {}


---@class ext.ft_config.StatusRules
---@field working_dir_rule ext.ft_config.WorkingDirRule[]
---@field file_rule ext.ft_config.FileRule[]

---@class ext.ft_config.WorkingDirRule
---@field working_dir string
---@field exclude_filetype string[]
---@field enabled boolean
local WorkingDirRule = {}

---@private
WorkingDirRule.__index = WorkingDirRule


---@class ext.ft_config.FileRule
---@field file_path string
---@field enabled boolean
local FileRule = {}

---@private
FileRule.__index = FileRule

---@param data any
M.as_working_dir_rule = function(data)
  if data.working_dir == nil then
    return nil
  end
  if data.enabled == nil then
    return nil
  end
end

return M
