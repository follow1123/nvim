---@type ext.terminal.FloatTerminal
local FloatTerminal = require("extensions.terminal.float_terminal")
local tmap = require("utils.keymap").tmap

---@class ext.terminal.FloatShell
---@field terminal ext.terminal.FloatTerminal
local FloatShell = {}

FloatShell.__index = FloatShell

---@param toggle_key string
---@return ext.terminal.FloatShell
function FloatShell:new(toggle_key)
  local instance = setmetatable({ terminal = FloatTerminal:new() }, self)

  instance.terminal.on_buf_created = function(buf)
    local float_shell_group = vim.api.nvim_create_augroup("float_shell:" .. buf, { clear = true })

    vim.api.nvim_create_autocmd("VimResized", {
      desc = "FloatShell: resize window when vim resized",
      group = float_shell_group,
      buffer = buf,
      callback = function()
        local win_id = vim.fn.bufwinid(buf)
        vim.api.nvim_win_set_config(win_id, instance.terminal.get_win_config())
      end
    })

    vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
      group = float_shell_group,
      buffer = buf,
      desc = "FloatShell: set same options when enter window",
      callback = function()
        local win_id = vim.fn.bufwinid(buf)
        -- 这两个属性需要事件完成后执行才能正常设置
        vim.schedule_wrap(vim.api.nvim_set_option_value)("wrap", true, { win = win_id })
        vim.schedule_wrap(vim.api.nvim_set_option_value)("signcolumn", "no", { win = win_id })

        vim.api.nvim_set_option_value("number", false, { win = win_id })
        vim.api.nvim_set_option_value("relativenumber", false, { win = win_id })
        vim.api.nvim_set_option_value("winhighlight", "Normal:Normal", { win = win_id })
        if instance.terminal.in_t_mode then
          vim.cmd.startinsert()
        end
      end
    })

    tmap("<Esc>", [[<C-\><C-n>]], "terminal: enter normal mode in terminal", buf)
    tmap(toggle_key, function() instance:toggle() end, "terminal: Toggle terminal", buf)
  end

  instance.terminal.get_win_config = function()
    local window_height = vim.api.nvim_get_option_value("lines", {})
    local window_width = vim.api.nvim_get_option_value("columns", {})
    local height = math.floor(window_height * 0.8)
    local width = math.floor(window_width * 0.9)
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
