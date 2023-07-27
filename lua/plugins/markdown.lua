-- markdown 预览插件
return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	-- event = "VeryLazy",
	-- ft = "md",
	config = function()
		local o = require("options")
		vim.g.mkdp_browser = "surf"
		if o.is_windows() then
			vim.g.mkdp_browser = "firefox"
		end
		vim.g.mkdp_filetypes = { "markdown" }
	end
}
