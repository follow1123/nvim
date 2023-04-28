-- 状态栏插件
local plugin = {}

--[[
    插件初始化
]]
function plugin.init(use)
    use {
        'nvim-lualine/lualine.nvim',
        -- setup = beforeLoaded,
        config = afterLoaded,
        requires = {'nvim-tree/nvim-web-devicons', opt = true}
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
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = {left = '', right = ''},
            section_separators = {left = '', right = ''},
            disabled_filetypes = {statusline = {}, winbar = {}},
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {statusline = 1000, tabline = 1000, winbar = 1000}
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
end

return plugin
