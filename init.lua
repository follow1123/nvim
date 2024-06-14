--判断使用为windows
_G.IS_WINDOWS = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1)
-- 判断是否为linux
_G.IS_LINUX = not _G.IS_WINDOWS
-- 判断是否为gui方式启动
_G.IS_GUI = vim.fn.has("gui_running") == 1
-- nvim配置文件路径
_G.CONFIG_PATH = vim.fn.stdpath("config")

require("ui")
-- 禁用lsp的高亮
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

-- if not _G.IS_GUI then
--   vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
--   vim.api.nvim_set_hl(0, "CursorLine", { link = "Visual" })
-- end

require("options")
vim.opt.shortmess:append({I = true}) -- 关闭intro
vim.wo.signcolumn = "yes"            -- 显示左侧图标指示列

require("keymaps")
require("commands")
require("autocmds")

require("plugin_init")

-- require("extensions.pairs").setup()
