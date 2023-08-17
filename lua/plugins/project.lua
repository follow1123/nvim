return {
  { -- session
    "folke/persistence.nvim",
    module = "persistence",
    lazy = true,
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
        options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        pre_save = nil,                                     -- a function to call before saving the session
      }
    end
  }
}
