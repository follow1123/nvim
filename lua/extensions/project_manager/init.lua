local Manager = require("extensions.project_manager.manager")

return Manager:new({
  session_root = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
  session_options = { "curdir", "buffers", "tabpages", "winsize", "folds" },
  project_root_patterns = {
    ".git",
    ".editorconfig",
    "cargo.toml",
    "package.json",
    "tsconfig.json",
    "makefile",
    "lua",
    "lazy-lock.json",
    "go.mod",
    "go.sum",
  }
})
