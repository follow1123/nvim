-- ui相关插件
return {
  { -- 主题
    "LunarVim/Colorschemes",
    config = function()
      vim.cmd("colorscheme darkplus")
    end
  },
  { -- 状态栏插件
    "nvim-lualine/lualine.nvim",
    dependencies = {"kyazdani42/nvim-web-devicons", opt = true},
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = {left = "|", right = "|"},
          section_separators = {left = "", right = ""},
          disabled_filetypes = {statusline = {}, winbar = {}},
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {statusline = 1000, tabline = 1000, winbar = 1000}
        },
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"branch", "diff", "diagnostics"},
          lualine_c = {"filename"},
          lualine_x = {"encoding", "fileformat", "filetype"},
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
  { -- bufferline
    "akinsho/bufferline.nvim",
    event = "UIEnter",
    config = function ()
      require("bufferline").setup{
        options = {
          middle_mouse_command = "bdelete! %d",
          show_buffer_close_icons = false,
          separator_style = "thin",
          indicator = {
            icon = ' ',
            style = 'icon',
          },
          offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center",
                separator = true
              }
          },

        }
      }
    end
  },
  { -- 图标
      "kyazdani42/nvim-web-devicons",
      config = function()
          require"nvim-web-devicons".setup {
              -- your personnal icons can go here (to override)
              -- you can specify color or cterm_color instead of specifying both of them
              -- DevIcon will be appended to `name`
              override = {
                  zsh = {
                      icon = "",
                      color = "#428850",
                      cterm_color = "65",
                      name = "Zsh"
                  }
              },
              -- globally enable different highlight colors per icon (default to true)
              -- if set to false all icons will have the default icon"s color
              color_icons = true,
              -- globally enable default icons (default to false)
              -- will get overriden by `get_icons` option
              default = true,
              -- globally enable "strict" selection of icons - icon will be looked up in
              -- different tables, first by filename, and if not found by extension; this
              -- prevents cases when file doesn"t have any extension but still gets some icon
              -- because its name happened to match some extension (default to false)
              strict = true,
              -- same as `override` but specifically for overrides by filename
              -- takes effect when `strict` is true
              override_by_filename = {
                  [".gitignore"] = {
                      icon = "",
                      color = "#f1502f",
                      name = "Gitignore"
                  }
              },
              -- same as `override` but specifically for overrides by extension
              -- takes effect when `strict` is true
              override_by_extension = {
                  ["log"] = {icon = "", color = "#81e043", name = "Log"}
              }
          }
      end
  },
  { -- 缩进线
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    -- event = "VeryLazy",
    config = function()
      vim.opt.list = true
      require("indent_blankline").setup {
        -- for example, context is off by default, use this to turn it on
        show_current_context = true,
        show_current_context_start = true,
      }
    end
  },
  { -- 颜色显示
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup {
        "*"; -- Highlight all files, but customize some others.
        -- "!vim"; -- Exclude vim from highlighting.
        -- Exclusion Only makes sense if "*" is specified!
      }
    end
  }
}
