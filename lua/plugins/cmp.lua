-- 自动补全插件
return {
  -- 代码补全框架
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- 代码片段补全框架
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
    -- buffer补全
    "hrsh7th/cmp-buffer",
    -- 文件路径补全
    "hrsh7th/cmp-path",
    -- 命令模式补全
    "hrsh7th/cmp-cmdline",
    -- lsp补全
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- vim.api.nvim_create_autocmd
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    local check_backspace = function()
      local col = vim.fn.col "." - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    end
    -- 确认补全是的配置
    local confirm_opts = {
      select = true,                         -- 没有选中补全项时，默认选择第一个
      behavior = cmp.ConfirmBehavior.Insert, -- 补全时插入文本不替换后面的文本
    }
    -- 补全选择时默认配置
    local select_item_opts = {
      behavior = cmp.SelectBehavior.Select -- 选择时默认不补全，只显示虚拟文本
    }
    -- 补全配置
    local cmp_config = {
      -- 补全按键
      mapping = cmp.mapping.preset.insert {
        -- ctrl j上一个
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(select_item_opts), { "i", "c" }),
        -- ctrl k下一个
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(select_item_opts),  { "i", "c" }),
        -- ctrl d文档向上滚动
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        -- ctrl u文件向下滚动
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        -- ["<C-n>"] = cmp.mapping({
        --   i = cmp.config.disable,
        --   c = cmp.config.disable
        -- }),
        -- 补全中断时开始补全
        ["<C-p>"] = cmp.mapping.complete(),
        -- ctrl e取消
        ["<C-e>"] = cmp.mapping.abort(),
        -- tab
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expandable() then -- 如果是代码片段则直接展开
            luasnip.expand()
          elseif cmp.visible() then -- 如果不是代码片段，并且正在选择补全的时候直接确认第一个
            cmp.mapping.confirm(confirm_opts)()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif check_backspace() then
            fallback()
          else
            fallback()
          end
        end,
        { "i", "s" }),
        -- shift tab
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        -- enter 确认
        ["<CR>"] = cmp.mapping.confirm(confirm_opts),
      },
      -- 补全来源
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'buffer' },
        { name = 'path' },
      }),
      experimental = {
        -- 虚拟文本提示
        ghost_text = true,
      },
      -- 代码片段引擎配置
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
    }

    -- 补全提示显示相关
    cmp_config.formatting = {
      fields = { "kind", "abbr", "menu" },
      max_width = 0,
      -- 补全类型图标
      kind_icons = {
        Class = " ",
        Color = " ",
        Constant = "ﲀ ",
        Constructor = " ",
        Enum = "練",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = "",
        Folder = " ",
        Function = " ",
        Interface = "ﰮ ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Operator = "",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = "塞",
        Value = " ",
        Variable = " ",
      },
      -- 补全提示
      source_names = {
        nvim_lsp = "[LSP]",
        path = "[Path]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
      },
      duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        luasnip = 1,
      },
      duplicates_default = 0,
      -- 补全提示文本格式化，[类型图标] [补全名称] [类型]
      format = function(entry, vim_item)
        local max_width = cmp_config.formatting.max_width
        if max_width ~= 0 and #vim_item.abbr > max_width then
          vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
        end
        vim_item.kind = cmp_config.formatting.kind_icons[vim_item.kind]
        vim_item.menu = cmp_config.formatting.source_names[entry.source.name]
        vim_item.dup = cmp_config.formatting.duplicates[entry.source.name]
            or cmp_config.formatting.duplicates_default
        return vim_item
      end,
    }
    -- buffer内搜索时补全
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }
      }
    })
    -- 命令模式补全
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" }
      }, {
        { name = "cmdline" }
      })
    })

    cmp.setup(cmp_config)
  end
}
