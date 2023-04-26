-- 文件树插件

local plugin = {}

--[[
    插件初始化
]]
function plugin.init(use)
    use { 
        'kyazdani42/nvim-tree.lua',
        setup = beforeLoaded,
        config = afterLoaded,
    }
end

--[[
    插件加载前
]]
function beforeLoaded()
    -- 默认打开文件树快捷键
    local u = require('util')
    u.m('n', '<leader>1', ':NvimTreeToggle<CR>', {noremap = true})
end

--[[
    插件加载后
]]
function afterLoaded()
    require("nvim-tree").setup{
        -- auto_close = true,
        -- 不显示 git 状态图标
        git = {
            enable = false
        }
    }
end

return plugin