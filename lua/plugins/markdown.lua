-- markdown 预览插件
return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	event = "VeryLazy",
	-- ft = "md",
	config = function()
		vim.g.mkdp_browser = "firefox"
		vim.g.mkdp_filetypes = { "markdown" }
	end
}
