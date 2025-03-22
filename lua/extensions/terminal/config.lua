---@class ext.terminal.Config
---@field defalut_shell string
---@field filetype string
return {
  defalut_shell = _G.IS_WINDOWS and "pwsh" or "zsh",
  filetype = "ext_terminal"
}
