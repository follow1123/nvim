local util = require("extensions.terminal.utils")


---@class Term table 全屏终端
---@field bufnr number buffer number
---@field winid number window id
---@field chan_id number terminal job channel id
---@field cmd string command
---@field new function
---@field open function
---@field stop function
---@field hide function
---@field reset_terminal function
---@field is_visible function
---@field show function
---@field toggle function
---@field send_message function
---@field on_open function 
---@field on_exit function
local Term = {}

Term.__index = Term

---@param cmd string
---@return table Term
function Term:new(cmd)
  return setmetatable({ cmd = cmd }, self)
end

---打开后操作配置buffer相关keymap或option
function Term:on_open()

  util.create_focus_term_event(self.bufnr)

  util.start_insert_event(self.bufnr)

end

---终端退出后操作
function Term:on_exit()
  self:reset_terminal()
end

---打开
function Term:open()

  self.bufnr = util.create_term_buf()
  self.winid = util.open_full_window(true, self.bufnr)

  local chan_id = vim.fn.termopen(self.cmd, {
    on_exit = function()
      self:on_exit()
    end
  })

  if chan_id == nil or chan_id <= 0 then
    vim.notify("Open terminal failed", vim.log.levels.WARN)
  else
    self.chan_id = chan_id
  end

  self:on_open()
end

---显示
function Term:show()
  self.winid = util.open_full_window(true, self.bufnr)
end

---是否可视
function Term:is_visible()
  return self.winid and vim.api.nvim_win_is_valid(self.winid)
end

---隐藏
function Term:hide()
  if self.winid then
    vim.api.nvim_win_close(self.winid, true)
    self.winid = nil
  end
end

---停止
function Term:stop()
  vim.fn.jobstop(self.chan_id)
end

---开打或关闭
function Term:toggle()
  if self:is_visible() then
    self:hide()
  else
    if self.bufnr and vim.api.nvim_buf_is_valid(self.bufnr) and self.chan_id then
      self:show()
    else
      if not self.chan_id or vim.fn.jobstop(self.chan_id) ~= 1 then
        self:reset_terminal()
      end
      self:open()
    end
  end
end

---重置属性
function Term:reset_terminal()
  if self.bufnr then
    vim.api.nvim_buf_delete(self.bufnr, { force = true })
  end
  self.bufnr = nil
  self.winid = nil
  self.chan_id = nil
end

---@param msg string
---发送消息
function Term:send_message(msg)
  if self.chan_id then
    vim.api.nvim_chan_send(self.chan_id, msg)
  end
end


return Term
