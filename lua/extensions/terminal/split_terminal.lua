local Terminal = require("extensions.terminal.terminal")

---@alias WindowDirection
---| '"left"'
---| '"right"'
---| '"top"'
---| '"bottom"'

---@class SplitTerminal:Terminal
---@field direction WindowDirection
---@field buf integer
---@field win_id? integer
---@field prev_win_id integer
local SplitTerminal = Terminal:derive()

---@type table<WindowDirection, string>
local direction_map = {
  ["left"] = "topleft vsplit",
  ["right"] = "botright vsplit",
  ["top"] = "topleft split",
  ["bottom"] = "botright split"
}

local def_direction = "bottom"

function SplitTerminal:new(cmd)
  ---@type SplitTerminal
  local instance = Terminal.new(self, cmd)
  instance.direction = def_direction
  return instance
end

function SplitTerminal:split_window()
  self.prev_win_id = vim.api.nvim_get_current_win()
  vim.cmd(direction_map[self.direction])
  self.win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(self.win_id, self.buf)
  self:on_split_window()
end

---@param direction? WindowDirection
function SplitTerminal:start(direction)
  if type(direction) == "string" then self.direction = direction end
  self.buf = vim.api.nvim_create_buf(false, true)
  if self.buf == 0 then
    vim.notify("start split terminal failed", vim.log.levels.WARN)
    self.buf = nil
    self.win_id = nil
    return
  end
  vim.api.nvim_buf_set_option(self.buf, "filetype", "customterm")
  self:on_buf_created()
  self:split_window()
  Terminal.start(self)
end

-- 校验 win_id 是否有效
---@param win_id integer
---@return boolean
local function check_win(win_id)
  return win_id and vim.api.nvim_win_is_valid(win_id)
end

-- 校验 buffer 是否有效
---@param buf integer
---@return boolean
local function check_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

function SplitTerminal:close()
  vim.api.nvim_win_close(self.win_id, true)
  self.win_id = nil
end

function SplitTerminal:back_to_prev_win()
  if self.prev_win_id == vim.api.nvim_get_current_win() then
    self.prev_win_id = nil
    return
  end
  if not check_win(self.prev_win_id) then
    self.prev_win_id = vim.fn.win_id2win(vim.fn.winnr("#"))
  end
  if check_win(self.prev_win_id) then
    vim.fn.win_gotoid(self.prev_win_id)
  end
  self.prev_win_id = nil
end

-- 终端退出时执行的操作
function SplitTerminal:on_exit()
  self:reset()
end

function SplitTerminal:on_buf_created()
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = self.buf,
    desc = "terminal: resize window when vim window resized",
    command = "wincmd ="
  })
  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    buffer = self.buf,
    desc = "terminal: enter terminal mode when enter a terminal buffer",
    command = "startinsert"
  })
  local tmap = require("utils.keymap").tmap
  tmap("<Esc>", [[<C-\><C-n>]], "terminal: Enter normal mode in terminal", self.buf)
  tmap("<C-[>", [[<C-\><C-n>]], "terminal: Enter normal mode in terminal", self.buf)
  tmap("<M-4>", function() self:toggle() end, "terminal: Toggle split terminal", self.buf)
end

function SplitTerminal:on_split_window()
  -- vim.notify("terminal is split, do nothing", vim.log.levels.WARN)
end

-- 判断浮动终端是否显示
---@return boolean
function SplitTerminal:visible()
  if not check_win(self.win_id) then return false end
  local wins = vim.api.nvim_list_wins()
  for _, win_id in ipairs(wins) do
    if win_id == self.win_id then return true end
  end
  return false
end

function SplitTerminal:is_focused()
  return self.win_id == vim.api.nvim_get_current_win()
end

function SplitTerminal:focus()
  vim.fn.win_gotoid(self.win_id)
end

function SplitTerminal:toggle()
  if self:visible() then
    if self:is_focused() then
      self:close()
      self:back_to_prev_win()
      return
    end
    self:focus()
    return
  end

  if check_buf(self.buf) and self:is_running() then
    self:split_window()
    return
  end
  self:start()
end

function SplitTerminal:reset()
  if check_buf(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end
  self:stop()
  self.buf = nil
  self.win_id = nil
  self.prev_win_id = nil
  self.direction = def_direction
end

return SplitTerminal
