---@class ext.ft_config.FiletypeManager
---@field config_path string
---@field status_rules ext.ft_config.StatusRules
local FiletypeManager = {}

---@private
FiletypeManager.__index = FiletypeManager

---@param config_path string
---@return ext.ft_config.FiletypeManager
function FiletypeManager:new(config_path)
  return setmetatable({
    config_path = config_path,
    status_rules = FiletypeManager.load_config(config_path)
  }, self)
end

---@param working_dir string
---@param filetype? string
function FiletypeManager:enable_working_dir(working_dir, filetype)
  local exists = false
  for _, wdr in ipairs(self.status_rules.working_dir_rule) do
    if wdr.working_dir == working_dir then
      if filetype then
        local excluded = vim.list_contains(wdr.exclude_filetype, filetype)
        if wdr.enabled then
          -- 如果已启用，排除列表内存在，则移除
          if excluded then
            wdr.exclude_filetype = vim.iter(wdr.exclude_filetype):filter(function(ft) return ft ~= filetype end):totable()
          end
        else
          -- 如果未启用，排除列表内不存在，则添加
          if not excluded then
            table.insert(wdr.exclude_filetype, filetype)
          end
        end
      else
        -- 清空排除的文件类型
        wdr.exclude_filetype = {}
        wdr.enabled = true
      end
      exists = true
      break
    end
  end

  -- working dir 不存在
  if not exists then
    ---@type ext.ft_config.WorkingDirRule
    local working_dir_rule = {
      working_dir = working_dir,
      enabled = true,
      exclude_filetype = {}
    }
    -- 设置只允许当前 working dir 的这个 filetype
    if filetype then
      working_dir_rule.enabled = false
      table.insert(working_dir_rule.exclude_filetype, filetype)
    end

    table.insert(self.status_rules.working_dir_rule, working_dir_rule)
  end

  self.save_status_rules(self.config_path, self.status_rules)
end

---@param file_path string
function FiletypeManager:enable_file_path(file_path)
  local exists = false
  for _, fr in ipairs(self.status_rules.file_rule) do
    if fr.file_path == file_path then
      fr.enabled = true
      exists = true
      break
    end
  end

  if not exists then
    ---@type ext.ft_config.FileRule
    local file_rule = {
      file_path = file_path,
      enabled = true,
    }
    table.insert(self.status_rules.file_rule, file_rule)
  end

  self.save_status_rules(self.config_path, self.status_rules)
end

---@param working_dir string
---@param filetype? string
function FiletypeManager:disable_working_dir(working_dir, filetype)
  local exists = false
  local removeIdx = 0
  for i, wdr in ipairs(self.status_rules.working_dir_rule) do
    if wdr.working_dir == working_dir then
      if filetype then
        local excluded = vim.list_contains(wdr.exclude_filetype, filetype)
        if wdr.enabled then
          if not excluded then
            table.insert(wdr.exclude_filetype, filetype)
          end
        else
          if excluded then
            wdr.exclude_filetype = vim.iter(wdr.exclude_filetype):filter(function(ft) return ft ~= filetype end):totable()
            if #wdr.exclude_filetype == 0 then
              removeIdx = i
            end
          end
        end
      else
        removeIdx = i
      end
      exists = true
      break
    end
  end

  if removeIdx > 0 then
    table.remove(self.status_rules.working_dir_rule, removeIdx)
  end

  if exists then
    self.save_status_rules(self.config_path, self.status_rules)
  end
end

---@param file_path string
function FiletypeManager:disable_file_path(file_path)
  local exists = false
  for _, fr in ipairs(self.status_rules.file_rule) do
    if fr.file_path == file_path then
      fr.enabled = false
      exists = true
      break
    end
  end

  if not exists then
    ---@type ext.ft_config.FileRule
    local file_rule = {
      file_path = file_path,
      enabled = false,
    }
    table.insert(self.status_rules.file_rule, file_rule)
  end
  self.save_status_rules(self.config_path, self.status_rules)
end

---@param working_dir string
function FiletypeManager:reset_working_dir(working_dir)
  local idx = 0
  for i, wdr in ipairs(self.status_rules.working_dir_rule) do
    if wdr.working_dir == working_dir then
      idx = i
      break
    end
  end
  if idx > 0 then
    table.remove(self.status_rules.working_dir_rule, idx)
    self.save_status_rules(self.config_path, self.status_rules)
  end
end

---@param file_path string
function FiletypeManager:reset_file_path(file_path)
  local idx = 0
  for i, fr in ipairs(self.status_rules.file_rule) do
    if fr.file_path == file_path then
      idx = i
      break
    end
  end
  if idx > 0 then
    table.remove(self.status_rules.file_rule, idx)
    self.save_status_rules(self.config_path, self.status_rules)
  end
end

function FiletypeManager:clean()
  self.status_rules.working_dir_rule = vim.iter(self.status_rules.working_dir_rule):filter(function(wdr)
    local stat = vim.uv.fs_stat(wdr.working_dir)
    return stat ~= nil and stat.type == "directory"
  end):totable()

  self.status_rules.file_rule = vim.iter(self.status_rules.file_rule):filter(function(fr)
    local stat = vim.uv.fs_stat(fr.file_path)
    return stat ~= nil
  end):totable()

  self.save_status_rules(self.config_path, self.status_rules)
end

---comment
---@param config_path string
---@param status_rules ext.ft_config.StatusRules
function FiletypeManager.save_status_rules(config_path, status_rules)
  local content = vim.json.encode(status_rules)
  vim.fn.writefile({ content }, config_path)
end

---@param config_path string
---@return ext.ft_config.StatusRules
function FiletypeManager.load_config(config_path)
  local stat = vim.uv.fs_stat(config_path)
  if not stat then
    return {
      working_dir_rule = {},
      file_rule = {},
    }
  end
  local content = vim.fn.readfile(config_path)
  content = table.concat(content, "")
  return vim.json.decode(content)
end

---@param working_dir string
---@param filetype? string
function FiletypeManager:is_working_dir_enabled(working_dir, filetype)
  for _, wdr in ipairs(self.status_rules.working_dir_rule) do
    if wdr.working_dir == working_dir then
      if filetype then
        for _, eft in ipairs(wdr.exclude_filetype) do
          if filetype == eft then
            return not wdr.enabled
          end
        end
      end
      return wdr.enabled
    end
  end
  return false
end

---@param file_path string
function FiletypeManager:is_file_path_enabled(file_path)
  for _, fr in ipairs(self.status_rules.file_rule) do
    if file_path == fr.file_path and fr.enabled then
      return true
    end
  end
  return false
end

return FiletypeManager
