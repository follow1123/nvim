-- 主题插件
local plugin = {}

--[[
    插件初始化
]]
function plugin.init(use)
    use { 
        'doums/darcula',
        -- setup = beforeLoaded,
        config = afterLoaded,
    }
end

--[[
    插件加载前
]]
function beforeLoaded()

end

--[[
    插件加载后
]]
function afterLoaded()
    -- 设置默认主题
    vim.api.nvim_command([[colorscheme darcula]])
end

return plugin