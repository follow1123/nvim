-- 自动补全插件
return {
  -- 代码补全框架
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    -- 代码片段框架
    {
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
    },
    -- 补全来源
    "saadparwaiz1/cmp_luasnip", -- 代码片段
    "hrsh7th/cmp-nvim-lsp-signature-help", -- 参数
    "hrsh7th/cmp-buffer", -- buffer
    "hrsh7th/cmp-path", -- 文件路径
    "hrsh7th/cmp-cmdline", -- 命令
    "hrsh7th/cmp-nvim-lsp", -- lsp
  },
  config = function()
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on( "confirm_done", cmp_autopairs.on_confirm_done()) -- 选择补全自动拼接括号
    local cmp_keymap = require("plugins.cmp.keymap")
    -- 加载代码片段
    require("luasnip.loaders.from_vscode").lazy_load()
    -- 补全配置
    cmp.setup{
      view = { -- 补全文档配置
        docs = {
          auto_open = true -- 自动开打补全文档弹窗
        }
      },
      window = { -- 补全弹窗样式配置
        completion = {
          scrollbar = false,
          col_offset = 1
        },
        documentation = {
          border = "single",
        }
      },
      enable = function () -- 是否启动补全
        local context = require("cmp.config.context")
        if vim.api.nvim_get_mode().mode == "c" then
          return true
        else -- 在注释内不开启补全功能
          return not context.in_treesitter_capture("comment")
            and not context.in_syntax_group("Comment")
        end
      end,
      mapping = cmp_keymap.insert, -- 补全按键
      -- 补全来源
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
        { name = "nvim_lsp_signature_help" },
        { name = "buffer" },
        { name = "path" },
      }),
      experimental = {
        ghost_text = true, -- 虚拟文本提示
      },
      snippet = {
        expand = function(args) -- 代码片段引擎配置
          require("luasnip").lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert" -- 补全默认选中第一个
      },
      formatting = require("plugins.cmp.format"), -- 补全弹窗数据格式
      performancem = {
        max_view_entries = 60 -- 最大只显示60条补全数据
      }
    }
    -- buffer内搜索时补全
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp_keymap.cmdline,
      sources = {
        { name = "buffer" }
      }
    })
    -- 命令模式补全
    cmp.setup.cmdline(":", {
      mapping = cmp_keymap.cmdline,
      sources = cmp.config.sources({
        { name = "path" }
      }, {
          { name = "cmdline" }
        })
    })
  end
}
