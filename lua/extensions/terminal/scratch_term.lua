---@module "extensions.terminal.float_terminal"
local FloatTerminal = require("extensions.terminal.float_terminal")
local constant = require("extensions.terminal.constant")

---@class ScratchTerm:FloatTerminal
local ScratchTerm = FloatTerminal:derive()

function ScratchTerm:new()
  return FloatTerminal.new(self, constant.defalut_cmd)
end

return ScratchTerm
