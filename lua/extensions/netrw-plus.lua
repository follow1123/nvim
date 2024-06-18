local M = {}

---@return string absolute-filepath
local function get_file_path()
  return vim.fs.normalize(
    vim.fn['netrw#Call']('NetrwFile', vim.fn['netrw#Call']('NetrwGetWord')))
end

---@return integer|nil winnr
local function get_visible_netrw_winnr()
  local wins = vim.api.nvim_list_wins()
  for _, winnr in ipairs(wins) do
    local ft = vim.api.nvim_get_option_value("filetype", { win = winnr })
    if ft == "netrw" then
      return winnr
    end
  end
  return nil
end

---@param bufnr number
---@param dir string
---@param filename string
local function locate_file(bufnr, dir, filename)
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd.e(dir)
    vim.fn.search(filename)
  end)
end

-- 在netrw内定位当前文件
vim.keymap.set("n", "<leader>fL",
  function ()
    local winnr = get_visible_netrw_winnr()
    if not winnr then
      return
    end

    local bufnr = vim.fn.winbufnr(winnr)

    local dir = vim.fn.expand("%:.:h")
    local filename = vim.fn.expand("%:t")

    locate_file(bufnr, dir, filename)
  end,
  {
    noremap = true, silent = true,
    desc = "netrw: Locate current file in netrw buffer"
  })

-- 切换窗口后netrw窗口自动定位当前文件
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  desc = "Locate file in netrw buffer",
  callback = function()
    vim.schedule(function ()
      local winnr = get_visible_netrw_winnr()
      if not winnr or winnr == vim.api.nvim_get_current_win() then return end

      local file = vim.fs.normalize(vim.fn.expand("%:p"))
      if vim.fn.empty(file) == 1 then return end
      local stat, err = (vim.loop or vim.uv).fs_stat(file)
      if err or (stat ~= nil and stat.type ~= "file") then return end

      local cwd = vim.fs.normalize(vim.fn.getcwd())
      if not string.find(file, cwd .. "/", 1, true) then return end

      locate_file(
        vim.fn.winbufnr(winnr),
        vim.fn.fnamemodify(file, ":h"),
        vim.fn.fnamemodify(file, ":t"))
    end)
  end
})

-- 复制绝对路径
function M.copy_absolute_path()
  vim.fn.setreg("+", get_file_path())
end

-- 复制相对路径
function M.copy_relative_path()
  local relative_path = vim.fs.normalize(
    vim.fn.fnamemodify(get_file_path(), ":."))
  vim.fn.setreg("+", relative_path)
end

-- 显示或隐藏netrw buffer
function M.toggle()
  local winnr = vim.api.nvim_get_current_win()

  local wins = vim.api.nvim_list_wins()
  local netrw_winnr

  for _, win in ipairs(wins) do
    local ft = vim.api.nvim_get_option_value("filetype", { win = win })
    if ft == "netrw" then
      netrw_winnr = win
      break
    end
  end
  if #wins == 1 and netrw_winnr == winnr then return end

  if not netrw_winnr then
    vim.g.netrw_browse_split = 4 -- 默认在上一个窗口打开文件(同一个窗口)
    vim.cmd("Lexplore")
    return
  end

  if winnr == netrw_winnr then
    vim.g.netrw_browse_split = 0
    vim.cmd.q()
  else
    vim.fn.win_gotoid(netrw_winnr)
  end
end

return M
