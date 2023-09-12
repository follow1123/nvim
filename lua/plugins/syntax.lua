-- 语法插件
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup{
        ensure_installed = {"lua", "rust", "c"},
        sync_install = false,
        auto_install = true,
        ignore_install = { },
        modules = {},
        highlight = {
          enable = true,
          disable = function(_, buf)
            local max_filesize = 5 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      }
      -- vim.print(vim.inspect_pos(0,1, 50))

    end
  },
  -- 彩色括号插件
  {
    "p00f/nvim-ts-rainbow",
    enabled = false,
    -- ft = _G.LANG,
  }
}
