-- 工作区标签插件
local plugin = {}

--[[
    插件初始化
]]
function plugin.init(use)
    use {
        'akinsho/bufferline.nvim',
        -- setup = beforeLoaded,
        config = afterLoaded,
        tag = "*",
        requires = 'kyazdani42/nvim-web-devicons'
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
	-- 设置默认主题
	-- vim.api.nvim_command([[colorscheme darcula]])
	require("bufferline").setup {
		options = {
			mode = "buffers",
			numbers = "ordinal",
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "left"
				}
			}
		}
	}
end

return plugin
