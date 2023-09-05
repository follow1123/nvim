--判断使用为windows
_G.IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and true or false
-- 判断是否为linux
_G.IS_LINUX = vim.fn.has("unix") == 1 and true or false
-- 判断是否为gui方式启动
_G.IS_GUI = vim.fn.has("gui_running") == 1 and true or false

_G.CONFIG_PATH = vim.fn.stdpath("config")

_G.LANGUAGE = { }

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
