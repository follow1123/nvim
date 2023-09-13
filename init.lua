--判断使用为windows
_G.IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and true or false
-- 判断是否为linux
_G.IS_LINUX = not _G.IS_WINDOWS
-- 判断是否为gui方式启动
_G.IS_GUI = vim.fn.has("gui_running") == 1 and true or false
-- nvim配置文件路径
_G.CONFIG_PATH = vim.fn.stdpath("config")

require("options")
require("keymaps")
require("commands")
require("autocmds")
require("plugin_init")
