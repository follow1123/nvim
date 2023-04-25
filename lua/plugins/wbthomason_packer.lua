-- packer 管理插件
local plugin = {}

--[[
    插件初始化
]]
function plugin.init(use)
    use { 
        'wbthomason/packer.nvim',
        -- setup = beforeLoaded,
        -- config = afterLoaded,
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

end

return plugin