-- 去除回车后注释下一行
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
    end,
})

if not require("util").is_windows() then
	-- 离开插入模式后输入法自动切换为英文
	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		pattern = { "*" },
		callback = function()
			local input_status = tonumber(vim.fn.system("fcitx-remote"))
			if input_status == 2 then
				vim.fn.system("fcitx-remote -c")
			end
		end,
	})
end

-- if options.auto_save then
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        pattern = { "*" },
        command = "silent! wall",
        nested = true,
    })
-- end
