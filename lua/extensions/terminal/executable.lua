local util = require("extensions.terminal.util")

local FLAG_KEY = "executable_terminal"
local FLAG_VAL = "1"

local km = vim.keymap.set

---@class ext.terminal.ExeConfig
---@field toggle_key string
---@field exe_path string
---@field win_size? ext.terminal.WindowSize

---@class ext.terminal.Executable
---@field private config ext.terminal.ExeConfig
---@field private chan_id? integer
---@field private buf? integer
---@field private win_id? integer
local Executable = {}

---@private
Executable.__index = Executable

---@param config ext.terminal.ExeConfig
---@return ext.terminal.Executable
function Executable:new(config)
  assert(config, "config not be nil")
  assert(config.toggle_key, "toggle_key not be nil")
  assert(config.exe_path, "exe_path not be nil")
  local full_path = vim.fn.exepath(config.exe_path)
  assert(full_path, config.exe_path .. " command not exists")
  config.exe_path = full_path
  config.win_size = config.win_size or "auto"
  return setmetatable({ config = config }, self)
end

function Executable:toggle()
  if self:visible() then
    if not self:is_focused() then
      self:focus()
      return
    end
    self:close()
    return
  end
  if util.check_buf(self.buf, FLAG_KEY, FLAG_VAL) and self:is_running() then
    self:open_window()
  else
    self:start()
  end
end

---@private
function Executable:start()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_var(buf, FLAG_KEY, FLAG_VAL)
  vim.api.nvim_set_option_value("filetype", "exeterminal", { buf = buf })

  vim.api.nvim_create_autocmd("VimResized", {
    desc = "exe_terminal: resize window when vim resized",
    group = vim.api.nvim_create_augroup("resize terminal window:" .. buf, { clear = true }),
    buffer = buf,
    callback = function()
      local win_id = vim.fn.bufwinid(buf)
      vim.api.nvim_win_set_config(win_id, util.generate_win_config(self.config.win_size))
    end
  })

  km("t", self.config.toggle_key, function() self:toggle() end,
    { desc = "exe terminal: toggle executable", buffer = buf })

  self.buf = buf
  self:open_window()
  local chan_id = vim.fn.termopen({ self.config.exe_path }, {
    on_exit = function()
      if util.check_buf(self.buf, FLAG_KEY, FLAG_VAL) then
        vim.api.nvim_buf_delete(self.buf, { force = true })
        self.buf = nil
      end
      if self:visible() then
        self:close()
        self.win_id = nil
      end
      self.chan_id = nil
    end
  })
  assert(chan_id > 0, "start " .. self.config.exe_path .. " failed")
  ---@cast chan_id integer
  self.chan_id = chan_id
end

---@private
function Executable:stop()
  assert(vim.fn.jobstop(self.chan_id) == 1, "stop failed")
  self.chan_id = nil
end

---@private
function Executable:open_window()
  assert(util.check_buf(self.buf, FLAG_KEY, FLAG_VAL), "buffer invalid")
  local win_id = vim.api.nvim_open_win(self.buf, true, util.generate_win_config(self.config.win_size))

  vim.api.nvim_win_set_var(win_id, FLAG_KEY, FLAG_VAL)

  -- 这两个属性需要事件完成后执行才能正常设置
  vim.schedule_wrap(vim.api.nvim_set_option_value)("wrap", true, { win = win_id })
  vim.schedule_wrap(vim.api.nvim_set_option_value)("signcolumn", "no", { win = win_id })

  vim.api.nvim_set_option_value("number", false, { win = win_id })
  vim.api.nvim_set_option_value("relativenumber", false, { win = win_id })
  vim.api.nvim_set_option_value("winhighlight", "Normal:Normal", { win = win_id })
  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    group = vim.api.nvim_create_augroup("exe_terminal_always_in_insert_mode:" .. self.buf, { clear = true }),
    buffer = self.buf,
    command = "startinsert",
    desc = "exe terminal always in insert mode"
  })
  vim.cmd.startinsert()
  self.win_id = win_id
end

---@private
---@return boolean
function Executable:is_focused()
  return self:visible() and vim.api.nvim_get_current_win() == self.win_id
end

---@private
function Executable:focus()
  vim.api.nvim_set_current_win(self.win_id)
end

---@private
---@return boolean
function Executable:visible()
  return util.check_win(self.win_id, FLAG_KEY, FLAG_VAL)
end

---@private
function Executable:close()
  vim.api.nvim_win_close(self.win_id, true)
  self.win_id = nil
end

---@private
---@return boolean
function Executable:is_running()
  return self.chan_id ~= nil
      and vim.fn.jobwait({ self.chan_id }, 0)[1] == -1
end

return Executable
