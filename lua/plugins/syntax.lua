local colors = require("utils.colors")
-- 语法插件
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup{
        ensure_installed = {
          "lua", "rust", "c", "cpp", "json", "yaml", "toml", "markdown", "javascript", "typescript"
        },
        sync_install = false,
        auto_install = true,
        ignore_install = { },
        modules = {},
        highlight = {
          enable = false,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      }
      require("utils.keymap").nmap("<leader>5", "<cmd>TSToggle highlight<cr>")
    end
  },
  { -- 括号自动匹配
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup {
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel", "dap-repl", "guihua", "guihua_rust", "clap_input" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0, -- Offset from pattern match
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      }
    end
  },
  { -- 显示相关符号
    "RRethy/vim-illuminate",
    keys = { "h", "j", "k", "l" },
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex", },
        delay = 100,
        filetypes_denylist = { "dirvish", "fugitive", "NvimTree", "TelescopePrompt"},
        large_file_cutoff = nil,
        large_file_overrides = nil,
        min_count_to_highlight = 1,
        under_cursor = false,
      })
      -- 设置光标所在符号位置颜色
      vim.api.nvim_set_hl(0, "IlluminatedWordText", {sp = colors.white_01}) -- 符号引用处的颜色
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", {bg = colors.gray_02}) -- 符号引用处的颜色
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {underline = true, bg = colors.blue_04, sp = colors.white_01}) -- 符号声明或定义处的颜色
    end
  },
  { -- 缩进线
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      -- 显示空白字符
      vim.opt.list = true
      -- vim.opt.listchars:append "space:⋅"
      vim.opt.listchars:append "eol:↴"
      vim.opt.listchars:append "tab: > "
      vim.opt.listchars:append "trail: "

      -- 配置缩进线颜色组，可以配置多种颜色
      local highlight = { "IndentGray" }
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IndentGray", { fg = colors.gray_03 })
      end)

      -- indent-blankline插件相关配置
      require("ibl").setup({
        indent = {
          -- 缩进线样式
          char = "▏",
          tab_char = "▏",
          highlight = highlight
        }
      })

    end
  },
}
