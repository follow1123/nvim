-- 颜色插件
local plugin = {}

--[[
    插件初始化
]] 
function plugin.init(use)
    use {
        'norcalli/nvim-colorizer.lua',
        -- setup = beforeLoaded,
        config = afterLoaded
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
	require('colorizer').setup {
	  '*'; -- Highlight all files, but customize some others.
	  -- '!vim'; -- Exclude vim from highlighting.
	  -- Exclusion Only makes sense if '*' is specified!
	}
end

return plugin
