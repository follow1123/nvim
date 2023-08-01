local keys = {
	map = {}
}
-- key默认配置
-- {
-- 	desc = "",
-- 	mode = "",
-- 	key = "",
-- 	command = "",
-- 	opts = {},
-- 	callback = function ()
-- 		
-- 	end
-- mapping = true
-- panel = true
-- }
keys.map.base = {
	{
		desc = "visual line mode",
		mode = "n",
		key = "<leader>v",
		command = "V",
	},
	{
		desc = "window to left",
		mode = "n",
		key = "<C-left>",
		command = "<C-w><",
	},
	{
		desc = "window to right",
		mode = "n",
		key = "<C-right>",
		command = "<C-w>>",
	},
	{
		desc = "window to up",
		mode = "n",
		key = "<C-up>",
		command = "<C-w>-",
	},
	{
		desc = "window to down",
		mode = "n",
		key = "<C-down>",
		command = "<C-w>+",
	},
	{
		desc = "copy from system clip",
		mode = "v",
		key = "<leader>y",
		command = "\"+y",
	},
	{
		desc = "paste from system clip",
		mode = "n",
		key = "<leader>p",
		command = "\"+p",
	},
	{
		desc = "paste from system clip",
		mode = "v",
		key = "<leader>p",
		command = "\"+p",
	},
	{
		desc = "save file normal mode",
		mode = "n",
		key = "<C-s>",
		command = ":w<CR>",
	},
	{
		desc = "save file insert mode",
		mode = "i",
		key = "<C-s>",
		command = "<Esc>:w<CR>",
	},
	{
		desc = "no higtlight search",
		mode = "n",
		key = "<leader>n",
		command = "<Esc>:nohlsearch<CR>",
	},
	{
		desc = "move row down normal mode",
		mode = "n",
		key = "<A-j>",
		command = "V:m '>+1<CR>gv=gv'<Esc><Esc>",
	},
	{
		desc = "move row up normal mode",
		mode = "n",
		command = "V:m '>-2<CR>gv=gv'<Esc><Esc>",
		key = "<A-k>",
	},
	{
		desc = "move row up visual mode",
		mode = "v",
		key = "<A-k>",
		command = ":m '>-2<CR>gv=gv'<Esc>",
	},
	{
		desc = "move row down visual mode",
		mode = "v",
		key = "<A-j>",
		command = ":m '>+1<CR>gv=gv'<Esc>",
	},
	{
		desc = "pagedown",
		mode = "n",
		key = "<C-d>",
		command = "<C-d>zz",
	},
	{
		desc = "pageup",
		mode = "n",
		key = "<C-u>",
		command = "<C-u>zz",
	},
	{
		desc = "switch tags",
		mode = "n",
		key = "<C-Tab>",
		command = "<C-^>",
	},
	{
		desc = "search next and focus center",
		mode = "n",
		key = "n",
		command = "nzz",
	},
	{
		desc = "search prev and focus center",
		mode = "n",
		key = "N",
		command = "Nzz",
	},
}

keys.map.terminal = {
	{
		mapping = false,
		desc = "open a lazygit terminal",
		key = "<leader>g",
		callback = function()
			local o = require("options")
			require("toggleterm.terminal").Terminal:new({
				cmd = "lazygit",
				direction = o.terminal.def_direction,
				float_opts = o.terminal.def_float_opts,
				hidden = true
			}):toggle()
		end
	},
	{
		mapping = false,
		desc = "open a lf terminal",
		callback = function()
			local o = require("options")
			require("toggleterm.terminal").Terminal:new {
				cmd = "lf",
				direction = o.terminal.def_direction,
				float_opts = o.terminal.def_float_opts,
				hidden = true
			}:toggle()
		end
	},
	{
		mapping = false,
		key = "<A-4>",
		desc = "open a bot terminal",
		callback = function()
			local o = require("options")
			require("toggleterm.terminal").Terminal:new {
				cmd = o.terminal.def_shell,
				direction = "horizontal",
				on_open = function(term)
					vim.cmd("setlocal laststatus=0")
					vim.cmd("setlocal cmdheight=0")
					vim.cmd("startinsert!")
				end,
				on_close = function()
					vim.cmd("setlocal laststatus=2")
					vim.cmd("setlocal cmdheight=1")
				end,
				hidden = true
			}:toggle()
		end
	},
	{
		mapping = false,
		key = "<leader>r",
		desc = "run",
		callback = function()
			local o = require("options")
			require("toggleterm.terminal").Terminal:new {
				cmd = "bash " .. o.get_cur_file_name() .. " ; read",
				direction = "horizontal",
				on_open = function(term)
					vim.cmd("setlocal laststatus=0")
					vim.cmd("setlocal cmdheight=0")
					-- vim.cmd("startinsert!")
				end,
				on_close = function()
					vim.cmd("setlocal laststatus=2")
					vim.cmd("setlocal cmdheight=1")
				end,
				hidden = true
			}:toggle()
		end
	},
}

keys.map.sessions = {
	{
		mapping = false,
		desc = "load session",
		callback = function()
			require("persistence").load()
		end
	},
	{
		mapping = false,
		desc = "load last session",
		callback = function()
			require("persistence").load({ last = true })
		end
	},
	{
		desc = "select session",
		key = "<leader>s",
		callback = function()
			local persistence = require("persistence")
			local o = require("options")
			local list = persistence.list()
			local sessions = list
			local opts = {
				prompt = "select sessions",
				format_item = function(item)
					local tmp = item:reverse()
					local pattern = "/"
					if o.is_windows() then
						pattern = "\\"
					end
					local _, i = tmp:find(pattern)
					local m = string.len(tmp) - i + 2
					local s = string.sub(item, m, string.len(tmp) - 4)
					local str = string.gsub(s, "%%", pattern)
					if o.is_windows() then
						return string.gsub(str, "\\", ":", 1)
					end
					return str
				end,
			}
			local on_choice = function(choice)
				if choice then
					vim.cmd("%bdelete!")
					vim.cmd("silent! source " .. vim.fn.fnameescape(choice))
				end
			end
			vim.ui.select(sessions, opts, on_choice)
		end
	},
}
keys.map.nvim_tree = {
	{
		mapping = false,
		desc = "change tree dir to current dir",
		key = "<leader>t",
		command = ":lua require('nvim-tree').change_dir(vim.fn.getcwd())<CR>"
	},
	{
		mapping = false,
		desc = "find file in nvim tree",
		key = "<A-1>",
		command = ":NvimTreeFindFileToggle<CR>"
	}
}
keys.map.lsp = {
	{
		desc = "format",
		mode = "n",
		key = "<A-l>",
		-- command = "=G",
		command = ":lua vim.lsp.buf.format()<CR>",
	},
	{
		desc = "show diagnostic info",
		key = "<leader><F2>",
		command = ":lua vim.diagnostic.open_float()<CR>",
	},
	{
		mapping = false,
		desc = "goto prev diagnostic line",
		-- key = "[d",
		command = ":lua vim.diagnostic.goto_prev()<CR>",
	},
	{
		mapping = false,
		desc = "goto next diagnostic line",
		-- key = "]d",
		command = ":lua vim.diagnostic.goto_next()<CR>",
	},
	{
		desc = "show code action panel",
		key = "<leader><CR>",
		command = ":lua vim.lsp.buf.code_action()<CR>",
	},
	{
		desc = "rename variable",
		key = "<A-r>",
		command = ":lua vim.lsp.buf.rename()<CR>",
	},
	{
		desc = "definition",
		key = "gd",
		command = ":lua vim.lsp.buf.definition()<CR>",
	},
}
keys.map.bufferline = {
	{
		desc = "close current buffer",
		key = "<A-q>",
		command = ":bdelete!<CR>"
	},
	{
		desc = "goto next buffer",
		key = "<C-l>",
		command = ":BufferLineCycleNext<CR>"
	},
	{
		desc = "goto prev buffer",
		key = "<C-h>",
		command = ":BufferLineCyclePrev<CR>"
	},
}

keys.init = function()
	local cmd_panel = require("cmd_panel")

	for k, v in pairs(keys.map) do
		for i = 1, #v do
			local tag = k
			local mapping = (v[i].mapping == nil and true or v[i].mapping)
			local panel = (v[i].panel == nil and true or v[i].panel)
			local desc = v[i].desc
			local mode = v[i].mode
			local key = v[i].key
			local command = v[i].command
			local opts = v[i].opts
			local callback = v[i].callback
			if mapping then
				if not mode then
					mode = "n"
				end
				if not opts then
					opts = {
						noremap = true,
						silent = true,
					}
				end
				if not command then
					if callback then
						command = callback
					else
						command = ":echo 'command not found: " .. key .. "'"
					end
				end
				vim.keymap.set(mode, key, command, opts)
			end
			if panel and tag ~= "base" then
				cmd_panel.create {
					tag = tag,
					key = key,
					desc = desc,
					command = command,
					callback = callback
				}
			end
		end
	end
end
return keys
