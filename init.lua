--判断使用为windows
IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and true or false
-- 判断是否为linux
IS_LINUX = vim.fn.has("unix") == 1 and true or false
-- 判断是否为gui方式启动
IS_GUI = vim.fn.has("gui_running") == 1 and true or false

require("funcs")
require("nvim_base")
require("plugin_init")
require("autocmd")
