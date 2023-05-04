-- 工作区标签插件
return {
	'akinsho/bufferline.nvim',
	dependencies = {{
        'kyazdani42/nvim-web-devicons',
    }},
	config = function()
		require("bufferline").setup {
			options = {
				mode = "buffers",
				numbers = "ordinal",
				-- 左侧让出 nvim-tree 的位置
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
}
