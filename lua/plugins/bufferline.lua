-- 工作区标签插件
return {
	"akinsho/bufferline.nvim",
	-- event = "VeryLazy",
	dependencies = {{
		"kyazdani42/nvim-web-devicons",
	}},
	config = function()
		require("utils")
		-- Alt+q关闭当前buffer
		.n("<A-q>", ":bdelete!<CR>")
		-- Ctrl+l下一个buffer
		.n("<C-l>", ":BufferLineCycleNext<CR>")
		-- Ctrl+h上一个buffer
		.n("<C-h>", ":BufferLineCyclePrev<CR>")
		require("bufferline").setup {
			options = {
				mode = "buffers",
				numbers = "none",
				-- tab显示lsp相关信息
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = true,
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or (level:match("warn") and "" or "")
					return icon
				end,
				-- 选中buffer样式
				indicator = {
					icon = "▎", -- this should be omitted if indicator style is not "icon"
					style = "underline"
				},
				-- numbers = "ordinal",
				-- 左侧让出 nvim-tree 的位置
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
					}
				},
			}
		}
	end
}
