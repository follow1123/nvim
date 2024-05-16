local keymap_uitl = require("utils.keymap")
local lazy_map = keymap_uitl.lazy_map
local colors = require("utils.colors")
-- ui相关插件
return {
  { -- 图标
    "kyazdani42/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup {
        override = {
          zsh = {
            icon = "",
            color = colors.green_04,
            cterm_color = "65",
            name = "Zsh"
          }
        },
        color_icons = true,
        default = true,
        strict = true,
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = colors.red_04,
            name = "Gitignore"
          }
        },
        override_by_extension = {
          ["log"] = {icon = "", color = colors.green_05, name = "Log"}
        }
      }
    end
  },
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
