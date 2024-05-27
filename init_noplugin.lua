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

require("ui")
require("options")
vim.opt.pumheight = 15      -- 补全弹窗最大补全个数
vim.opt.path:append("**/*") -- 添加find查找所有子目录路径
vim.opt.wildmenu = true     -- 搜索显示补全
require("keymaps")
require("commands")
require("autocmds")

require("extensions.pairs").setup()
