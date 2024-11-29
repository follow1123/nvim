---@class Terminal
---@field cmd string[]
---@field chan_id integer
local Terminal = {}

-- 从当前类派生出一个子类
---@param clazz? table
---@return table obj
function Terminal:derive(clazz)
  self.__index = self
  return setmetatable(clazz or {}, self)
end

-- 创建一个当前类的实例
---@param cmd string|string[]
function Terminal:new(cmd)
  return self:derive({ cmd = type(cmd) == "string" and { cmd } or cmd })
end

-- 打开终端
function Terminal:start()
  local chan_id = vim.fn.termopen(self.cmd, {
    on_exit = function() self:on_exit() end
  })
  assert(chan_id > 0, "start terminal failed")
  ---@cast chan_id integer
  self.chan_id = chan_id
end

-- 停止终端
function Terminal:stop()
  if not self:is_running() then
    self.chan_id = nil
    return
  end
  if vim.fn.jobstop(self.chan_id) ~= 1 then
    vim.notify("stop terminal failed", vim.log.levels.WARN)
    return
  end
  self.chan_id = nil
end

function Terminal:on_exit()
  vim.notify("terminal is exit, do nothing", vim.log.levels.WARN)
end

-- 判断终端是否运行
---@return boolean
function Terminal:is_running()
  return self.chan_id and vim.fn.jobwait({ self.chan_id }, 0)[1] == -1
end

-- 发送消息到终端
---@param msg string|string[]
function Terminal:send_message(msg)
  msg = type(msg) == "string" and { msg } or msg
  ---@cast msg string[]
  for _, m in ipairs(msg) do
    vim.api.nvim_chan_send(self.chan_id, m)
  end
end

return Terminal
