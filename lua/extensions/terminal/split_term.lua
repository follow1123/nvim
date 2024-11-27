local util = require("extensions.terminal.utils")
local Term = require("extensions.terminal.term")

local tmap = require("utils.keymap").tmap

---@class SplitTerm table 全屏终端
---@field bufnr number buffer number
---@field winid number window id
---@field chan_id number terminal job channel id
---@field cmd string command
---@field from_winid number 从哪个窗口打开
---@field ratio number 窗口占比
---@field position "top" | "bottom" | "left" | "right" 分屏位置
---@field size number 正数表示宽度，复数表示高度
---@field window_cmd string 打开分屏窗口的命令
---@field new function
---@field open function
---@field stop function
---@field hide function
---@field reset_terminal function
---@field is_visible function
---@field is_focus function
---@field show function
---@field toggle function
---@field send_message function
---@field on_open function 
---@field on_exit function
local SplitTerm = {}

SplitTerm.__index = SplitTerm

setmetatable(SplitTerm, Term)


---@param ratio number 窗口占比
---@param position "top" | "bottom" | "left" | "right" 分屏位置
---@return integer size
local function reset_size(position, ratio)
  local size
  if position == "top" or position == "bottom" then
    size = (vim.api.nvim_get_option("lines") - 1) * -ratio
  elseif position == "left" or position == "right" then
    size = vim.api.nvim_get_option("columns") * ratio
  else
    size = vim.api.nvim_get_option("columns") / 2
  end
  return vim.fn.round(size)
end

---@param position "top" | "bottom" | "left" | "right" 分屏位置
---@return string command
local function split_cmd(position)
  --[[
  top > topleft split
  bottom > botright split
  left > topleft vsplit
  right > botright vsplit
  ]]--
  if position == "top" then
    return "topleft split"
  elseif position == "bottom" then
    return "botright split"
  elseif position == "left" then
    return "topleft vsplit"
  elseif position == "right" then
    return "botright vsplit"
  else
    return ""
  end
end

-- 如果nvim-tree窗口是打开的情况下则还原nvim-tree窗口到最左边
local function reset_nvim_tree()
  local visible_wins = vim.api.nvim_list_wins()
  for _, winid in ipairs(visible_wins) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local win_width = vim.api.nvim_win_get_width(winid)
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if filetype == "NvimTree" then
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd.wincmd("H")
        vim.api.nvim_win_set_width(winid, win_width)
      end)
      break
    end
  end
end

---@param opt table
---构造方法
function SplitTerm:new(opt)
  opt = opt or {}
  local obj = {
    cmd = _G.IS_WINDOWS and "pwsh" or "zsh",
    position = opt.position or "bottom",
    ratio = opt.ratio or 0.3,
    keymap = opt.keymap or nil
  }

  obj.size = reset_size(obj.position, obj.ratio)
  obj.window_cmd = split_cmd(obj.position)

  return setmetatable(obj, self)
end

---打开
function SplitTerm:open()

  self.from_winid = vim.api.nvim_get_current_win()

  vim.cmd(self.window_cmd)

  self.winid = vim.api.nvim_get_current_win()

  self:set_window_size()

  self.bufnr = util.create_term_buf()
  vim.api.nvim_win_set_buf(self.winid, self.bufnr)

  local chan_id = vim.fn.termopen(self.cmd, {
    on_exit = function()
      self:on_exit()
    end
  })

  if chan_id == nil or chan_id <= 0 then
    vim.notify("Open terminal failed", vim.log.levels.WARN)
  else
    self.chan_id = chan_id
  end

  self:on_open()
end

---设置窗口宽度或高度
function SplitTerm:set_window_size()
  if self.size > 0 then
    vim.api.nvim_win_set_width(self.winid, self.size)
  else
    vim.api.nvim_win_set_height(self.winid, self.size * -1)
  end
end

---显示
function SplitTerm:show()

  self.from_winid = vim.api.nvim_get_current_win()

  vim.cmd(self.window_cmd)

  self.winid = vim.api.nvim_get_current_win()

  self:set_window_size()

  vim.api.nvim_win_set_buf(self.winid, self.bufnr)

  reset_nvim_tree()

end

---隐藏
function SplitTerm:hide()

  -- 保留当前的窗口宽度或高度
  if self.position == "top" or self.position == "bottom" then
    if _G.IS_GUI then
      self.size = (vim.api.nvim_win_get_height(self.winid) - 1) * -1
    else
      self.size = vim.api.nvim_win_get_height(self.winid) * -1
    end
  elseif self.position == "left" or self.position == "right" then
    self.size = vim.api.nvim_win_get_width(self.winid)
  end

  Term.hide(self)
  if self.from_winid then
    vim.fn.win_gotoid(self.from_winid)
  end

end

function SplitTerm:toggle()
  if self:is_visible() then
    if self:is_focus() then
      self:hide()
    else
      vim.fn.win_gotoid(self.winid)
    end
  else
    if self.bufnr and vim.api.nvim_buf_is_valid(self.bufnr) and self.chan_id then
      self:show()
    else
      if not self.chan_id or vim.fn.jobstop(self.chan_id) ~= 1 then
        self:reset_terminal()
      end
      self:open()
    end
  end
end

---是否获取焦点
function SplitTerm:is_focus()
  return self.winid and self.winid == vim.api.nvim_get_current_win()
end

---打开后操作
function SplitTerm:on_open()
  reset_nvim_tree()

  util.start_insert_event(self.bufnr)

  vim.api.nvim_create_autocmd("VimResized", {
    buffer = self.bufnr,
    callback = function()
      if self.winid and vim.api.nvim_win_is_valid(self.winid) then
        self.size = reset_size(self.position, self.ratio)
        self:set_window_size()
      end
    end
  })

  tmap("<Esc>", [[<C-\><C-n>]], "Enter normal mode in terminal", self.bufnr)
  tmap("<C-k>", [[<C-\><C-n><C-w>k]], "Move cursor to up window", self.bufnr)
  tmap("<M-4>", function() self:toggle() end, "Toggle split terminal", self.bufnr)
  tmap("<C-h>", [[<C-\><C-n><C-w>h]], "Move cursor to left window", self.bufnr)
  tmap("<C-up>", [[<C-\><C-n><C-w>+i]], "Increase window size", self.bufnr)
  tmap("<C-down>", [[<C-\><C-n><C-w>-i]], "Decrease window size", self.bufnr)
end


---重置终端信息
function SplitTerm:reset_terminal()
  Term.reset_terminal(self)
  self.size = reset_size(self.position, self.ratio)
  self.from_winid = nil
end

---退出时操作
function SplitTerm:on_exit()
  if vim.api.nvim_win_is_valid(self.from_winid) then
    vim.fn.win_gotoid(self.from_winid)
  end
  self:reset_terminal()
end

return SplitTerm
