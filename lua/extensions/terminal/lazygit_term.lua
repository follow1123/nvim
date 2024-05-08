-- local util = require("extensions.terminal.utils")
local Term = require("extensions.terminal.term")

local keymap_util = require("utils.keymap")
local buf_map = keymap_util.buf_map

---@class LazygitTerm table 全屏终端
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
local LazygitTerm = {}

LazygitTerm.__index = LazygitTerm

setmetatable(LazygitTerm, Term)

local cmd = "lazygit"

function LazygitTerm:new()
  if not vim.fn.executable(cmd) then
    vim.notify("no lazygit command!", vim.log.levels.ERROR)
    return nil
  end
  return Term.new(self, cmd)
end

function LazygitTerm:on_open()
  Term.on_open(self)

  vim.api.nvim_create_autocmd("VimResized", {
    buffer = self.bufnr,
    callback = function(e)
      local winid = vim.fn.bufwinid(e.buf)
      vim.api.nvim_win_set_width(winid, vim.api.nvim_get_option("columns"))
      vim.api.nvim_win_set_height(winid, vim.api.nvim_get_option("lines") - 1)
      vim.api.nvim_input([[<C-\><C-n>^i]])
    end
  })

  buf_map("t", "<M-6>", function() self:toggle() end, "Toggle lazygit", self.bufnr)
end

function LazygitTerm:show()
  Term.show(self)
  -- 显示lazygit终端时内容会向左偏移，使用normal下^按键矫正
  vim.cmd("normal ^")
end

return LazygitTerm


