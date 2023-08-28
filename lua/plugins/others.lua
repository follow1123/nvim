return {
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
  },
  { -- 启动时光标回复到原来的位置
    "ethanholz/nvim-lastplace",
    config = function ()
      require("nvim-lastplace").setup {
          lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
          lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
          lastplace_open_folds = true
      }
    end
  },
  { -- 代码位置
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      --"nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function ()
      -- triggers CursorHold event faster
      vim.opt.updatetime = 200

      require("barbecue").setup({
        create_autocmd = false, -- prevent barbecue from updating itself automatically
        exclude_filetypes = { "netrw", "toggleterm", "" }, -- "" 内置终端没有filetype属性
      })

      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end
  },
  { -- 显示相同单词
    "RRethy/vim-illuminate",
    -- enabled = false,
    config = function()
      -- default configuration
      require('illuminate').configure({
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
        -- delay: delay in milliseconds
        delay = 100,
        -- filetype_overrides: filetype specific overrides.
        -- The keys are strings to represent the filetype while the values are tables that
        -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
        filetype_overrides = {},
        -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
        filetypes_denylist = {
          'dirvish',
          'fugitive',
          'NvimTree',
        },
        -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
        filetypes_allowlist = {},
        -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
        -- See `:help mode()` for possible values
        modes_denylist = {},
        -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
        -- See `:help mode()` for possible values
        modes_allowlist = {},
        -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_denylist = {},
        -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_allowlist = {},
        -- under_cursor: whether or not to illuminate under the cursor
        under_cursor = true,
        -- large_file_cutoff: number of lines at which to use large_file_config
        -- The `under_cursor` option is disabled when this cutoff is hit
        large_file_cutoff = nil,
        -- large_file_config: config to use for large files (based on large_file_cutoff).
        -- Supports the same keys passed to .configure
        -- If nil, vim-illuminate will be disabled for large files.
        large_file_overrides = nil,
        -- min_count_to_highlight: minimum number of matches required to perform highlighting
        min_count_to_highlight = 1,
      })
    end
  },
}
