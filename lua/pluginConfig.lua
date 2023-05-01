vim.api.nvim_command([[packadd packer.nvim]])

return require('packer').startup(function(use)
  require('plugins.wbthomason_packer').init(use)
  require('plugins.doums_darcula').init(use)
  require('plugins.kyazdani42_nvim-web-devicons').init(use)
  require('plugins.kyazdani42_nvim-tree').init(use)
  require('plugins.numToStr_Comment').init(use)
  require('plugins.akinsho_bufferline_nvim').init(use)
  require('plugins.nvim-lualine_lualine_nvim').init(use)
  require('plugins.norcalli_nvim_colorizer').init(use)
  -- require('plugins.rebelot_kanagawa').init(use)
  -- 启动时间分析
  use { "dstein64/vim-startuptime", cmd = "StartupTime" }
end)
