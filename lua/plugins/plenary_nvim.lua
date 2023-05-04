-- 搜索依赖插件
local plugin = {}

--[[
    插件初始化
]]
function plugin.init(use)
    use {
        'nvim-lua/plenary.nvim',
        -- setup = beforeLoaded,
        -- config = afterLoaded,
        -- requires = {'nvim-tree/nvim-web-devicons', opt = true}
    }
end

--[[
    插件加载前
]]
function beforeLoaded() end

--[[
    插件加载后
]]
function afterLoaded()
end

return plugin
