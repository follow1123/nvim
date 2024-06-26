-- 自动补全插件
return {
  -- 代码补全框架
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- lsp
    "hrsh7th/cmp-nvim-lsp-signature-help", -- 参数
    "hrsh7th/cmp-buffer", -- buffer
    "hrsh7th/cmp-path", -- path
    {
      "saadparwaiz1/cmp_luasnip", -- 代码片段
      dependencies = {
        "L3MON4D3/LuaSnip", -- 代码片段引擎
        dependencies = "rafamadriz/friendly-snippets", -- 代码片段
      }
    }
  },
  config = function()
    vim.opt.pumheight = 15 -- 补全弹窗最大补全个数
    local cmp = require("cmp")
    -- 加载代码片段
    require("luasnip.loaders.from_vscode").lazy_load()

    -- 补全配置
    cmp.setup({
      enabled = function() -- 是否启动补全
        local context = require("cmp.config.context")
        if vim.api.nvim_get_mode().mode == "c" then
          return true
        else -- 在注释内不开启补全功能
          return not context.in_treesitter_capture("comment")
            and not context.in_syntax_group("Comment")
        end
      end,
      performancem = { max_view_entries = 60 }, -- 最大只显示60条补全数据
      mapping = require("plugins.cmp.keymap"), -- 补全按键
      snippet = {
        expand = function(args) -- 代码片段引擎配置
          require("luasnip").lsp_expand(args.body)
        end,
      },
      -- 补全默认选中第一个
      completion = { completeopt = "menu,menuone,noinsert" },
      formatting = require("plugins.cmp.format"), -- 补全弹窗数据格式
      sources = require("plugins.cmp.source"), -- 补全来源
      view = { docs = { auto_open = true } }, -- 自动开打补全文档弹窗
      -- 补全弹窗样式配置
      window = {
        completion = { col_offset = 1 }, -- 补全窗口左边距
        documentation = { border = "single" } -- 文档窗口边框
      },
      experimental = { ghost_text = true }, -- 虚拟文本
    })

    -- Telescope搜索时禁用补全功能
    cmp.setup.filetype({ "TelescopePrompt" }, { enabled = false })
    -- 默认在注释内不开启补全，但是在在lua内有文档注释，需要开启补全
    cmp.setup.filetype({ "lua" }, { enabled = true })

    cmp.event:on("confirm_done", function (evt)
      if vim.o.filetype == "lua" then
        if evt.commit_character then return end
        local Kind = cmp.lsp.CompletionItemKind
        local entry = evt.entry
        local item = entry:get_completion_item()
        if item.kind == Kind.Function or item.kind ==  Kind.Method then
          local key = "("
          local line = vim.fn.line(".")
          local col = vim.fn.col(".")
          line = line > 0 and line - 1 or line
          local next_char = vim.api.nvim_buf_get_text(
            0, line, col, line, col + 1, {})[1]
          if not string.match(next_char, "^%S") then
            key = string.format("%s)%s", key,
              vim.api.nvim_replace_termcodes("<Left>", true, false, true))
          end
          vim.api.nvim_feedkeys(key, "i", true)
        end
      end
    end)
  end
}
