-- 颜色插件
return {
	"norcalli/nvim-colorizer.lua",
	event = "VeryLazy",
	config = function()
		require("colorizer").setup {
			"*"; -- Highlight all files, but customize some others.
			-- "!vim"; -- Exclude vim from highlighting.
			-- Exclusion Only makes sense if "*" is specified!
		}
	end
}
