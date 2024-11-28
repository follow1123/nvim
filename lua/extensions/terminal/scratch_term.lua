---@module "extensions.terminal.float_terminal"
local FloatTerminal = require("extensions.terminal.float_terminal")

---@class ScratchTerm:FloatTerminal
local ScratchTerm = FloatTerminal:derive()

function ScratchTerm:new()
  return FloatTerminal.new(self, _G.IS_WINDOWS and "pwsh" or "zsh")
end

return ScratchTerm
