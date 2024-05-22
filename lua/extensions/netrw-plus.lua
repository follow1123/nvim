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

-- 在netrw内定位当前文件
vim.keymap.set("n", "<leader>fL", function ()
  local winnr = get_visible_netrw_winnr()
  if not winnr then
    return
  end

  local bufnr = vim.fn.winbufnr(winnr)

  local dir = vim.fn.expand("%:.:h")
  local filename = vim.fn.expand("%:t")

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("e " .. dir)
    vim.fn.search(filename)
  end)
end, {
  noremap = true, silent = true,
  desc = "netrw: Locate current file in netrw buffer"
})

-- 复制绝对路径
function M.copy_absolute_path()
  vim.fn.setreg("+", get_file_path())
end

-- 复制相对路径
function M.copy_relative_path()
   local relative_path = vim.fs.normalize(vim.fn.fnamemodify(get_file_path(), ":."))
  vim.fn.setreg("+", relative_path)
end

-- 显示或隐藏netrw buffer
function M.toggle()
  local winnr = vim.api.nvim_get_current_win()
  local netrw_winnr = get_visible_netrw_winnr()

  if not netrw_winnr then
    vim.cmd(":Lexplore")
    return
  end

  if winnr == netrw_winnr then
    vim.cmd(":q")
  else
    vim.fn.win_gotoid(netrw_winnr)
  end
end

return M
