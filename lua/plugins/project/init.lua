local keymap_uitl = require("utils.keymap")
local lazy_map = keymap_uitl.lazy_map
-- 项目管理
return {
  "ahmedkhalf/project.nvim",
  keys = {
    lazy_map("n", "<leader>pf", "<cmd>lua require('plugins.project.extensions').select_projects()<cr>", "project: List projects"),
    lazy_map("n", "<leader>pr", "<cmd>lua require('plugins.project.extensions').locate_project_root()<cr>", "project: Locate projects root path"),
    lazy_map("n", "<leader>pa", "<cmd>lua require('plugins.project.extensions').add_cur_project()<cr>", "project: Save current working directory"),
  },
  lazy = not _G.IS_GUI,
  dependencies = {
    { -- session
      "folke/persistence.nvim",
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
  },
  config = function()
    require("project_nvim").setup {
      manual_mode = true, -- 手动管理项目的目录
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "Cargo.toml", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "lazy-lock.json" },
      ignore_lsp = {},
      exclude_dirs = { "~/.cargo/*", },
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = 'global',
      datapath = vim.fn.stdpath("data"),
    }

    require("persistence").start() -- 开启保存session功能

    if _G.IS_GUI then -- gui方式启动则加载最后一个session
      vim.schedule(function ()
        vim.cmd("lua require('plugins.project.extensions').load_last_project()")
      end)
    end
  end
}
