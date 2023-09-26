local term_utils = {}

local function global_height()
  return vim.api.nvim_get_option("lines")
end

local function global_width()
  return vim.api.nvim_get_option("columns")
end

local full_window_opts = {
  relative = "editor",
  width = global_width(),
  height = global_height() - 1,
  row = 0,
  col = 0,
  style = "minimal",
  border = "none",
}

term_utils.open_full_window = function(enter, bufnr)
  return vim.api.nvim_open_win(bufnr, enter, full_window_opts)
end

term_utils.create_term_buf = function()
  local term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
  vim.api.nvim_buf_set_option(term_buf, "filetype", "fterm")
  return term_buf
end

-- 打开终端
term_utils.term_open = function(term, cmd, open, exit)
  local bufnr, win_id
  if type(open) == "function" then
    bufnr, win_id = open(term)
  else
    bufnr = term_utils.create_term_buf()
    win_id = term_utils.open_full_window(true, bufnr)
  end
  local term_id = vim.fn.termopen(cmd, {
    detach = 1,
    on_exit = function(_, code)
      if type(exit) == "function" then
        exit(term, code)
        return
      end
      vim.api.nvim_buf_delete(term.instance.bufnr, { force = true })
      term.instance = nil
    end
  })
  term.instance = {
    bufnr = bufnr,
    term_id = term_id,
    win_id = win_id,
  }
  if term.full_window then
    vim.api.nvim_create_autocmd("WinLeave", {
      buffer = bufnr,
      callback = function(e)
        -- 终端窗口失去焦点时直接切换回来
        local term_win_id = vim.fn.bufwinid(e.buf)
        vim.schedule(function()
          if term_win_id > 0 and term_win_id ~= vim.api.nvim_get_current_win() then
            vim.fn.win_gotoid(term_win_id)
          end
        end)
      end
    })
  end
  return term.instance
end

-- 显示隐藏终端
term_utils.term_toggle = function(term, show, hide)
  local instance = term.instance
  -- 不存在buffer则直接打开
  if not instance or #vim.fn.getbufinfo(instance.bufnr) == 0 then
    term.open()
    return
  end
  -- 当前buffer不是term buffer则切换到term buffer
  if vim.api.nvim_get_current_buf() == instance.bufnr then
    if type(hide) == "function" then
      hide(instance)
    else
      vim.api.nvim_win_close(instance.win_id, true)
    end
  else
    if type(show) == "function" then
      show(instance)
    else
      instance.win_id = term_utils.open_full_window(true, instance.bufnr)
      vim.cmd("normal ^")
    end
  end
end

return term_utils
