-- 主题插件
local plugin = {}

--[[
    插件初始化
]]
function plugin.init(use)
    use { 
        'numToStr/Comment.nvim',
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
    require('Comment').setup{
        toggler = {
            -- normal 模式下注释快捷键
            line = '<leader>e',
            ---Block-comment toggle keymap
            -- block = 'gbc',
        },
         opleader = {
            -- visual 模式下注释快捷键
            line = '<leader>e',
            ---Block-comment keymap
            -- block = 'gb',
        },
    }
end

return plugin