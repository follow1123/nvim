---@alias WindowDirection
---| '"left"'
---| '"right"'
---| '"top"'
---| '"bottom"'

local Terminal = require("extensions.terminal.terminal")
local util = require("extensions.util")
local constant = require("extensions.terminal.constant")

local def_cmd = constant.defalut_cmd

---@class TaskTerminal:Terminal
---@field name string
---@field create_time integer
---@field manager TaskManager
---@field buf integer
local TaskTerminal = Terminal:derive()

---@param name string
---@param manager TaskManager
---@param cmd? string
---@return TaskTerminal
function TaskTerminal:new(name, manager, cmd)
  ---@type TaskTerminal
  local term = Terminal.new(self, cmd or def_cmd)
  term.name = name
  term.create_time = vim.uv.now()
  term.manager = manager
  return term
end

function TaskTerminal:start()
  local buf = vim.api.nvim_create_buf(false, true)
  assert(buf ~= 0, "start split terminal failed")
  vim.api.nvim_buf_set_option(buf, "filetype", constant.term_filetype)
  self.buf = buf
  self:on_buf_created()
  self.manager:open(self)
  Terminal.start(self)
end

---@return boolean # is running
function TaskTerminal:is_running()
  return util.check_buf(self.buf) and Terminal.is_running(self)
end

function TaskTerminal:on_exit()
  if util.check_buf(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end
  self.manager:on_task_exit(self.name)
  self:stop()
  self.buf = nil
  self.name = nil
  self.create_time = nil
end

---@param other TaskTerminal
---@return boolean
function TaskTerminal:__lt(other)
  return self.create_time < other.create_time
end

---@param other TaskTerminal
---@return boolean
function TaskTerminal:__eq(other)
  return self.name == other.name
end

function TaskTerminal:__tostring()
  return self.name
end

function TaskTerminal:on_buf_created()
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = self.buf,
    desc = "terminal: resize window when vim window resized",
    command = "wincmd ="
  })
  local tmap = require("utils.keymap").tmap
  tmap("<Esc>", [[<C-\><C-n>]], "terminal: Enter normal mode in terminal", self.buf)
  tmap("<C-[>", [[<C-\><C-n>]], "terminal: Enter normal mode in terminal", self.buf)
  self.manager:on_task_buf_created(self)
end

return TaskTerminal
