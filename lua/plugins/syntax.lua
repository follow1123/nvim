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
          enable = true,
          disable = function(_, buf)
            local max_filesize = 1024 * 1024 * 2
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            -- 当文件大于2M时不显示高亮
            if ok and stats and stats.size > max_filesize then
              vim.notify("file size too big", vim.log.levels.WARN)
              -- 这里写false才是禁用，不知道是不是代码问题
              return false
            end
            return true
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      }
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
  { -- 代码导航
    "utilyre/barbecue.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "SmiteshP/nvim-navic" },
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
      vim.api.nvim_set_hl(0, "IlluminatedWordText", {sp = "#FFFFFF"}) -- 符号引用处的颜色
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", {bg = "#4b4b4b"}) -- 符号引用处的颜色
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {underline = true, bg = "#264f78", sp = "#FFFFFF"}) -- 符号声明或定义处的颜色
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
        vim.api.nvim_set_hl(0, "IndentGray", { fg = "#303030" })
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
