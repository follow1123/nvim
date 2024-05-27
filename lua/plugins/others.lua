local keymap_uitl = require("utils.keymap")
local lazy_map = keymap_uitl.lazy_map
return {
  { -- markdown
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    ft = "markdown",
    init = function()
      vim.g.mkdp_browser = "chrome"
      if _G.IS_LINUX then
        vim.g.mkdp_browser = "google-chrome"
      end
      vim.g.mkdp_filetypes = { "markdown" }
    end
  },
  { -- 启动时光标恢复到原来的位置
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true
      }
    end
  },
  {
    "ThePrimeagen/harpoon",
    keys = {
      lazy_map("n", "<leader>fa", "<cmd>lua require('harpoon'):list():add()<cr>", "harpoon: Add file to harpoon list"),
      lazy_map("n", "<leader>fl", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", "harpoon: Toggle harpoon list"),
      lazy_map("n", "<S-h>", "<cmd>lua require('harpoon'):list():prev()<cr>", "harpoon: Goto previous file in harpoon list"),
      lazy_map("n", "<S-l>", "<cmd>lua require('harpoon'):list():next()<cr>", "harpoon: Goto next file in harpoon list"),
      lazy_map("n", "<M-j>", "<cmd>lua require('harpoon'):list():select(1)<cr>", "harpoon: Goto next first file in harpoon list"),
      lazy_map("n", "<M-k>", "<cmd>lua require('harpoon'):list():select(2)<cr>", "harpoon: Goto next second in harpoon list"),
      lazy_map("n", "<M-l>", "<cmd>lua require('harpoon'):list():select(3)<cr>", "harpoon: Goto next third in harpoon list"),
      lazy_map("n", "<M-;>", "<cmd>lua require('harpoon'):list():select(4)<cr>", "harpoon: Goto next fourth in harpoon list"),
    },
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
    end
  },
  { -- 颜色显示
    "norcalli/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    config = function()
      require("colorizer").setup { "*" }
    end
  }
}

