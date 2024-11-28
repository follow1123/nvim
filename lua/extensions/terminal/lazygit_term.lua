local FloatTerminal = require("extensions.terminal.float_terminal")

---@class LazygitTerm:FloatTerminal
local LazygitTerm = FloatTerminal:derive()

function LazygitTerm:new()
  return FloatTerminal.new(self, "lazygit")
end

function LazygitTerm:on_buf_created()
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = self.buf,
    callback = function(e)
      local winid = vim.fn.bufwinid(e.buf)
      local default_config = self.def_win_conf()
      vim.api.nvim_win_set_width(winid, default_config.width)
      vim.api.nvim_win_set_height(winid, default_config.height)
      vim.api.nvim_input([[<C-\><C-n>^i]])
    end
  })

  local tmap = require("utils.keymap").tmap
  tmap("<M-6>", function() self:toggle() end, "terminal: Toggle lazygit", self.buf)
  tmap([[<C-\><C-n>]], [[<C-\><C-n>^]], "terminal: enter nornal mode and align center", self.buf)
end

function LazygitTerm:on_popup()
  FloatTerminal.on_popup(self)
  -- 显示lazygit终端时内容会向左偏移，使用normal下^按键矫正
  vim.cmd.normal("^")
end

return LazygitTerm


