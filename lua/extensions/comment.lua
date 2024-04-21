-- ###########################
-- #         注释插件        #
-- ###########################
local M = {}

-- 注释字符串
local comments = {
  minus = "--",
  rem = "REM",
  slash = "//",
  hash = "#"
}

-- 文件类型注释map
local ft_comments = {
  lua = comments.minus,
  dosbatch = comments.rem,
  c = comments.slash,
  rust = comments.slash,
  ps1 = comments.hash,
  conf = comments.hash,
}

-- 判断是否被注释
local function is_commented(line, filetype)
  local pattern = ft_comments[filetype]
  if pattern then
    if filetype == "lua" then
      pattern = "%-%-"
    end
    return string.match(vim.trim(line), "^" .. pattern) and 1 or 2
  end
  return 0
end

-- 注释操作
function M.comment(line_num, line, filetype)
  local comment_str = ft_comments[filetype]
  local first_char_index = string.find(line, "%S")
  if first_char_index then
    local prev_str = string.sub(line, 1, first_char_index - 1)
    local next_str = string.sub(line, first_char_index, #line)
    local commented_line = prev_str .. comment_str .. " " .. next_str
    vim.fn.setline(line_num, commented_line)
  end
end

-- 取消注释操作
function M.uncomment(line_num, line, filetype)
  local comment_str = ft_comments[filetype]
  local first_char_index = string.find(line, "%S")
  if comment_str then
    local comment_len = #comment_str + 1
    if first_char_index then
      local prev_str = string.sub(line, 1, first_char_index - 1)
      local next_str = string.sub(line, first_char_index, #line)
      local uncomment_line = vim.trim(string.sub(next_str, comment_len, #line))
      uncomment_line = prev_str .. vim.trim(uncomment_line)
      vim.fn.setline(line_num, uncomment_line)
    end
  end
end

-- 切换注释和取消注释操作
function M.toggle()
  local line_num = vim.fn.line(".")
  local line = vim.api.nvim_get_current_line()
  local filetype = vim.o.filetype
  local status = is_commented(line, filetype)
  if status == 1 then
    M.uncomment(line_num, line, filetype)
  elseif status == 2 then
    M.comment(line_num, line, filetype)
  end
end

-- visual切换注释和取消注释操作
function M.visual_toggle()
  vim.api.nvim_input("<esc>")
  vim.schedule(function ()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local selected_lines = vim.fn.getline(start_line, end_line)
    local filetype = vim.o.filetype
    local selected_index = 1
    for line_num = start_line, end_line do
      local line = selected_lines[selected_index]
      local status = is_commented(line, filetype)
      if status == 1 then
        M.uncomment(line_num, line, filetype)
      elseif status == 2 then
        M.comment(line_num, line, filetype)
      end
      selected_index = selected_index + 1
    end
  end)
end

return M
