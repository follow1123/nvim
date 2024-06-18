local M = {}

---执行当前行的代码
function M.run_code()
  local line = vim.trim(vim.api.nvim_get_current_line())
  if #line == 0 then
    return
  end
  vim.cmd.lua(line)
end

---执行所有选中行的代码
function M.run_selected_code()
  require("utils").handle_selected_region_content(function(content)
    vim.cmd(string.format("lua << EOF\n%s\nEOF", table.concat(content, "\n")))
  end)
end

return M
