return {
  "nvim-treesitter/nvim-treesitter",
  -- event = "VeryLazy",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter').install {
      "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust", "json", "yaml", "toml", "javascript", "typescript"
    }
  end
}
