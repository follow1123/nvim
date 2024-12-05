return {
  "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
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
}
