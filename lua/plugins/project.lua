local function select_sessions()
  local persistence = require("persistence")
  local list = persistence.list()
  local sessions = list
  local opts = {
    prompt = "select sessions",
    format_item = function(item)
      local tmp = item:reverse()
      local pattern = "/"
      if _G.IS_WINDOWS then
        pattern = "\\"
      end
      local _, i = tmp:find(pattern)
      local m = string.len(tmp) - i + 2
      local s = string.sub(item, m, string.len(tmp) - 4)
      local str = string.gsub(s, "%%", pattern)
      if _G.IS_WINDOWS then
        return string.gsub(str, "\\", ":", 1)
      end
      return str
    end,
  }
  local function on_choice(choice)
    if choice then
      vim.cmd("%bdelete!")
      vim.cmd("silent! source " .. vim.fn.fnameescape(choice))
    end
  end
  vim.ui.select(sessions, opts, on_choice)
end

function test_pjt()
  local project_nvim = require("project_nvim")
  local recent_projects = project_nvim.get_recent_projects()

  print(vim.inspect(recent_projects))
end

return {
  { -- 项目管理
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        -- Manual mode doesn't automatically change your root directory, so you have
        -- the option to manually do so using `:ProjectRoot` command.
        manual_mode = false,

        -- Methods of detecting the root directory. **"lsp"** uses the native neovim
        -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
        -- order matters: if one is not detected, the other is used as fallback. You
        -- can also delete or rearangne the detection methods.
        detection_methods = { "lsp", "pattern" },

        -- All the patterns used to detect root dir, when **"pattern"** is in
        -- detection_methods
        patterns = { ".git", "Cargo.toml", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

        -- Table of lsp clients to ignore by name
        -- eg: { "efm", ... }
        ignore_lsp = {},

        -- Don't calculate root dir on specific directories
        -- Ex: { "~/.cargo/*", ... }
        exclude_dirs = {},

        -- Show hidden files in telescope
        show_hidden = false,

        -- When set to false, you will get a message when project.nvim changes your
        -- directory.
        silent_chdir = true,

        -- What scope to change the directory, valid options are
        -- * global (default)
        -- * tab
        -- * win
        scope_chdir = 'global',

        -- Path where project.nvim will store the project history for use in
        -- telescope
        datapath = vim.fn.stdpath("data"),
      }
    end
  },

  { -- session
    "folke/persistence.nvim",
    enabled = false,
    keys = {
      { "<leader>s", select_sessions, desc = "select sessions" }
    },
    module = "persistence",
    lazy = true,
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
        options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        pre_save = nil,                                          -- a function to call before saving the session
      }
    end
  }
}
