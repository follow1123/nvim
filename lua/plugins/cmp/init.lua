-- 自动补全插件
return {
  {"hrsh7th/cmp-nvim-lsp", lazy = true}, -- lsp
  {"hrsh7th/cmp-nvim-lsp-signature-help", lazy = true}, -- 参数
  {"hrsh7th/cmp-buffer", lazy = true}, -- buffer
  {
    -- 代码补全框架
    "hrsh7th/nvim-cmp",
    -- lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- 代码片段框架
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
      },
      -- 补全来源
      "saadparwaiz1/cmp_luasnip", -- 代码片段
      "hrsh7th/cmp-cmdline", -- 命令
      "hrsh7th/cmp-path", -- path
    },
    config = function()
      vim.opt.pumheight = 15 -- 补全弹窗最大补全个数
      local cmp = require("cmp")
      local cmp_keymap = require("plugins.cmp.keymap")
      local cmp_source = require("plugins.cmp.source")
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
        sources = cmp_source.global_sources,
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
        completion = {
          autocomplete = false,
        },
        mapping = cmp_keymap.cmdline,
        sources = {
          { name = "buffer" }
        }
      })
      -- 命令模式补全
      cmp.setup.cmdline(":", {
        completion = {
          autocomplete = false,
        },
        mapping = cmp_keymap.cmdline,
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        )
      })

      -- 加载所有buffer的源
      local listed_buf = vim.fn.getbufinfo({buflisted = 1})
      for _, buf in ipairs(listed_buf) do
        cmp_source.load_lsp_cmp(buf.bufnr)
        cmp_source.load_buffer_cmp(buf.bufnr)
      end
    end
  }
}
