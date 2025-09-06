return {
  "ThePrimeagen/harpoon",
  keys = {
    { "<leader>fa", "<cmd>lua require('harpoon'):list():add()<cr>",                                    desc = "harpoon: Add file to harpoon list" },
    { "<leader>fl", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", desc = "harpoon: Toggle harpoon list" },
    { "<M-j>",      "<cmd>lua require('harpoon'):list():select(1)<cr>",                                desc = "harpoon: Goto next first file in harpoon list" },
    { "<M-k>",      "<cmd>lua require('harpoon'):list():select(2)<cr>",                                desc = "harpoon: Goto next second in harpoon list" },
    { "<M-l>",      "<cmd>lua require('harpoon'):list():select(3)<cr>",                                desc = "harpoon: Goto next third in harpoon list" },
    { "<M-;>",      "<cmd>lua require('harpoon'):list():select(4)<cr>",                                desc = "harpoon: Goto next fourth in harpoon list" },
  },
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
}
