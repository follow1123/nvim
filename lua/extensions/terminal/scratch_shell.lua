local Terminal = require("extensions.terminal.terminal")

local config = require("extensions.terminal.config")
local util = require("extensions.util")
local tmap = require("utils.keymap").tmap

---@class ext.terminal.ScratchShell.WindowOpts
---@field win_id integer
---@field wrap boolean
---@field signcolumn string
---@field number boolean
---@field relativenumber boolean
local WindowOpts = {}
WindowOpts.__index = WindowOpts

---@return ext.terminal.ScratchShell.WindowOpts
---@param win_id integer
function WindowOpts:new(win_id)
  return setmetatable({
    win_id = win_id,
    wrap = vim.api.nvim_get_option_value("wrap", { win = win_id }),
    signcolumn = vim.api.nvim_get_option_value("signcolumn", { win = win_id }),
    number = vim.api.nvim_get_option_value("number", { win = win_id }),
    relativenumber = vim.api.nvim_get_option_value("relativenumber", { win = win_id }),
  }, self)
end

function WindowOpts:set()
  local o = { win = self.win_id }
  -- 这两个属性需要事件完成后执行才能正常设置
  vim.schedule_wrap(vim.api.nvim_set_option_value)("wrap", true, o)
  vim.schedule_wrap(vim.api.nvim_set_option_value)("signcolumn", "no", o)

  vim.api.nvim_set_option_value("number", false, o)
  vim.api.nvim_set_option_value("relativenumber", false, o)
end

function WindowOpts:restore()
  local o = { win = self.win_id }
  vim.api.nvim_set_option_value("wrap", self.wrap, o)
  vim.api.nvim_set_option_value("signcolumn", self.signcolumn, o)
  vim.api.nvim_set_option_value("number", self.number, o)
  vim.api.nvim_set_option_value("relativenumber", self.relativenumber, o)
end

---@class ext.terminal.ScratchShell
---@field terminal ext.terminal.Terminal
---@field toggle_key string
---@field buf? integer
---@field win_id? integer
---@field win_opts? ext.terminal.ScratchShell.WindowOpts
---@field in_t_mode boolean
---@field previous_buf? integer
local ScratchShell = {}

ScratchShell.__index = ScratchShell

---@return ext.terminal.ScratchShell
---@param toggle_key string
function ScratchShell:new(toggle_key)
  local instance = setmetatable({
    toggle_key = toggle_key,
    terminal = Terminal:new(),
    in_t_mode = true
  }, self)
  instance.terminal.on_exit = function() instance:stop() end
  return instance
end

function ScratchShell:start()
  self.previous_buf = vim.api.nvim_get_current_buf()
  self.win_id = vim.api.nvim_get_current_win()
  self.buf = vim.api.nvim_create_buf(false, true)
  if self.buf == 0 then
    vim.notify("start float terminal failed", vim.log.levels.WARN)
    self.buf = nil
    return
  end
  vim.api.nvim_set_option_value("filetype", config.filetype, { buf = self.buf })
  self:on_buf_created()
  vim.cmd.buffer(self.buf)
  self.terminal:start()
end

---显示或隐藏浮动终端
function ScratchShell:toggle()
  if self:visible() then
    if self:is_focused() then
      self:hide()
    else
      self:focus()
    end
    return
  end
  if util.check_buf(self.buf) and self.terminal:is_running() then
    self:show()
    return
  end
  self:start()
end

---@return boolean
function ScratchShell:is_focused()
  return self.buf == vim.api.nvim_get_current_buf()
end

function ScratchShell:focus()
  if (util.check_win(self.win_id)) then
    vim.fn.win_gotoid(self.win_id)
  end
end

function ScratchShell:show()
  self.win_id = vim.api.nvim_get_current_win()
  self.previous_buf = vim.api.nvim_get_current_buf()
  vim.cmd.buffer(self.buf)
end

function ScratchShell:hide()
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

---@return boolean
function ScratchShell:visible()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.fn.winbufnr(win)
    if (buf == self.buf) then return true end
  end
  return false
end

function ScratchShell:stop()
  self:hide()
  if util.check_buf(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end
  self.terminal:stop()
  self.buf = nil
  self.win_id = nil
end

function ScratchShell:on_buf_created()
  local scratch_shell_group = vim.api.nvim_create_augroup("scratch_shell:" .. self.buf, { clear = true })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = scratch_shell_group,
    buffer = self.buf,
    desc = "ScratchShell: set same options when enter window",
    callback = function()
      local win_id = vim.fn.bufwinid(self.buf)
      self.win_opts = WindowOpts:new(win_id)
      self.win_opts:set()
      if self.in_t_mode then
        vim.cmd.startinsert()
      end
    end
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
    group = scratch_shell_group,
    buffer = self.buf,
    desc = "ScratchShell: store current mode",
    callback = function()
      self.in_t_mode = vim.fn.mode() == "t"
      if self.win_opts then
        self.win_opts:restore()
      end
    end
  })

  tmap("<Esc>", [[<C-\><C-n>]], "terminal: enter normal mode in terminal", self.buf)
  tmap(self.toggle_key, function() self:toggle() end, "terminal: Toggle terminal", self.buf)
end

return ScratchShell
