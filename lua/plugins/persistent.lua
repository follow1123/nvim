-- session 相关扩展方法
local utils = require("utils")
local panel = require("cmd_panel")

pg.sessions = {}

-- 加载session
pg.sessions.load = function()
	require("persistence").load()
end

-- 加载上次最后一个session
pg.sessions.load_last = function()
	require("persistence").load { last = true }
end
-- 选择历史session
pg.sessions.select = function()
	local persistence = require("persistence")
	local utils = require("utils")
	local list = persistence.list()
	local sessions = list
	local opts = {
		prompt = "select sessions",
		format_item = function(item)
			local tmp = item:reverse()
			local pattern = "/"
			if utils.is_windows() then
				pattern = "\\"
			end
			local _, i = tmp:find(pattern)
			local m = string.len(tmp) - i + 2
			local s = string.sub(item, m, string.len(tmp) - 4)
			local str = string.gsub(s, "%%", pattern)
			if utils.is_windows() then
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

local tag = "sessions"
panel.create{
	tag,
	"select sessions",
	pg.sessions.select,
}
panel.create{
	tag,
	"load a session",
	pg.sessions.load,
}
panel.create{
	tag,
	"load last sessions",
	pg.sessions.load_last,
}
utils.n("<leader>s", pg.sessions.select)
-- vim.api.nvim_create_autocmd('VimEnter', {
-- 	callback = function()
-- 		require("persistence").load {
-- 			last = true
-- 		}
-- 	end
-- })
return {
	"folke/persistence.nvim",
	module = "persistence",
	lazy = true,
	config = function()
		require("persistence").setup {
			dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
			options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
			pre_save = nil,                                     -- a function to call before saving the session
		}
	end
}
