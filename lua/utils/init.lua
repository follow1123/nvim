local M = {}

-- 在visual模式选中文本后获取对应选中的区域处理
function M.handle_selected_region_content(callback)
  vim.api.nvim_input("<Esc>")
  vim.schedule(function ()
    -- 获取visual模式选择的行和列信息
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local start_col = vim.fn.col("'<")
    local end_col = vim.fn.col("'>")
    local region_contents = {}
    -- 获取选择的所有行
    local selected_lines = vim.fn.getline(start_line, end_line)
    -- 根据起始列和结束列位置截取第一行和最后一行
    for i, v in ipairs(selected_lines) do
      local line = v
      if i == 1 then line = string.sub(line, start_col) end
      if i == vim.tbl_count(selected_lines) then line = string.sub(line, 1, (start_line == end_line and end_col - start_col + 1 or end_col)) end
      table.insert(region_contents, i, line)
    end
    -- 获取选择的区域后执行回调方法
    if type(callback) == "function" then
      callback(region_contents)
    end
  end)
end

-- 监听下一个输入的字符
function M.handle_input_char(callback)
  vim.schedule(function ()
    if type(callback) == "function" then
      callback(vim.fn.nr2char(vim.fn.getchar()))
    end
  end)
end

return M
