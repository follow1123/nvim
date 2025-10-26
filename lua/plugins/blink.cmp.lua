return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "super-tab",
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-c>"] = { "hide", "fallback" },
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<M-k>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      ["<C-space>"] = false,
    },
    completion = {
      documentation = { auto_show = true },
      list = { selection = { preselect = true, auto_insert = false } },
    },
    signature = { enabled = true },
  },
}
