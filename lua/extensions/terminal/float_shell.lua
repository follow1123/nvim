---@type ext.terminal.FloatTerminal
local FloatTerminal = require("extensions.terminal.float_terminal")

---@class ext.terminal.FloatShell
---@field terminal ext.terminal.FloatTerminal
local FloatShell = {}

FloatShell.__index = FloatShell

---@param toggle_key string
---@return ext.terminal.FloatShell
function FloatShell:new(toggle_key)
  local instance = setmetatable({ terminal = FloatTerminal:new() }, self)

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
    tmap("<Esc>", [[<C-\><C-n>]], "terminal: enter normal mode in terminal", buf)
    tmap(toggle_key, function() instance:toggle() end, "terminal: Toggle terminal", buf)
  end

  instance.terminal.get_win_config = function()
    local window_height = vim.api.nvim_get_option_value("lines", {})
    local window_width = vim.api.nvim_get_option_value("columns", {})
    local height = math.floor(window_height * 0.8)
    local width = math.floor(window_width * 0.8)
    local row = math.floor((window_height - height) / 2)
    local col = math.floor((window_width - width) / 2)

    return FloatTerminal.generate_win_config({
      height = height,
      width = width,
      row = row,
      col = col,
      border = "single"
    })
  end
  return instance
end

function FloatShell:toggle()
  self.terminal:toggle()
end

return FloatShell
