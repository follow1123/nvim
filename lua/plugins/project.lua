
-- 根据session list 获取对应session的root
local function get_session_root(path)
  local session_dir = require("persistence.config").options.dir
  path = path:sub(session_dir:len() + 1, path:len())
  path = path:gsub("%%", ":", 1)
  path = path:gsub("%%", "/")
  return path:sub(1, path:len() - 4)
end

-- 选择一个最近的项目打开
local function select_projects()
  local recent_projects = require("project_nvim").get_recent_projects()
  vim.ui.select(recent_projects, {
    prompt = "select project",
  },
  -- 切换当前目录到选择的项目
  function (choice)
    if choice then
      local persistence = require("persistence")
      local session_list = persistence.list()
      for _, value in pairs(session_list) do
        if choice:match(get_session_root(value)) then
          vim.cmd("%bdelete!")
          vim.cmd("silent! source " .. vim.fn.fnameescape(value))
          break
        end
      end
      -- 开启保存session功能
      persistence.start()
      vim.api.nvim_set_current_dir(choice)
    end
  end)
end

return {
  { -- 项目管理
    "ahmedkhalf/project.nvim",
    events = "VeryLazy",
    config = function()
      require("project_nvim").setup {
        manual_mode = true, -- 手动管理项目的目录
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "Cargo.toml", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
        ignore_lsp = {},
        exclude_dirs = { "~/.cargo/*", },
        -- Show hidden files in telescope
        show_hidden = false,
        -- When set to false, you will get a message when project.nvim changes your
        -- directory.
        silent_chdir = true,
        scope_chdir = 'global',
        datapath = vim.fn.stdpath("data"),
      }
      local opts = { noremap = false,  silent = true }
      opts.desc = "open a recent project directory"
      vim.keymap.set("n", "<leader>pf", select_projects, opts)
    end
  },
  { -- session
    "folke/persistence.nvim",
    module = "persistence",
    lazy = true,
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- session保存
        options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        pre_save = nil,                                          -- 保存session前执行的方法
      }
      -- 默认关闭保存session功能
      require("persistence").stop()
    end
  }
}
