local M = {}

local util = require("extensions.netrw-plus.util")

---@type integer|nil
local prev_buf;

-- 打开 netrw
local function open_netrw()
  prev_buf = vim.api.nvim_get_current_buf()
  local cur_full_path = vim.api.nvim_buf_get_name(prev_buf)
  local cwd = vim.uv.cwd()
  if cwd == nil then return end
  local dir = vim.fn.fnamemodify(cur_full_path, ":h")
  if not util.in_cwd(cwd, cur_full_path) then
    dir = cwd
  end
  vim.cmd { cmd = "Explore", args = { dir } }
  vim.schedule_wrap(vim.fn.search)(vim.fn.fnamemodify(cur_full_path, ":t"))
end

-- 关闭 netrw
local function close_netrw()
  -- 如果通过命令直接打开 prev_buf 就会为空
  -- 为空则获取上次访问的 buffer
  -- 还是没用则直接关闭 netrw
  if prev_buf == nil or not vim.api.nvim_buf_is_valid(prev_buf) then
    prev_buf = vim.fn.bufnr("#")
    if prev_buf == -1 then
      vim.cmd.bwipeout()
      return
    end
  end

  -- 如果有多个窗口，并且 prev_buf 对应的窗口就在其中，则直接跳转过去
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    if vim.fn.bufwinid(prev_buf) == win then
      vim.fn.win_gotoid(win)
      return
    end
  end
  -- 否则打开 prev_buf
  vim.cmd.buffer(prev_buf)
end

-- 跳转到 netrw 对应的窗口
local function goto_netrw_window(winid)
  if winid == nil then return end
  vim.fn.win_gotoid(winid)
end

-- 显示或隐藏netrw buffer
function M.toggle()
  local netrw_win = util.get_visible_netrw_winid()
  if netrw_win == nil then
    open_netrw()
    return
  end

  local cur_win = vim.api.nvim_get_current_win()
  if cur_win == netrw_win then
    close_netrw()
    prev_buf = nil
    return
  end

  goto_netrw_window(netrw_win)
end

local netrw_group = vim.api.nvim_create_augroup("netrw_locate_file", { clear = true })
-- 切换窗口后netrw窗口自动定位当前文件
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  pattern = vim.fs.normalize(vim.fn.getcwd()) .. "/*",
  group = netrw_group,
  desc = "netrw: Locate file in netrw buffer",
  callback = vim.schedule_wrap(function(e)
    -- 进入 netrw 窗口直接定位之前窗口的文件
    if "netrw" == vim.o.filetype then
      local prev_path = vim.api.nvim_buf_get_name(vim.fn.winbufnr(vim.fn.winnr("#")))
      vim.schedule_wrap(vim.fn.search)(vim.fn.fnamemodify(prev_path, ":t"))
      return
    end
    local netrw_win = util.get_visible_netrw_winid()
    -- 当前窗口内 netrw 没有打开也直接退出
    if netrw_win == nil then return end
    local cur_full_path = vim.fs.normalize(vim.api.nvim_buf_get_name(e.buf))

    local stat = vim.uv.fs_stat(cur_full_path)
    -- 当前文件是个目录直接退出
    if stat == nil or stat.type ~= "file" then return end

    local netrw_buf = vim.fn.winbufnr(netrw_win)
    local dir = vim.fn.fnamemodify(cur_full_path, ":h")
    local filename = vim.fn.fnamemodify(cur_full_path, ":t")
    vim.api.nvim_buf_call(netrw_buf, function()
      local buf_full_path = vim.fs.normalize(vim.api.nvim_buf_get_name(netrw_buf))
      if buf_full_path ~= cur_full_path then
        vim.cmd { cmd = "Explore", args = { dir } }
      end
      vim.fn.search(filename)
    end)
  end)
})

-- 在netrw内定位当前文件
require("utils.keymap").nmap("<leader>fL", function()
  local netrw_win = util.get_visible_netrw_winid()
  if not netrw_win then return end
  local cur_full_path = vim.fs.normalize(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
  local stat = vim.uv.fs_stat(cur_full_path)
  -- 当前 buffer 内不是文件就直接退出
  if stat == nil or stat.type ~= "file" then return end

  local netrw_buf = vim.fn.winbufnr(netrw_win)
  local dir = vim.fn.fnamemodify(cur_full_path, ":h")
  local filename = vim.fn.fnamemodify(cur_full_path, ":t")

  vim.api.nvim_buf_call(netrw_buf, function()
    local buf_full_path = vim.fs.normalize(vim.api.nvim_buf_get_name(netrw_buf))
    if buf_full_path ~= cur_full_path then
      vim.cmd { cmd = "Explore", args = { dir } }
    end
    vim.fn.search(filename)
  end)
end, "netrw: Locate current file in netrw buffer")

return M
