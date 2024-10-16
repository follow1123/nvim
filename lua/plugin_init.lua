local colors = require("utils.colors")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    import = "plugins"
  },
  ui = {
    border = "single"
  },
  change_detection = {
    notify = false,
  },
})
vim.api.nvim_set_hl(0, "LazyProp", { bg = colors.gray_04 })
require("utils.keymap").nmap("<leader>1", "<cmd>Lazy<cr>", "Open Lazy Manager panel")
