local lazy_map = require("utils.keymap").lazy_map
return {
  "ThePrimeagen/harpoon",
  keys = {
    lazy_map("n", "<leader>fa", "<cmd>lua require('harpoon'):list():add()<cr>", "harpoon: Add file to harpoon list"),
    lazy_map("n", "<leader>fl", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", "harpoon: Toggle harpoon list"),
    lazy_map("n", "<M-j>", "<cmd>lua require('harpoon'):list():select(1)<cr>", "harpoon: Goto next first file in harpoon list"),
    lazy_map("n", "<M-k>", "<cmd>lua require('harpoon'):list():select(2)<cr>", "harpoon: Goto next second in harpoon list"),
    lazy_map("n", "<M-l>", "<cmd>lua require('harpoon'):list():select(3)<cr>", "harpoon: Goto next third in harpoon list"),
    lazy_map("n", "<M-;>", "<cmd>lua require('harpoon'):list():select(4)<cr>", "harpoon: Goto next fourth in harpoon list"),
  },
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon"):setup()
  end
}

