local keymap_uitl = require("utils.keymap")
local lazy_map = keymap_uitl.lazy_map
local nmap = keymap_uitl.nmap
return {
  { -- which key
    "folke/which-key.nvim",
    event = "InsertEnter",
    keys = "<space>",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 700
      local wk = require("which-key")
      wk.register({
        ["<leader>"] = {
          name = "Base custom keymap",
          b = "Buffer",
          c = "Code",
          d = "Diff",
          f = "File",
          g = "Git",
          h = "Help",
          l = "LSP",
          p = "Project",
          w = "Window",
        },
        ["["] = "Next Options",
        ["]"] = "Previous Options",
      })
      wk.setup {
        window = {
          border = "single",
        }
      }
      vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "#1e1e1e" })
    end,
  },
  { -- markdown
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_browser = "chrome"
      vim.g.mkdp_filetypes = { "markdown" }
      -- 设置预览markdown快捷键
      nmap("<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", {
        desc = "markdown: Markdown preview toggle",
        buffer = true
      })
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
  { -- 启动时光标恢复到原来的位置
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true
      }
    end
  },
  { -- 代码导航
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    name = "barbecue",
    dependencies = { "SmiteshP/nvim-navic", },
    config = function()
      vim.opt.updatetime = 200

      require("barbecue").setup({
        create_autocmd = false,                            -- prevent barbecue from updating itself automatically
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
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", {bg = "#4b4b4b"}) -- 符号引用处的颜色
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {underline = true, bg = "#264f78" }) -- 符号声明或定义处的颜色
    end
  },
  { -- vim.ui 图形化插件
    "stevearc/dressing.nvim",
    module = true,
    config = function()
      require("dressing").setup{
        select = {
          -- Options for nui Menu
          -- nui = {
          --   position = "50%",
          --   size = nil,
          --   -- relative = "editor",
          --   border = {
          --     style = "rounded",
          --   },
          --   buf_options = {
          --     swapfile = false,
          --     filetype = "DressingSelect",
          --   },
          --   win_options = {
          --     winblend = 10,
          --   },
          --   max_width = 80,
          --   max_height = 40,
          --   min_width = 40,
          --   min_height = 10,
          -- },
          get_config = function(opts)
            if opts.kind == 'codeaction' then
              return {
                backend = 'nui',
                nui = {
                  relative = "cursor",
                  max_width = 40,
                }
              }
            end
          end
        }
      }
    end
  },
  { -- 注释插件
    "numToStr/Comment.nvim",
    keys = {
      lazy_map("n", "<M-e>", "<cmd>normal gcc<cr>", "comment: Comment code in normal mode"),
      lazy_map("v","<M-e>", "<cmd>normal gcc<cr>", "comment: Comment code in visual mode"),
    },
    config = function()
      require("Comment").setup()
    end
  }
}

