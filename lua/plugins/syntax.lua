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
      require("utils.keymap").nmap("<leader>5", "<cmd>TSToggle highlight<cr>", "Toggle highlight")
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
}
