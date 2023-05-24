-- 自动补全插件
local plugin = {
	-- 代码补全框架
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- 代码片段补全框架
		{ "L3MON4D3/LuaSnip" },
		{ "saadparwaiz1/cmp_luasnip" },
		-- buffer补全
		{ "hrsh7th/cmp-buffer" },
		-- 文件路径补全
		{ "hrsh7th/cmp-path" },
		-- 命令模式补全
		{ "hrsh7th/cmp-cmdline" },
		-- lsp补全
		{ "hrsh7th/cmp-nvim-lsp" },
		-- { "hrsh7th/cmp-nvim-lua", event = "VeryLazy" },
	},
}

plugin.config = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	require("luasnip.loaders.from_vscode").lazy_load()
	local check_backspace = function()
		local col = vim.fn.col "." - 1
		return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
	end
	local cmp_config = {}
	-- 补全按键
	cmp_config.mapping = cmp.mapping.preset.insert {
		-- ctrl k下一个
		["<C-k>"] = cmp.mapping.select_prev_item(),
		-- ctrl k上一个
		["<C-j>"] = cmp.mapping.select_next_item(),
		-- ctrl d文档向上滚动
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		-- ctrl u文件向下滚动
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-p>"] = cmp.mapping.complete(),
		-- ctrl e 取消 或者esc
		["<C-e>"] = cmp.mapping.abort(),
		-- tab 下一个
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, { "i", "s", }),
		-- shift tab 上一个
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s",}),
		-- enter 确认
		["<CR>"] = cmp.mapping.confirm({
			select = true ,
			behavior = cmp.ConfirmBehavior.Replace
		}),
	}
	-- 补全来源
	cmp_config.sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "calc" },
		{ name = "emoji" },
		{ name = "treesitter" },
		{ name = "crates" },
	}
	cmp_config.experimental = {
		-- 虚拟文本提示
		ghost_text = true,
		-- native_menu = false,
	}

	-- 代码片段引擎配置
	cmp_config.snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	}
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
			treesitter = "[TS]",
			emoji = "[Emoji]",
			path = "[Path]",
			calc = "[Calc]",
			vsnip = "[Snippet]",
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
	-- 边框样式 圆角边框
	cmp_config.window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
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
	-- Set up lspconfig.
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	-- Replace <YOUR_LSP_SERVER> with each lsp server you"ve enabled.
	require("lspconfig")["lua_ls"].setup {
		capabilities = capabilities
	}
end


return plugin
