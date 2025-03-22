local config = require("extensions.terminal.config")

---@class ext.terminal.Terminal
---@field cmd string[]
---@field chan_id integer
---@field on_exit function
local Terminal = {}

Terminal.__index = Terminal

---默认处理 Terminal 退出时的回调
Terminal.on_exit = function() end

---实例化 Terminal 对象
---@param cmd? string
---@return ext.terminal.Terminal
function Terminal:new(cmd)
  return setmetatable({cmd = cmd and {cmd} or {config.defalut_shell}}, self)
end

function Terminal:start()
  local chan_id = vim.fn.termopen(self.cmd, {
    on_exit = self.on_exit
  })
  assert(chan_id > 0, "start terminal failed")
  ---@cast chan_id integer
  self.chan_id = chan_id
end

---@return boolean
function Terminal:is_running()
  return self.chan_id and vim.fn.jobwait({ self.chan_id }, 0)[1] == -1
end

function Terminal:stop()
  if self:is_running() then
    if vim.fn.jobstop(self.chan_id) ~= 1 then
      vim.notify("stop terminal failed", vim.log.levels.WARN)
      return
    end
  end
  self.chan_id = nil
end

---@param msg string|string[]
function Terminal:send_message(msg)
  msg = type(msg) == "string" and { msg } or msg
  ---@cast msg string[]
  for _, m in ipairs(msg) do
    vim.api.nvim_chan_send(self.chan_id, m)
  end
end

return Terminal
