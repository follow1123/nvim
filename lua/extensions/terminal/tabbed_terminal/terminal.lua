local util = require("extensions.terminal.util")

local BUF_KEY = "tabbed_terminal_buffer"
local BUF_VAL = "1"
local shell = vim.fn.has("unix") == 1 and "zsh" or "pwsh"

---@class ext.terminal.tabbed.Options
---@field on_exit fun(buf: integer)
---@field on_buf_created fun(buf: integer)

---@class ext.terminal.tabbed.Terminal
---@field private chan_id? integer
---@field buf integer
---@field private on_exit fun(buf: integer)
---@field private mode string
---@field private cursor_pos? integer[]
local Terminal = {}

---@private
Terminal.__index = Terminal

---@param opts ext.terminal.tabbed.Options
function Terminal:new(opts)
  assert(opts, "options not be nil")
  assert(opts.on_exit, "on_exit not be nil")
  assert(opts.on_buf_created, "on_buf_created not be nil")
  local tt = setmetatable({}, self)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_var(buf, BUF_KEY, BUF_VAL)
  vim.api.nvim_set_option_value("filetype", "tabbedterminal", { buf = buf })
  tt.on_exit = function(b)
    opts.on_exit(b)
    if util.check_buf(b, BUF_KEY, BUF_VAL) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  opts.on_buf_created(buf)
  tt.buf = buf
  tt.mode = "t"
  return tt
end

function Terminal:start()
  local chan_id = vim.fn.termopen({ shell }, {
    on_exit = function() self.on_exit(self.buf) end
  })
  assert(chan_id > 0, "start terminal failed")
  ---@cast chan_id integer
  self.chan_id = chan_id
end

function Terminal:stop()
  assert(vim.fn.jobstop(self.chan_id) == 1, "stop failed")
  self.chan_id = nil
end

---@return boolean
function Terminal:is_running()
  return self.chan_id ~= nil
      and vim.fn.jobwait({ self.chan_id }, 0)[1] == -1
end

function Terminal:save_status()
  local buf = vim.api.nvim_get_current_buf()
  assert(buf == self.buf, "window not contains this buffer")

  local current_mode = vim.api.nvim_get_mode().mode
  if current_mode == "nt" then
    self.cursor_pos = vim.api.nvim_win_get_cursor(0)
    self.mode = current_mode
  else
    self.mode = "t"
  end
end

function Terminal:restore_status()
  local buf = vim.api.nvim_get_current_buf()
  assert(buf == self.buf, "window not contains this buffer")
  -- 进入 normal 模式后统一操作
  vim.api.nvim_input("<Esc>")
  if self.mode == "nt" then
    if self.cursor_pos then
      vim.schedule_wrap(vim.api.nvim_win_set_cursor)(0, self.cursor_pos)
    end
  else
    vim.schedule_wrap(vim.cmd.startinsert)()
  end
end

---@return boolean
function Terminal:is_valid()
  return util.check_buf(self.buf, BUF_KEY, BUF_VAL) and self:is_running()
end

return Terminal
