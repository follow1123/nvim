vim.api.nvim_command([[packadd packer.nvim]])

return require('packer').startup(function(use)
  require('plugins.wbthomason_packer').init(use)
  require('plugins.doums_darcula').init(use)
  require('plugins.kyazdani42_nvim-tree').init(use)
  require('plugins.numToStr_Comment').init(use)
end)
