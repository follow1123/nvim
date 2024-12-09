local util = require("extensions.util")

---@class ManagementView
---@field win_id integer|nil
---@field buf integer|nil
---@field max_len integer
---@field on_buf_created function
---@field on_list_projects fun(callback: fun(i: integer, project: Project))
local ManagementView = {}

ManagementView.filetype =  "projectmgr"

function ManagementView:get_window_config()
  local height = vim.api.nvim_get_option_value("lines", {})
  local width = vim.api.nvim_get_option_value("columns", {})
  local win_width = math.floor(width / 2)
  local win_height = math.floor(height / 3)
  -- 这里减去的5是包括两边边框和左边的行号的宽度
  self.max_len = win_width - 5
  return {
    title = "Recent Projects",
    relative = "editor", style = "minimal", border = "single",
    width = win_width, height = win_height,
    row = height / 3, col = width / 4,
  }
end

function ManagementView:set_window_options()
  vim.api.nvim_set_option_value("number", true, { win = self.win_id })
  vim.api.nvim_set_option_value("cursorline", true, { win = self.win_id })
  vim.api.nvim_set_option_value("wrap", true, { win = self.win_id })
end

function ManagementView:create_buffer()
  local buf = vim.api.nvim_create_buf(false, true)
  assert(buf ~= nil, "create buffer failed!")
  self.buf = buf
  vim.api.nvim_set_option_value("filetype", self.filetype, { buf = self.buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = self.buf })
  vim.api.nvim_set_option_value("buftype", "acwrite", { buf = self.buf })
  vim.api.nvim_buf_set_name(self.buf, "recent-projects")
  self.on_buf_created()
end

function ManagementView:create_window()
  assert(self.buf, "recent project window is not open")
  local win_id = vim.api.nvim_open_win(self.buf, true, self:get_window_config())
  assert(win_id ~= 0, "create window failed!")
  self.win_id = win_id
  self:set_window_options()
end

function ManagementView:set_buf_contents()
  local cur_project_idx
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  local path_views = {}
  self.on_list_projects(function(i, project)
    ---@cast project Project
    if cwd == project.dir then cur_project_idx = i end
    table.insert(path_views, project.dir)
  end)
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, path_views)
  if cur_project_idx ~= nil then
    vim.api.nvim_win_set_cursor(self.win_id, { cur_project_idx, 0 })
  end
  -- 高亮项目名称
  vim.fn.matchadd("Number", "[^/]\\+$")
end

function ManagementView:resize()
  if not self:visible() then return end
  vim.api.nvim_win_set_config(self.win_id, self:get_window_config())
  self:set_buf_contents()
  self:set_window_options()
end

---@return table<string>
function ManagementView:get_all_path()
  assert(self.buf, "recent project window is not open")
  return vim.api.nvim_buf_get_lines(self.buf, 0, -1, false)
end

function ManagementView:open()
  self:create_buffer()
  self:create_window()
  self:set_buf_contents()
end

function ManagementView:visible() return util.check_win(self.win_id) end

function ManagementView:is_focused()
  return vim.api.nvim_get_current_win() == self.win_id
end

function ManagementView:focus()
  if not util.check_win(self.win_id) then return end
  vim.fn.win_gotoid(self.win_id)
end

function ManagementView:close()
  if util.check_buf(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end
  self.win_id = nil
  self.buf = nil
end

function ManagementView:toggle()
  if not self:visible() then self:open() return end
  if self:is_focused() then self:close() else self:focus() end
end

return ManagementView
