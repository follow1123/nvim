-- lua 文件单独配置

--[[
在vim内执行lua代码，实现方式默认调用lua命令

单行直接执行
多行每行后面拼接\n后使用 lua << EOF codes EOF格式执行
]]
local function run_lua_code(codes)
  if vim.fn.empty(codes) == 1 then
    vim.notify('no code on cursor', vim.log.levels.WARN)
  elseif type(codes) == "table" then
    vim.cmd("lua << EOF\n" .. table.concat(codes, "\n") .. "\nEOF")
  elseif type(codes) == "string" then
    vim.cmd("lua " .. codes)
  end
end

_G.language.lua = {
  run_code_on_cursor = function ()
    run_lua_code(vim.trim(vim.api.nvim_get_current_line()))
  end,
  run_selected_code = function ()
    _G.util.handle_selected_region_content(function (content)
      run_lua_code(vim.tbl_map(vim.trim, content))
    end)
  end
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function ()
    -- 设置lua文件的tab宽度
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end
})
