cmd = {}

cmd.session = {
	load = function()
		require("persistence").load()
	end,
	load_last = function()
		require("persistence").load { last = true }
	end,
	select = function()
		local persistence = require("persistence")
		local util = require("util")
		local list = persistence.list()
		local sessions = list
		local opts = {
			prompt = "select sessions",
			format_item = function(item)
				local tmp = item:reverse()
				local pattern = "/"
				if util.is_windows() then
					pattern = "\\"
				end
				local _, i = tmp:find(pattern)
				local m = string.len(tmp) - i + 2
				local s = string.sub(item, m, string.len(tmp) - 4)
				return string.gsub(s, "%%", pattern)
			end,
		}
		local on_choice = function(choice)
			if choice then
				vim.cmd("%bdelete")
				vim.cmd("silent! source " .. vim.fn.fnameescape(choice))
			end
		end
		vim.ui.select(sessions, opts, on_choice)
	end
}
