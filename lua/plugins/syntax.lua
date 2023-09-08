-- 语法插件
return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = "VeryLazy",
    build = ':TSUpdate',
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "rust" },
        sync_install = false,
        auto_install = true,
        ignore_install = { "javascript" },
        highlight = {
          enable = true,
          disable = function(_, buf)         -- 文件大于1M则不加载
            local max_filesize = 1000 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
          colors = {
            '#fac205',
            '#558961',
            '#1c4374',
            '#bf794e',
            '#ff77aa',
          }
        },
      }
    end
  },
  -- 彩色括号插件
  {
    'p00f/nvim-ts-rainbow',
    ft = { "lua", "c", "rust", "ps1" },
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  -- 文件大纲插件
  {
    "simrat39/symbols-outline.nvim",
    keys = {
      { "<A-2>", ":SymbolsOutline<CR>", desc = "SymbolsOutline" },
    },
    config = function()
      require("symbols-outline").setup{
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false,
        position = "right",
        relative_width = true,
        width = 25,
        auto_close = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = "Pmenu",
        autofold_depth = nil,
        auto_unfold_hover = true,
        fold_markers = { "", "" },
        wrap = false,
        keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = {"<Esc>", "q"},
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_all = "W",
        unfold_all = "E",
        fold_reset = "R",
      },
      lsp_blacklist = {},
      symbol_blacklist = {},
      symbols = {
        File = { icon = "", hl = "@text.uri" },
        Module = { icon = "", hl = "@namespace" },
        Namespace = { icon = "", hl = "@namespace" },
        Package = { icon = "", hl = "@namespace" },
        -- Class = { icon = "𝓒", hl = "@type" },
        -- Class = { icon = "", hl = "@type" },
        Class = { icon = "Class", hl = "@type" },
        Method = { icon = "ƒ", hl = "@method" },
        Property = { icon = "", hl = "@method" },
        Field = { icon = "", hl = "@field" },
        Constructor = { icon = "", hl = "@constructor" },
        Enum = { icon = "ℰ", hl = "@type" },
        Interface = { icon = "ﰮ", hl = "@type" },
        Function = { icon = "", hl = "@function" },
        Variable = { icon = "", hl = "@constant" },
        Constant = { icon = "", hl = "@constant" },
        -- String = { icon = "𝓐", hl = "@string" },
        String = { icon = "", hl = "@string" },
        Number = { icon = "#", hl = "@number" },
        Boolean = { icon = "⊨", hl = "@boolean" },
        Array = { icon = "", hl = "@constant" },
        Object = { icon = "⦿", hl = "@type" },
        -- Key = { icon = "🔐", hl = "@type" },
        Key = { icon = "", hl = "@type" },
        Null = { icon = "NULL", hl = "@type" },
        EnumMember = { icon = "", hl = "@field" },
        -- Struct = { icon = "𝓢", hl = "@type" },
        -- Struct = { icon = "", hl = "@type" },
        Struct = { icon = "Struct", hl = "@type" },
        -- Event = { icon = "🗲", hl = "@type" },
        -- Event = { icon = "", hl = "@type" },
        Event = { icon = "Event", hl = "@type" },
        Operator = { icon = "+", hl = "@operator" },
        -- TypeParameter = { icon = "𝙏", hl = "@parameter" },
        TypeParameter = { icon = "TypeParam", hl = "@parameter" },
        Component = { icon = "", hl = "@function" },
        Fragment = { icon = "", hl = "@constant" },
      },
    }
  end,
}
}
