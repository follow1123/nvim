-- lsp installer 配置
local plugin = {}

--[[
插件初始化
]]
function plugin.init(use)
	use {
		'williamboman/mason.nvim',
		-- setup = beforeLoaded,
		config = afterLoaded,
		run = ':MasonUpdate',
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
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗"
			}
		}
	})
end

return plugin
