local km = vim.keymap.set

local FLAG_KEY = "project_manager"
local FLAG_VAL = "1"

---@class ext.projectmanager.UIOptions
---@field on_select fun(project_root: string)
---@field on_save fun(root_paths: string[])
---@field get_contents fun(): string[]

---@class ext.projectmanager.UI
---@field opts ext.projectmanager.UIOptions
local UI = {}

---@private
UI.__index = UI

---@param options ext.projectmanager.UIOptions
---@return ext.projectmanager.UI
function UI:new(options)
  assert(options, "options not be nil")
  assert(options.on_select, "on_select not be nil")
  assert(options.on_save, "on_save not be nil")
  return setmetatable({ opts = options }, self)
end

function UI:toggle()
  if self:visible() then
    if not self:is_focused() then
      self:focus()
      return
    end
    self:close()
    return
  end
  self:open()
end

function UI:open()
  local buf = self:create_buf()
  local win_id = vim.api.nvim_open_win(buf, true, self.generate_win_config())
  local ksopt = { win = win_id }

  vim.schedule_wrap(vim.api.nvim_set_option_value)("wrap", true, ksopt)
  vim.schedule_wrap(vim.api.nvim_set_option_value)("signcolumn", "no", ksopt)

  vim.api.nvim_set_option_value("number", true, ksopt)
  vim.api.nvim_set_option_value("cursorline", true, ksopt)
  vim.api.nvim_set_option_value("relativenumber", false, ksopt)
  vim.api.nvim_set_option_value("winhighlight", "Normal:Normal", ksopt)

  vim.api.nvim_buf_call(buf, function()
    local contents = self.opts.get_contents()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, contents)

    -- 如果是存在的项目，光标移动到对应的位置
    local cwd = vim.fs.normalize(vim.fn.getcwd())
    for i, path in ipairs(contents) do
      if path == cwd then
        vim.api.nvim_win_set_cursor(win_id, { i, 0 })
        break
      end
    end

    -- 高亮项目名称
    vim.fn.matchadd("Number", "[^/]\\+$")
  end)
end

function UI:close()
  assert(self:is_focused(), "not focused")
  vim.api.nvim_win_close(0, true)
end

---@return integer
function UI:create_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_var(buf, FLAG_KEY, FLAG_VAL)
  vim.api.nvim_set_option_value("filetype", "projectmanager", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
  vim.api.nvim_buf_set_name(buf, "project_manager")

  km("n", "q", function() self:close() end,
    { desc = "project manager: Close recent project window", buffer = buf })
  km("n", "<M-q>", function() self:close() end,
    { desc = "project manager: Close recent project window", buffer = buf })
  km("n", "<Esc>", function() self:close() end,
    { desc = "project manager: Close recent project window", buffer = buf })

  km("n", "<cr>", function()
    self.opts.on_select(vim.api.nvim_get_current_line())
  end, { desc = "project manager: Load selected project", buffer = buf })

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    desc = "update project when buffer write",
    callback = function(e)
      self.opts.on_save(vim.api.nvim_buf_get_lines(e.buf, 0, -1, false))
      self:close()
    end
  })

  vim.api.nvim_create_autocmd("VimResized", {
    buffer = buf,
    desc = "resize projects window when vim resized",
    callback = function()
      local wins = vim.api.nvim_list_wins()
      for _, win_id in ipairs(wins) do
        if vim.api.nvim_win_get_buf(win_id) == buf then
          vim.api.nvim_win_set_config(win_id, self.generate_win_config())
          return
        end
      end
    end
  })

  return buf
end

---@return boolean
function UI:visible()
  return vim.iter(vim.api.nvim_list_wins())
      :find(function(win_id)
        return self.check_buf(vim.api.nvim_win_get_buf(win_id))
      end) ~= nil
end

---@return boolean
function UI:is_focused()
  return self.check_buf(0)
end

function UI:focus()
  local wins = vim.api.nvim_list_wins()
  for _, win_id in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win_id)
    if self.check_buf(buf) then
      vim.api.nvim_set_current_win(win_id)
      return
    end
  end
end

---@return boolean
function UI.check_buf(buf)
  buf = buf or 0
  local ok, val = pcall(vim.api.nvim_buf_get_var, buf, FLAG_KEY)
  return ok and val == FLAG_VAL
end

---@return vim.api.keyset.win_config
function UI.generate_win_config()
  local win_height = vim.api.nvim_get_option_value("lines", {}) - vim.o.cmdheight
  local win_width = vim.api.nvim_get_option_value("columns", {})
  return {
    title = "Recent Projects",
    relative = "editor",
    style = "minimal",
    border = "single",
    width = math.floor(win_width / 2),
    height = math.floor(win_height / 3),
    row = math.floor(win_height / 3),
    col = math.floor(win_width / 4),
  }
end

return UI
