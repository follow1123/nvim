-- ###########################
-- #        command定义      #
-- ###########################

-- 打开设置
vim.cmd("command! Setting :e " .. _G.CONFIG_PATH .. "/init.lua")

-- 格式化
vim.cmd("command! Format lua vim.lsp.buf.format()")

-- 打开终端
if _G.IS_WINDOWS then
  vim.cmd("command! TermOpen term pwsh")
else
  vim.cmd("command! TermOpen term zsh")
end


