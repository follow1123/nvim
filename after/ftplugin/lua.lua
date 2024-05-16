vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

vim.keymap.set("n", "<M-r>", "<cmd>lua require('utils.lang.lua').run_code()<cr>", {
  desc = "lua: execute code",
  buffer = true
})

vim.keymap.set("v", "<M-r>", "<cmd>lua require('utils.lang.lua').run_selected_code()<cr>", {
  desc = "lua: execute selected code",
  buffer = true
})
