vim.api.nvim_command([[packadd packer.nvim]])

return require('packer').startup(function(use)
  require('plugins.wbthomason_packer').init(use)
  require('plugins.doums_darcula').init(use)
end)
