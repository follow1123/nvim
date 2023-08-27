-- 语法高亮插件
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
    event = "VeryLazy",
    dependencies = { {
      'nvim-treesitter/nvim-treesitter'
    } }
  }
}
