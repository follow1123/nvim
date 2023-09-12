-- ui相关插件
return {
  { -- 主题
    "LunarVim/Colorschemes",
    priority = 999,
    config = function()
      vim.cmd("colorscheme darkplus")

      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e1e" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#323232" })
      -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#569cd6", bg = "#1e1e1e" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e" })

      -- 光标在括号上时高亮另一对括号
      vim.api.nvim_set_hl(0, "MatchParen", {
        bg = "NONE",
        fg = "Yellow",
        sp = "Yellow",
        underline = true,
        bold = true,
        italic = true,
      })

    end
  },
  { -- 状态栏插件
    "nvim-lualine/lualine.nvim",
    priority = 998,
    dependencies = {"kyazdani42/nvim-web-devicons", opt = true},
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = {left = "", right = ""},
          section_separators = {left = "", right = ""},
          disabled_filetypes = {statusline = {}, winbar = {}},
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {statusline = 1000, tabline = 1000, winbar = 1000}
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {"diff", "diagnostics"},
          lualine_c = {
            "filetype",
            -- 设置文件绝对路径，并缩短路径显示
            { "filename", path = 3, shorting_target = 100 },
          },
          lualine_x = { {
            "branch",
            icon = { "", color = {fg = "#f44d27"}}
          }, "encoding" },
          lualine_y = {"progress"},
          lualine_z = {"location"}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {"filename"},
          lualine_x = {"location"},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },
  { -- 图标
      "kyazdani42/nvim-web-devicons",
      module = true,
      config = function()
          require("nvim-web-devicons").setup {
              override = {
                  zsh = {
                      icon = "",
                      color = "#428850",
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
                      color = "#f1502f",
                      name = "Gitignore"
                  }
              },
              override_by_extension = {
                  ["log"] = {icon = "", color = "#81e043", name = "Log"}
              }
          }
      end
  },
  { -- 缩进线
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.opt.list = true
      -- vim.opt.listchars:append "space:⋅"
      vim.opt.listchars:append "eol:↴"
      vim.opt.listchars:append "trail: "
      require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      }

      vim.api.nvim_set_hl(0, "IndentBlanklineChar", {fg = "#282828", bg = ""})
      vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", {fg = "#707070", bg = ""})
      vim.api.nvim_set_hl(0, "IndentBlanklineContextStart", {fg = "", bg = "", underline = true, sp = "#707070"})

      vim.api.nvim_set_hl(0, "NonText", { fg = "#3e3e3e"})
    end
  },
  { -- 颜色显示
    "norcalli/nvim-colorizer.lua",
    event = "InsertEnter",
    config = function()
      require("colorizer").setup { "*" }
    end
  }
}
