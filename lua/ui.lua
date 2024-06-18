--#############################################################################
--#                                                                           #
--#                                 主题配置                                  #
--#                                                                           #
--#############################################################################

local colors = require("utils.colors")

vim.cmd.colorscheme("habamax") -- 主题

vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" }) -- 弹框边框颜色
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })

vim.api.nvim_set_hl(0, "Visual", { fg = "NONE", bg = colors.gray_02 }) -- visual模式选中文本的颜色
vim.api.nvim_set_hl(0, "ModeMsg", { fg = colors.white_02 , bold = true }) -- 切换模式时左下角显示的颜色
vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" }) -- 垂直分屏时分割线的背景颜色

-- 光标在括号上时高亮另一对括号
vim.api.nvim_set_hl(0, "MatchParen", {
  bg = "NONE",
  fg = colors.yellow_01,
  sp = colors.yellow_01,
  underline = true,
  bold = true,
})

-- 补全相关颜色
vim.api.nvim_set_hl(0, "PmenuSel", { fg = "NONE", bg = colors.gray_02 }) -- 选择栏颜色
vim.api.nvim_set_hl(0, "PmenuSBar", { link = "Pmenu"}) -- 选择滚动条颜色

-- diff设置
vim.api.nvim_set_hl(0, "DiffAdd", { fg = "NONE", bg = colors.green_03 })
vim.api.nvim_set_hl(0, "DiffChange", { fg = "NONE", bg = colors.blue_03 })
vim.api.nvim_set_hl(0, "DiffDelete", { fg = "NONE", bg = colors.red_03 })
vim.api.nvim_set_hl(0, "DiffText", { fg = "NONE", bg = colors.green_03})
