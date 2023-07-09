return {
	"rebelot/kanagawa.nvim",
	config = function()
		require('kanagawa').setup({
			colors = {
				theme = {
					all = {
						-- 关闭背景颜色
						ui = {
							bg        = "none",
							bg_dim    = "none",
							bg_gutter = "none",
							bg_m3     = "none",
							bg_m2     = "none",
							bg_m1     = "none",
							bg_p1     = "none",
							-- bg_p2     = "none",
							pmenu     = {
								bg       = "none",
								bg_sel   = "none",
								bg_sbar  = "none",
								bg_thumb = "none",
							},
							float     = {
								bg        = "none",
								bg_border = "none",
							},
						},
					}
				}
			}
		})
		vim.cmd("colorscheme kanagawa-dragon")
	end
}
