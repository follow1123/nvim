return {
  { -- 显示相同单词
    "RRethy/vim-illuminate",
    enabled = false,
    config = function()
      require('illuminate').configure()
    end
  },
  { -- which key
    "folke/which-key.nvim",
    -- enabled = false,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 1800
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  { -- markdown
    "iamcco/markdown-preview.nvim",
    enabled =  false,
    build = "cd app && npm install",
    -- event = "VeryLazy",
    -- ft = "md",
    config = function()
      vim.g.mkdp_browser = "surf"
      if _G.IS_WINDOWS then
        vim.g.mkdp_browser = "firefox"
      end
      vim.g.mkdp_filetypes = { "markdown" }
    end
  },
  { -- 起始页
    "goolord/alpha-nvim",
    enabled = false,
    -- lazy = true,
    -- event = "VeryLazy",
    dependencies = {"kyazdani42/nvim-web-devicons"},
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      local config_cmd = ":e ~/.config/nvim/init.lua <CR>"
      if _G.IS_WINDOWS then
        config_cmd = ":e ~/AppData/Local/nvim/init.lua <CR>"
      end
      dashboard.section.buttons.val = {
        dashboard.button("1", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("2", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("3", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("4", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("5", "  Find project", ":Telescope projects <CR>"),
        dashboard.button("s", "  Configuration", config_cmd),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.opts.opts.noautocmd = true
      -- .setup(require("alpha.themes.startify").config)
      require("alpha")
      .setup(dashboard.opts)
    end
  },
  { -- 括号自动匹配
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local status_ok, npairs = pcall(require, "nvim-autopairs")
      if not status_ok then
        vim.notify("autopairs not found!")
        return
      end

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

      -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      -- local cmp_status_ok, cmp = pcall(require, "cmp")
      -- if not cmp_status_ok then
      -- 	return
      -- end
      -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    end
  }
}
