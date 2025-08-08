-- terminal --------------------------------------------------------------------

local tabbed_terminal

---@type table<string, ext.terminal.Executable>
local executables = {}

local scratch_terminal

return {
  ---@param config ext.terminal.tabbed.Config
  toggle_tabbed_terminal = function(config)
    if tabbed_terminal == nil then
      tabbed_terminal = require("extensions.terminal.tabbed_terminal"):new(config)
    end
    tabbed_terminal:toggle()
  end,
  ---@param config ext.terminal.ExeConfig
  toggle_executable = function(config)
    assert(config.exe_path, "exe_path not be nil")
    local key = config.exe_path
    local exe_terminal = executables[key]
    if exe_terminal == nil then
      exe_terminal = require("extensions.terminal.executable"):new(config)
      executables[key] = exe_terminal
    end
    exe_terminal:toggle()
  end,
  ---@param config ext.terminal.ScratchConfig
  toggle_scratch_terminal = function(config)
    if scratch_terminal == nil then
      scratch_terminal = require("extensions.terminal.scratch_terminal"):new(config)
    end
    scratch_terminal:toggle()
  end,
}
