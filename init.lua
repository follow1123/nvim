--判断使用为windows
_G.IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and true or false
-- 判断是否为linux
_G.IS_LINUX = vim.fn.has("unix") == 1 and true or false
-- 判断是否为gui方式启动
_G.IS_GUI = vim.fn.has("gui_running") == 1 and true or false

_G.CONFIG_PATH = vim.fn.stdpath("config")

_G.language = { }

_G.util = {
  -- 在visual模式选中文本后获取对应选中的区域处理
  handle_selected_region_content = function(callback)
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
}

require("funcs")
require("nvim_base")
require("plugin_init")
require("autocmd")

-- 加载语言单独的设置 在lua/lang的language.lua
local dir_handler = vim.fs.dir(_G.CONFIG_PATH .. "/lua/lang")
for file, file_type in dir_handler do
	if file_type == "file" then
		require("lang." .. file:match("^(.*)%..*$"))
	end
end
