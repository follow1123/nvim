local util = require("extensions.terminal.util")

local FLAG_KEY = "scratch_terminal"
local FLAG_VAL = "1"
local shell = vim.fn.has("unix") == 1 and "zsh" or "pwsh"

local km = vim.keymap.set

---@class ext.terminal.ScratchConfig
---@field toggle_key string

---@class ext.terminal.scratch
---@field private config ext.terminal.ScratchConfig
---@field private chan_id? integer
---@field private buf? integer
---@field private previous_buf? integer
---@field private is_insert_mode boolean
local Scratch = {}

---@private
Scratch.__index = Scratch

---@param config ext.terminal.ScratchConfig
---@return ext.terminal.scratch
function Scratch:new(config)
  assert(config.toggle_key, "toggle_key not be nil")
  return setmetatable({ config = config, is_insert_mode = true }, self)
end

function Scratch:toggle()
  if self:check_buf() and self:is_running() then
    if self:visible() then
      if not self:is_focused() then
        self:focus()
        return
      end
      self:hide()
    else
      self:show()
      self:restore_status()
    end
  else
    self:start()
    self:restore_status()
  end
end

---@private
function Scratch:start()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_var(buf, FLAG_KEY, FLAG_VAL)
  vim.api.nvim_set_option_value("filetype", "scratchterminal", { buf = buf })

  km("t", self.config.toggle_key, function() self:toggle() end,
    { desc = "scratch terminal: toggle scratch terminal", buffer = buf })
  km("t", "<Esc>", [[<C-\><C-n>]], { desc = "scratch terminal: enter normal mode", buffer = buf })
  self.buf = buf

  self:show()
  local chan_id = vim.fn.jobstart({ shell }, {
    term = true,
    on_exit = function()
      if self:check_buf() then
        vim.api.nvim_buf_delete(self.buf, { force = true })
        self.buf = nil
      end
      self.chan_id = nil
    end
  })
  assert(chan_id > 0, "start scratch terminal failed")
  ---@cast chan_id integer
  self.chan_id = chan_id

  -- 这两个属性需要事件完成后执行才能正常设置
  local opts = { scope = "local" }
  vim.schedule_wrap(vim.api.nvim_set_option_value)("wrap", true, opts)
  vim.schedule_wrap(vim.api.nvim_set_option_value)("signcolumn", "no", opts)
  vim.api.nvim_set_option_value("number", false, opts)
  vim.api.nvim_set_option_value("relativenumber", false, opts)
end

---@private
---@return boolean
function Scratch:is_running()
  return self.chan_id ~= nil
      and vim.fn.jobwait({ self.chan_id }, 0)[1] == -1
end

---@return boolean
function Scratch:is_focused()
  return self.buf == vim.api.nvim_get_current_buf()
end

function Scratch:focus()
  local win_id = vim.fn.bufwinid(self.buf)
  vim.api.nvim_set_current_win(win_id)
  self:restore_status()
end

---@return boolean
function Scratch:visible()
  return vim.fn.bufwinid(self.buf) ~= -1
end

---@private
function Scratch:show()
  assert(self:check_buf(), "buffer invalid")
  self.previous_buf = vim.api.nvim_get_current_buf()
  local win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win_id, self.buf)
end

---@private
function Scratch:hide()
  self:save_status()
  if self.previous_buf == nil then
    -- 使用内置api查找上次访问的buffer
    local buf = vim.fn.bufnr("#")
    if buf == -1 then
      -- 还是找不到则直接打开一个空buffer
      vim.cmd.enew()
    else
      self.previous_buf = buf
    end
  end
  vim.cmd.buffer(self.previous_buf)
  self.previous_buf = nil
end

function Scratch:save_status()
  local buf = vim.api.nvim_get_current_buf()
  assert(buf == self.buf, "invalid buffer")
  local current_mode = vim.api.nvim_get_mode().mode
  self.is_insert_mode = current_mode == "t"
end

function Scratch:restore_status()
  local buf = vim.api.nvim_get_current_buf()
  assert(buf == self.buf, "invalid buffer")
  if self.is_insert_mode then vim.cmd.startinsert() end
end

---@private
---@return boolean
function Scratch:check_buf()
  return util.check_buf(self.buf, FLAG_KEY, FLAG_VAL)
end

return Scratch
