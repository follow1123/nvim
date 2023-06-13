local plugin = {}

local cmd_list = {}

local cmd_info = {}

local format_commands = function(tag, desc, key)
	return string.format("[%s] %s\t%s", tag, desc, key)
end
-- 创建一个命令选项
plugin.create = function(opts)
	local tag = opts.tag
	local key = opts.key
	local command = opts.command
	local desc = opts.desc
	local callback = opts.callback
	-- key默认为空串
	if not key then
		key = ""
	end
	-- 默认使用回调，回调为空则执行命令，命令为空则提示
	if not callback then
		if command then
			callback = function()
				command = string.gsub(command, "<[a-zA-Z]+>", "")
				vim.cmd(command)
			end
		else
			callback = function()
				vim.cmd(":echo 'command not found: " .. key .. "'")
			end
		end
	end
	local info = format_commands(tag, desc, key)
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

vim.keymap.set("n", "<C-S-p>", ":lua require('cmd_panel').select_cmd()<CR>", {
	noremap = true,
	silent = true,
})

return plugin
