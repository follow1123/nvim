-- ui相关插件
return {
  { -- 颜色显示
    "norcalli/nvim-colorizer.lua",
    keys = {
      lazy_map("n", "<leader>4", "<cmd>ColorizerToggle<cr>", "Colorizer: Display colors"),
    },
    config = function()
      require("colorizer").setup { "*" }
    end
  }
}
