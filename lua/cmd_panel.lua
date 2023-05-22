local plugin = {}

local cmd_list = {}

local cmd_desc = {}

-- 创建一个命令选项
plugin.create = function (opts)
	local key = opts[1]
	local cmd = opts[2]
	local desc = opts[3]
	local tag = opts[4]
	local keys = "[" .. tag .. "]" .. ":" .. desc .. "\t" .. key
	table.insert(cmd_desc, keys)
	cmd_list[keys] = cmd
end

-- 选择命令
plugin.select_cmd = function ()
	vim.ui.select(cmd_desc, {
		prompt = "select commands",
	}, function (choice)
		if choice then
			cmd_list[choice]()
		end
	end)
end


plugin.create({
	"<A-1>",
	function ()
		vim.cmd(":NvimTreeToggle")
	end,
	"toggle nvim tree",
	"nvim-tree"
})
require("util").n("<C-P>", ":lua require('cmd_panel').select_cmd()<CR>")
return plugin

