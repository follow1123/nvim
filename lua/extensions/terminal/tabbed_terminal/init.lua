local Window = require("extensions.terminal.tabbed_terminal.window")
local Terminal = require("extensions.terminal.tabbed_terminal.terminal")
local TerminalList = require("extensions.terminal.tabbed_terminal.terminal_list")

local util = require("extensions.terminal.util")

local km = vim.keymap.set

---@class ext.terminal.tabbed.Keys
---@field toggle string
---@field new? string
---@field next? string
---@field previous? string

---@class ext.terminal.tabbed.Config
---@field keys ext.terminal.tabbed.Keys
---@field win_size? ext.terminal.WindowSize

---@class ext.terminal.tabbed.Manager
---@field private window ext.terminal.tabbed.Window
---@field private list ext.terminal.tabbed.TerminalList
---@field private config ext.terminal.tabbed.Config
local TabbedTerminal = {}

---@private
TabbedTerminal.__index = TabbedTerminal

---@param config ext.terminal.tabbed.Config
---@return ext.terminal.tabbed.Manager
function TabbedTerminal:new(config)
  assert(config, "config not be nil")
  assert(config.keys, "keys not be nile")
  assert(config.keys.toggle, "toggle key not be nil")
  config.keys.new = config.keys.new or "<M-n>"
  config.keys.next = config.keys.next or "<M-l>"
  config.keys.previous = config.keys.previous or "<M-h>"
  config.win_size = config.win_size or "auto"
  return setmetatable({
    window = Window:new(config.win_size),
    list = TerminalList:new(),
    config = config,
  }, self)
end

function TabbedTerminal:toggle()
  if self.window:visible() then
    if not self.window:is_focused() then
      self.window:focus()
      return
    end
    self.list:current():save_status()
    self.window:close()
    return
  end

  local empty_list = self.list:is_empty()
  local terminal = empty_list and self:create_terminal() or self.list:current()
  self.window:open(terminal.buf)
  if empty_list then terminal:start() end
  self:render_window()
  terminal:restore_status()
end

---@private
---@return ext.terminal.tabbed.Terminal
function TabbedTerminal:create_terminal()
  local terminal = Terminal:new({
    on_exit = function(buf)
      local only_one = self.list:only_one()
      self.list:remove(buf)
      if not self.window:visible() then return end

      if only_one then
        self.window:close()
      else
        local t = self.list:current()
        self.window:set_buf(t.buf)
        t:restore_status()
        self:render_window()
      end
    end,
    on_buf_created = function(buf)
      vim.api.nvim_create_autocmd("VimResized", {
        desc = "exe_terminal: resize window when vim resized",
        group = vim.api.nvim_create_augroup("resize terminal window:" .. buf, { clear = true }),
        buffer = buf,
        callback = function()
          local win_id = vim.fn.bufwinid(buf)
          vim.api.nvim_win_set_config(win_id, util.generate_win_config(self.config.win_size))
        end
      })

      km("t", "<Esc>", [[<C-\><C-n>]], { desc = "tabbed terminal: enter normal mode", buffer = buf })
      km("t", self.config.keys.toggle, function() self:toggle() end,
        { desc = "tabbed terminal: toggle terminal", buffer = buf })
      km({ "t", "n" }, self.config.keys.new, function()
          assert(self.window:visible(), "tabbed window is not visible")
          self.list:current():save_status()
          local t = self:create_terminal()
          self.window:set_buf(t.buf)
          t:start()
          t:restore_status()
          self:render_window()
        end,
        { desc = "tabbed terminal: new terminal", buffer = buf })
      km({ "t", "n" }, self.config.keys.next, function() self:nav(true) end,
        { desc = "tabbed terminal: next terminal", buffer = buf })
      km({ "t", "n" }, self.config.keys.previous, function() self:nav(false) end,
        { desc = "tabbed terminal: previous terminal", buffer = buf })
    end
  })
  self.list:add(terminal)
  return terminal
end

---@private
---@param next boolean
function TabbedTerminal:nav(next)
  assert(self.window:visible(), "tabbed window is not visible")
  self.list:current():save_status()
  local terminal = self.list:nav(next)
  self.window:set_buf(terminal.buf)
  self:render_window()

  terminal:restore_status()
end

---@private
function TabbedTerminal:render_window()
  local title = string.format("[%d/%d] [new:%s, next:%s, previous:%s]",
    self.list.current_idx,
    self.list:size(),
    self.config.keys.new,
    self.config.keys.next,
    self.config.keys.previous
  )
  self.window:set_title(title)
end

return TabbedTerminal
