local FloatTerminal = require("extensions.terminal.float_terminal")
local tmap = require("utils.keymap").tmap

---@class ext.terminal.FloatLazygit
---@field terminal ext.terminal.FloatTerminal
local FloatLazygit = {}

FloatLazygit.__index = FloatLazygit

---@param toggle_key string
---@return ext.terminal.FloatLazygit
function FloatLazygit:new(toggle_key)
  local instance = setmetatable({ terminal = FloatTerminal:new("lazygit") }, self)

  instance.terminal.on_buf_created = function(buf)
    local float_lazygit_group = vim.api.nvim_create_augroup("float_lazygit:" .. buf, { clear = true })
    vim.api.nvim_create_autocmd("VimResized", {
      desc = "FloatLazygit: resize window when vim resized",
      group = float_lazygit_group,
      buffer = buf,
      callback = function()
        local win_id = vim.fn.bufwinid(buf)
        vim.api.nvim_win_set_config(win_id, instance.terminal.get_win_config())
      end
    })

    vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
      group = float_lazygit_group,
      buffer = buf,
      desc = "FloatLazygit: set same options when enter window",
      callback = function()
        local win_id = vim.fn.bufwinid(buf)
        -- 这两个属性需要事件完成后执行才能正常设置
        vim.schedule_wrap(vim.api.nvim_set_option_value)("wrap", true, { win = win_id })
        vim.schedule_wrap(vim.api.nvim_set_option_value)("signcolumn", "no", { win = win_id })

        vim.api.nvim_set_option_value("number", false, { win = win_id })
        vim.api.nvim_set_option_value("relativenumber", false, { win = win_id })
        vim.api.nvim_set_option_value("winhighlight", "Normal:Normal", { win = win_id })
        vim.cmd.startinsert()
      end
    })

    tmap(toggle_key, function() instance:toggle() end, "terminal: Toggle terminal", buf)
  end
  return instance
end

function FloatLazygit:toggle()
  self.terminal:toggle()
end

return FloatLazygit
