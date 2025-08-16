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

    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- 补全配置
    cmp.setup({
      enabled = function()
        -- disable completion in comments
        local context = require 'cmp.config.context'
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
          return true
        else
          return not context.in_treesitter_capture("comment")
              and not context.in_syntax_group("Comment")
        end
      end,
      ---@diagnostic disable-next-line
      performance = { max_view_entries = 60 }, -- 最大只显示60条补全数据
      -- 禁用自动选择 item
      preselect = cmp.PreselectMode.None,
      mapping = require("plugins.cmp.keymap"), -- 补全按键
      snippet = {
        expand = function(args)                -- 代码片段引擎配置
          require("luasnip").lsp_expand(args.body)
        end,
      },
      -- 补全默认选中第一个
      completion = {
        keyword_length = 1,
        completeopt = "menu,menuone,noinsert"
      },
      formatting = require("plugins.cmp.format"), -- 补全弹窗数据格式
      -- 补全来源
      -- group_index 每次补全只显示相同组的 source
      -- priority 相同组内不同 sources 优先级（受 group_index 影响，group_index 越小，越早匹配）
      sources = {
        { name = "lazydev",                 group_index = 0 },
        { name = "nvim_lsp_signature_help", group_index = 1, priority = 99 },
        { name = "nvim_lsp",                group_index = 2, priority = 98 },
        { name = "luasnip",                 group_index = 2, priority = 97 },
      },
      view = { docs = { auto_open = true } }, -- 自动开打补全文档弹窗
      -- 补全弹窗样式配置
      window = {
        documentation = { max_height = 20 } -- 文档窗口边框
      },
    })

    -- Telescope搜索时禁用补全功能
    cmp.setup.filetype({ "TelescopePrompt" }, { enabled = false })
    -- 默认在注释内不开启补全，但是在在lua内有文档注释，需要开启补全
    cmp.setup.filetype({ "lua", "javascript" }, { enabled = true })
    -- 补全完成后执行的操作
    cmp.event:on("confirm_done", function()
      -- 因为有时候在补全一些常量是，回车后补全弹框会再次弹出来的问题
      -- 特别是在代码片段内，会导致无法跳转到下一处
      if luasnip.locally_jumpable() then
        vim.schedule_wrap(cmp.close)()
      end
    end)
  end
}
