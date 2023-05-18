-- 起始页插件
return {
	'goolord/alpha-nvim',
	-- enabled = false,
	-- event = "VeryLazy",
	dependencies = {'kyazdani42/nvim-web-devicons'},
	config = function()
		local dashboard = require('alpha.themes.dashboard')
		dashboard.section.buttons.val = {
			dashboard.button("1", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("2", "  Find file", ":Telescope find_files <CR>"),
			dashboard.button("3", "  Recently used files", ":Telescope oldfiles <CR>"),
			dashboard.button("4", "  Find text", ":Telescope live_grep <CR>"),
			dashboard.button("5", "  Find project", ":Telescope projects <CR>"),
			dashboard.button("s", "  Configuration", ":e ~/AppData/Local/nvim/init.lua <CR>"),
			dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
		}
		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"

		dashboard.opts.opts.noautocmd = true
		-- .setup(require('alpha.themes.startify').config)
		require('alpha')
		.setup(dashboard.opts)
	end
}
