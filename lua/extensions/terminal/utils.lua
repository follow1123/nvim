local M = {}

---@param enter boolean 是否直接直接进入窗口
---@param bufnr number buffer number
---@return number winid
---打开一个全屏窗口
function M.open_full_window(enter, bufnr)
  return vim.api.nvim_open_win(bufnr, enter, {
    relative = "editor",
    width = vim.api.nvim_get_option("columns"),
    height = vim.api.nvim_get_option("lines") - 1,
    row = 0,
    col = 0,
    style = "minimal",
    border = "none",
  })
end

---@return number bufnr
---创建一个显示终端的buffer
function M.create_term_buf()
  local term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
  vim.api.nvim_buf_set_option(term_buf, "filetype", "fterm")
  return term_buf
end

---@param bufnr number
---全屏终端无法离开当前窗口，只能使用默认方式退出或离开
function M.create_focus_term_event(bufnr)
  vim.api.nvim_create_autocmd("WinLeave", {
    buffer = bufnr,
    callback = function(e)
      -- 终端窗口失去焦点时直接切换回来
      local winid = vim.fn.bufwinid(e.buf)
      vim.schedule(function()
        if winid > 0 and winid ~= vim.api.nvim_get_current_win() then
          vim.fn.win_gotoid(winid)
        end
      end)
    end
  })
end

---@param bufnr number
---打开终端后直接进入insert模式
function M.start_insert_event(bufnr)
  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    buffer = bufnr,
    command = "startinsert!"
  })
end

---@param bufnr number
---软件窗口大小调整时自适应终端窗口大小
function M.window_resize_event(bufnr)
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = bufnr,
    callback = function(e)
      local winid = vim.fn.bufwinid(e.buf)
      vim.api.nvim_win_set_width(winid, vim.api.nvim_get_option("columns"))
      vim.api.nvim_win_set_height(winid, vim.api.nvim_get_option("lines") - 1)
    end
  })
end

return M
