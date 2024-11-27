-- local util = require("extensions.terminal.utils")
local Term = require("extensions.terminal.term")

local tmap = require("utils.keymap").tmap

---@class FullTerm table 全屏终端
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
local FullTerm = {}

FullTerm.__index = FullTerm

setmetatable(FullTerm, Term)

function FullTerm:new()
  return Term.new(self, _G.IS_WINDOWS and "pwsh" or "zsh")
end

function FullTerm:on_open()
  Term.on_open(self)

  vim.api.nvim_create_autocmd("VimResized", {
    buffer = self.bufnr,
    callback = function(e)
      local winid = vim.fn.bufwinid(e.buf)
      vim.api.nvim_win_set_width(winid, vim.api.nvim_get_option("columns"))
      vim.api.nvim_win_set_height(winid, vim.api.nvim_get_option("lines") - 1)
      vim.api.nvim_input([[<Esc>^i]])
    end
  })

  tmap("<Esc>", [[<C-\><C-n>]], "Quit terminal mode", self.bufnr)
  tmap("<C-\\>", function () self:toggle() end, "Toggle terminal", self.bufnr)
end

return FullTerm
