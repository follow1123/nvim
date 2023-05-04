vim.api.nvim_command([[packadd packer.nvim]])

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup({
	function(use)
		require('plugins.wbthomason_packer').init(use)
		require('plugins.doums_darcula').init(use)
		require('plugins.kyazdani42_nvim-web-devicons').init(use)
		require('plugins.kyazdani42_nvim-tree').init(use)
		require('plugins.numToStr_Comment').init(use)
		require('plugins.akinsho_bufferline_nvim').init(use)
		require('plugins.nvim-lualine_lualine_nvim').init(use)
		require('plugins.norcalli_nvim_colorizer').init(use)
		require('plugins.nvim_treesitter').init(use)
		require('plugins.plenary_nvim').init(use)
		require('plugins.nvim_telescope').init(use)
		require('plugins.lsp').init(use)
		-- 启动时间分析
		use { "dstein64/vim-startuptime", cmd = "StartupTime" }
		-- 启动自动同步插件
		if packer_bootstrap then
			require('packer').sync()
		end
	end,
	config = {
		-- max_jobs = 16,
		display = {
			open_fn = function()
				return require('packer.util').float({ border = 'single' })
			end
		}
	}
})
