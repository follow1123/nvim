local config = require("extensions.terminal.config")
local util = require("extensions.util")

---@type ext.terminal.Terminal
local Terminal = require("extensions.terminal.terminal")

---@class ext.terminal.FloatTerminal
---@field terminal ext.terminal.Terminal
---@field buf? integer
---@field win_id? integer
---@field on_buf_created fun(buf: integer)
---@field get_win_config fun(): vim.api.keyset.win_config
local FloatTerminal = {}

FloatTerminal.__index = FloatTerminal

---实例化 FloatTerminal 对象
---@param cmd? string
---@return ext.terminal.FloatTerminal
function FloatTerminal:new(cmd)
  local instance = setmetatable({terminal = Terminal:new(cmd)}, self)
  instance.terminal.on_exit = function() instance:reset() end
  return instance
end

---启动并显示浮动终端
function FloatTerminal:start()
  self.buf = vim.api.nvim_create_buf(false, true)
  if self.buf == 0 then
    vim.notify("start float terminal failed", vim.log.levels.WARN)
    self.buf = nil
    return
  end
  vim.api.nvim_set_option_value("filetype", config.filetype, { buf = self.buf })
  self.on_buf_created(self.buf)
  self:popup()
  self.terminal:start()
end

---显示浮动终端
function FloatTerminal:popup()
  local win_config = self.get_win_config()
  self.win_id = vim.api.nvim_open_win(self.buf, true, win_config)
  if self.win_id == 0 then
    vim.notify("popup terminal failed", vim.log.levels.WARN)
    self.win_id = nil
    return
  end

  vim.api.nvim_set_option_value("winhighlight", "Normal:Normal", {
    win = self.win_id
  })
  vim.api.nvim_set_option_value("wrap", true, { win = self.win_id })
  vim.cmd.startinsert({ bang = true })
end

---隐藏浮动终端
function FloatTerminal:hide()
  vim.api.nvim_win_close(self.win_id, true)
  self.win_id = nil
end

---显示或隐藏浮动终端
function FloatTerminal:toggle()
  if self:visible() then
    self:hide()
    return
  end
  if util.check_buf(self.buf) and self.terminal:is_running() then
    self:popup()
    return
  end
  self:start()
end

---判断浮动终端是否显示
---@return boolean
function FloatTerminal:visible()
  return util.check_win(self.win_id) and vim.api.nvim_get_current_win() == self.win_id
end

---重置终端
function FloatTerminal:reset()
  if util.check_buf(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end
  self.terminal:stop()
  self.buf = nil
  self.win_id = nil
end

---默认 buffer 创建完成后执行的操作
function FloatTerminal.on_buf_created(_) end

---@return vim.api.keyset.win_config
function FloatTerminal.get_win_config()
  return FloatTerminal.generate_win_config()
end

---生成默认窗口配置
---@param conf? vim.api.keyset.win_config
---@return vim.api.keyset.win_config
function FloatTerminal.generate_win_config(conf)
  local default_win_conf = {
    relative = "editor",
    width = vim.api.nvim_get_option_value("columns", {}),
    height = vim.api.nvim_get_option_value("lines", {}) - vim.o.cmdheight,
    row = 0,
    col = 0,
    style = "minimal",
    border = "none",
  }
  if conf == nil then return default_win_conf end
  return vim.tbl_extend("keep", conf, default_win_conf)
end

return FloatTerminal
