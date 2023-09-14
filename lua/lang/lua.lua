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

local keymap_utils = require("utils.keymap")
local nmap = keymap_utils.nmap
local vmap = keymap_utils.vmap

nmap("<M-r>", function () run_lua_code(vim.trim(vim.api.nvim_get_current_line())) end, "lua_dev: Run code on cursor")

vmap("<M-r>", function ()
  require("utils") .handle_selected_region_content(function (content)
    run_lua_code(vim.tbl_map(vim.trim, content))
  end)
end, "lua_dev: Run code on cursor")
