-- terminal --------------------------------------------------------------------

local float_shell
local float_lazygit
local scratch_shell

return {
  toggle_float_shell = function(toggle_key)
    if float_shell == nil then
      float_shell = require("extensions.terminal.float_shell"):new(toggle_key)
    end
    float_shell:toggle()
  end,
  toggle_float_lazygit = function(toggle_key)
    if float_lazygit == nil then
      float_lazygit = require("extensions.terminal.float_lazygit"):new(toggle_key)
    end
    float_lazygit:toggle()
  end,
  toggle_scratch_shell = function(toggle_key)
    if scratch_shell == nil then
      scratch_shell = require("extensions.terminal.scratch_shell"):new(toggle_key)
    end
    scratch_shell:toggle()
  end
}
