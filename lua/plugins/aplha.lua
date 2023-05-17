-- 起始页插件
return {
	'goolord/alpha-nvim',
	-- enabled = false,
	-- event = "VeryLazy",
	dependencies = {'kyazdani42/nvim-web-devicons'},
	config = function()
		 require('alpha')
		 	.setup(require('alpha.themes.startify').config)
		 	-- .setup(require('alpha.themes.dashboard').config)
	end
}
