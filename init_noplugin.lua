-- #################################################################################
-- #                                                                               #
-- #                                  无插件配置                                   #
-- #                                                                               #
-- #################################################################################

--判断使用为windows
_G.IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1)
-- 判断是否为linux
_G.IS_LINUX = vim.fn.has("unix") == 1
-- 判断是否为gui方式启动
_G.IS_GUI = vim.fn.has("gui_running") == 1

_G.CONFIG_PATH = vim.fn.stdpath("config")

require("no_plugin.ui")
require("no_plugin.options")
require("no_plugin.keymaps")
require("no_plugin.commands")
require("no_plugin.autocmds")
-- 加载自动匹配括号的插件
require("extensions.autopairs").on()
