local plugin = {}

local cmd_list = {}

local cmd_info = {}

local format_commands = function(tag, desc, key)
	return string.format("[%s] %s\t%s", tag, desc, key)
end
-- 创建一个命令选项
plugin.create = function(opts)
	local tag = opts[1] or opts.tag
	local desc = opts[2] or opts.desc
	local callback = opts[3] or opts.callback
	local info = format_commands(tag, desc, "")
	if cmd_info[info] then
		return
	end
	table.insert(cmd_info, info)
	cmd_list[info] = callback
end
-- 选择命令
plugin.select_cmd = function()
	vim.ui.select(cmd_info, {
		prompt = "select commands",
	}, function(choice)
		if choice then
			cmd_list[choice]()
		end
	end)
end

plugin.create_mapping = function(opts)
	local tag = opts[1] or opts.tag
	local desc = opts[2] or opts.desc
	local key = opts[3] or opts.key
	local cmd = opts[4] or opts.cmd
	local callback = opts[5] or opts.callback
	local info = format_commands(tag, desc, key)
	if cmd_info[info] then
		return
	end
	table.insert(cmd_info, info)
	if cmd then
		cmd_list[info] = function()
			vim.cmd(cmd)
		end
	else
		cmd_list[info] = callback
	end
end

plugin.create_lazy = function(opts)
	plugin.create_mapping(opts)
	return {
		opts[4] or opts.cmd,
		opts[3] or opts.key,
		opts[2] or opts.desc
	}
end

require("utils").n("<A-p>", ":lua require('cmd_panel').select_cmd()<CR>")

return plugin
