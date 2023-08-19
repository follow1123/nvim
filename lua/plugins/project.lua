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

return {
  { -- session
    "folke/persistence.nvim",
    keys = {
      { "<leader>s", select_sessions, desc = "select sessions" }
    },
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
