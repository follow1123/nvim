local FloatTerminal = require("extensions.terminal.float_terminal")

---@class ext.terminal.FloatLazygit
---@field terminal ext.terminal.FloatTerminal
local FloatLazygit = {}

FloatLazygit.__index = FloatLazygit

---@param toggle_key string
---@return ext.terminal.FloatLazygit
function FloatLazygit:new(toggle_key)
  local instance = setmetatable({ terminal = FloatTerminal:new("lazygit") }, self)

  instance.terminal.on_buf_created = function(buf)
    vim.api.nvim_create_autocmd("VimResized", {
      group = vim.api.nvim_create_augroup("terminal_window_resized", { clear = true }),
      buffer = buf,
      callback = function()
        local winid = vim.fn.bufwinid(buf)
        vim.api.nvim_win_set_config(winid, instance.terminal.get_win_config())
        vim.api.nvim_set_option_value("wrap", true, { win = winid })
      end
    })
    local tmap = require("utils.keymap").tmap
    tmap(toggle_key, function() instance:toggle() end, "terminal: Toggle terminal", buf)
  end
  return instance
end

function FloatLazygit:toggle()
  self.terminal:toggle()
end

return FloatLazygit
