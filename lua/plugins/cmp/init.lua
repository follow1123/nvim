-- 自动补全插件
return {
  -- 代码补全框架
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",                            -- lsp
    "hrsh7th/cmp-nvim-lsp-signature-help",             -- 参数
    {
      "saadparwaiz1/cmp_luasnip",                      -- 代码片段
      dependencies = {
        "L3MON4D3/LuaSnip",                            -- 代码片段引擎
        version = "v2.*",
        dependencies = "rafamadriz/friendly-snippets", -- 代码片段
      }
    }
  },
  config = function()
    -- 加载代码片段
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip").log.set_loglevel("debug")

    require("plugins.cmp.config").setup_config()
  end
}
