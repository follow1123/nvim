-- ###########################
-- #        自动括号插件     #
-- ###########################
local autopairs = {}

-- 自动配对的符号
autopairs.symbols = {
  ["{"] = "}",
  ["["] = "]",
  ["("] = ")",
  ["\""] = "\"",
  ["'"] = "'",
}

-- 自动配对的符号前缀
autopairs.symbols_keys = vim.tbl_keys(autopairs.symbols)

-- 匹配符号后面是否已经有配对的符号
local function match_pairs(str, pairs)
  local pattern = pairs
  if pairs == ")" then
    pattern = "%)"
  end
  return string.match(str, "^" .. pattern)
end

-- 处理自动配置符号操作
local function handle_char(input_char)
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.fn.col(".") - 1
  local prev_str = string.sub(line, 1, cursor_col)
  local next_str = string.sub(line, cursor_col + 1, #line)
  local pairs = autopairs.symbols[input_char]
  -- 如果符号后面没有字符串，或者后面字符串是另一半符号则进行自动配对，否则不配对
  if #next_str == 0 or match_pairs(next_str, pairs) then
    vim.api.nvim_set_current_line(prev_str .. pairs .. next_str)
  end
end


-- 开启自动配置功能
autopairs.on = function()
  autopairs.autocmd_id = vim.api.nvim_create_autocmd("InsertCharPre", {
    pattern = "*",
    callback = function ()
      local input_char = vim.v.char
      if input_char and vim.tbl_contains(autopairs.symbols_keys, input_char) then
        vim.schedule_wrap(handle_char)(input_char)
      end
    end
  })
end

-- 关闭自动配置功能
autopairs.off = function ()
  if autopairs.autocmd_id then
    vim.api.nvim_del_autocmd(autopairs.autocmd_id)
    autopairs.autocmd_id = nil
  end
end


-- 开启或关闭自动配置功能
autopairs.toggle = function ()
  if autopairs.autocmd_id then
    autopairs.off()
  else
    autopairs.on()
  end
end

return autopairs
