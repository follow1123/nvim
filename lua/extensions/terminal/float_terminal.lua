local Terminal = require("extensions.terminal.terminal")
local util = require("extensions.util")
local constant = require("extensions.terminal.constant")

---@class FloatTerminal:Terminal
---@field buf integer
---@field win_id? integer
local FloatTerminal = Terminal:derive()

-- 生成默认窗口配置
---@param win_conf? table<string, any>
---@return table<string, any> win_conf
function FloatTerminal.def_win_conf(win_conf)
  local def_win_config = {
    relative = "editor",
    width = vim.api.nvim_get_option("columns"),
    height = vim.api.nvim_get_option("lines") - vim.o.cmdheight,
    row = 0,
    col = 0,
    style = "minimal",
    border = "none",
  }
  if win_conf == nil then return def_win_config end
  return vim.tbl_extend("force", win_conf, def_win_config)
end

-- 启动并显示浮动终端
function FloatTerminal:start()
  self.buf = vim.api.nvim_create_buf(false, true)
  if self.buf == 0 then
    vim.notify("start float terminal failed", vim.log.levels.WARN)
    self.buf = nil
    return
  end
  vim.api.nvim_buf_set_option(self.buf, "filetype", constant.term_filetype)
  self:on_buf_created()
  self:popup()
  Terminal.start(self)
end

-- 显示浮动终端
function FloatTerminal:popup()
  self.win_id = vim.api.nvim_open_win(self.buf, true, self.def_win_conf())
  if self.win_id == 0 then
    vim.notify("popup terminal failed", vim.log.levels.WARN)
    self.win_id = nil
    return
  end
  self:on_popup()
end

-- 隐藏浮动终端
function FloatTerminal:hide()
  vim.api.nvim_win_close(self.win_id, true)
  self.win_id = nil
end

-- 显示或隐藏浮动终端
function FloatTerminal:toggle()
  if self:visible() then
    self:hide()
    return
  end
  if util.check_buf(self.buf) and self:is_running() then
    self:popup()
    return
  end
  self:start()
end

-- 终端对应的 buffer 创建完成时执行的操作
function FloatTerminal:on_buf_created()
  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("terminal_window_resized", { clear = true }),
    buffer = self.buf,
    callback = function(e)
      local winid = vim.fn.bufwinid(e.buf)
      local default_config = self.def_win_conf()
      vim.api.nvim_win_set_width(winid, default_config.width)
      vim.api.nvim_win_set_height(winid, default_config.height)
      vim.api.nvim_input([[<Esc>^i]])
    end
  })
  local tmap = require("utils.keymap").tmap
  tmap("<Esc>", [[<C-\><C-n>]], "terminal: enter normal mode in terminal", self.buf)
  tmap("<C-\\>", function() self:toggle() end, "terminal: Toggle terminal", self.buf)
end

-- 终端对应的 window 创建完成时执行的操作
function FloatTerminal:on_popup()
  vim.cmd.startinsert({ bang = true })
end

-- 终端退出时执行的操作
function FloatTerminal:on_exit() self:reset() end

-- 判断浮动终端是否显示
---@return boolean
function FloatTerminal:visible()
  return util.check_win(self.win_id) and vim.api.nvim_get_current_win() == self.win_id
end

-- 重置终端
function FloatTerminal:reset()
  if util.check_buf(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end
  self:stop()
  self.buf = nil
  self.win_id = nil
end

return FloatTerminal
