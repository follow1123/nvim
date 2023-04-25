local util = {}

--[[
    封装按键映射方法
]]
function util.m(mode, key, repKey, type)
    vim.api.nvim_set_keymap(mode, key, repKey, type)
end

return util
