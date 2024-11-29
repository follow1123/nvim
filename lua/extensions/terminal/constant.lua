---@class TermConstant
---@field term_filetype string
---@field defalut_cmd string
return {
  term_filetype = "customterm",
  defalut_cmd = _G.IS_WINDOWS and "pwsh" or "zsh"
}
