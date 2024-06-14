---@class Comment
---@field start string
---@field close string?
---@field match_start string?
---@field match_close string?

---@class CommentExt
---@field toggle_comment_line function
local M = {}

---@type table<string, Comment>
local comments = {
  dash = { start = "--", match_start = "%-%-" },
  rem = { start = "REM" },
  slash = { start = "//" },
  hash = { start = "#" },
  lisp = { start = ";;" },
  html = {
    start = "<!--", close = "-->",
    match_start = "<%!%-%-", match_close = "%-%->"
  }
}

---@type table<string, Comment>
local fts = {
  lua = comments.dash,
  dosbatch = comments.rem,
  c = comments.slash,
  rust = comments.slash,
  ps1 = comments.hash,
  conf = comments.hash,
  xml = comments.html,
  lisp = comments.lisp,
  json = comments.slash,
  markdown = comments.html
}

---@param text string
---@param pattern string
---@return integer index start index
---@return integer index end index
local function locate_pos(text, pattern)
  local start_idx, end_idx = string.find(text, pattern)
  local err_msg = string.format("not fond `%s` in `%s`", pattern, text)
  assert(start_idx, err_msg)
  assert(end_idx, err_msg)
  return start_idx, end_idx
end

---@param start_line integer
---@param end_line integer
---@param start_col integer
---@param end_col integer
---@param text string
local function insert_text(start_line, end_line, start_col, end_col, text)
  start_line = start_line > 0 and start_line - 1 or start_line
  end_line = end_line > 0 and end_line - 1 or end_line
  start_col = start_col > 0 and start_col - 1 or start_col
  end_col = end_col > 0 and end_col - 1 or end_col
  vim.api.nvim_buf_set_text(
    0, start_line, start_col, end_line, end_col, { text })
end

---@param line_num integer
---@param start_col integer
---@param end_col integer
---@return string
local function get_text(line_num, start_col, end_col)
  line_num = line_num > 0 and line_num - 1 or line_num
  start_col = start_col > 0 and start_col - 1 or start_col
  end_col = end_col > 0 and end_col - 1 or end_col
  return vim.api.nvim_buf_get_text(
    0, line_num, start_col, line_num, end_col, {})[1]
end

---@param comment Comment
---@param line_num integer
---@param text string
local function comment_line(comment, line_num, text)
  local start_idx = 0
  local end_idx = 0
  if vim.fn.empty(text) ~= 1 then
    start_idx, end_idx = locate_pos(text, "%S")
  end
  insert_text(line_num, line_num, start_idx, end_idx, comment.start .. " ")
end

---@param comment Comment
---@param line_num integer
---@param text string
local function uncomment_line(comment, line_num, text)
  local start_idx, _ = locate_pos(text, comment.match_start or comment.start)
  insert_text(
    line_num, line_num, start_idx, start_idx + #comment.start + 1, "")
end

---@param comment Comment
---@param text string
local function is_line_commented(comment, text)
  local comment_str = comment.match_start or comment.start
  return string.match(vim.trim(text), "^" .. comment_str) ~= nil
end

---@param comment Comment
---@param line_num integer
---@param text string
local function toggle_comment_line(comment, line_num, text)
  if is_line_commented(comment, text) then
    uncomment_line(comment, line_num, text)
  else
    comment_line(comment, line_num, text)
  end
end

---@return Comment
local function get_ft_comment()
  local ft = vim.bo.filetype
  local comment = fts[ft]
  assert(comment,
    string.format("filetype: `%s` not implement comment", ft))
  return comment
end

---@param comment Comment
---@param start_line integer
---@param end_line integer
local function toggle_comment_lines(comment, start_line, end_line)
  local line_info = {}
  local comment_indent_idx

  local need_comment = false

  for i = start_line, end_line , 1 do
    local text = vim.fn.getline(i)
    if vim.fn.empty(text) == 1 then
      goto continue
    end

    local line = { line_num = i, text = text }
    need_comment = need_comment and need_comment or not is_line_commented(comment, text)

    table.insert(line_info, line)
    local start_idx, _ = locate_pos(text, "%S")
    if comment_indent_idx == nil or start_idx < comment_indent_idx then
      comment_indent_idx = start_idx
    end
    ::continue::
  end

  local function action(_, line_num, _)
     insert_text(
        line_num, line_num, comment_indent_idx,
        comment_indent_idx, comment.start .. " ")
  end

  action = need_comment and action or uncomment_line

  for _, line in ipairs(line_info) do
    action(comment, line.line_num, line.text)
  end
end

---@param comment Comment
---@param start_line integer
---@param end_line integer
---@param start_col integer
---@param end_col integer
local function comment_bracket(
  comment, start_line, end_line, start_col, end_col)

  insert_text(
    start_line, start_line, start_col, start_col, comment.start .. " ")

  if start_line == end_line then
    end_col = end_col + #comment.start + 1
  end

  insert_text(end_line, end_line, end_col, end_col, " " .. comment.close)
end

---@param comment Comment
---@param start_line integer
---@param end_line integer
---@param start_col integer
---@param end_col integer
local function uncomment_bracket(
  comment, start_line, end_line, start_col, end_col)

  if start_col == 0 then
    start_col = start_col + 1
  end

  insert_text(
    start_line, start_line, start_col, start_col + #comment.start + 1, "")

  if start_line == end_line then
    end_col = end_col - #comment.start - 1
  end

  insert_text(end_line, end_line, end_col - #comment.close - 1, end_col, "")
end

---@param comment Comment
---@param start_line integer
---@param end_line integer
---@param start_col integer
---@param end_col integer
local function is_bracket_commented(
  comment, start_line, end_line, start_col, end_col)

  assert(
    comment.start and comment.close,
    string.format(
      "Invalid comment: start: `%s`, close, `%s`",
      comment.start, comment.close
    )
  )

  local start_text = get_text(
    start_line, start_col, #vim.fn.getline(start_line))

  local is_comment_start = string.match(
    vim.trim(start_text), "^" .. (comment.match_start or comment.start)) ~= nil

  local end_text = get_text(end_line, 0, end_col)
  local is_comment_close = string.match(
    vim.trim(end_text), (comment.match_close or comment.close) .. "$") ~= nil

  return is_comment_start and is_comment_close
end

---@param comment Comment
---@param start_line integer
---@param end_line integer
---@param start_col integer
---@param end_col integer
local function toggle_bracket_comment(
  comment, start_line, end_line, start_col, end_col)
  if is_bracket_commented(
    comment, start_line, end_line, start_col, end_col) then

    uncomment_bracket(comment, start_line, end_line, start_col, end_col)
  else
    comment_bracket(comment, start_line, end_line, start_col, end_col)
  end
end

function M.toggle_comment_line()
  local comment = get_ft_comment()
  local line_num = vim.fn.line(".")
  local start_col = 0
  local end_col = vim.fn.col("$")
  local text = get_text(line_num, start_col, end_col)

  if comment.close then
    toggle_bracket_comment(comment, line_num, line_num, start_col, end_col)
    return
  end

  toggle_comment_line(comment, line_num, text)
end

function M.toggle_comment_visual_mode()
  local comment = get_ft_comment()

  vim.api.nvim_input("<Esc>")

  vim.schedule(function ()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local start_col = vim.fn.col("'<")
    local end_col = vim.fn.col("'>")

    if comment.close then
      toggle_bracket_comment(comment, start_line, end_line, start_col, end_col)
      return
    end

    toggle_comment_lines(comment, start_line, end_line)

  end)
end

return M
