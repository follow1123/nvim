-- 去除回车后注释下一行
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
	end,
})

-- 使用:terminal命令打开终端时默认关闭行号，并直接进入insert模式
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert!")
	end,
})

-- windows下离开insert模式后、进入vim时输入法切换为英文模式
-- linux下离开insert模式数日发切换为英文模式
if _G.IS_WINDOWS then
	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = "*",
    nested = true, -- 允许嵌套
		callback = function() vim.fn.system("im_select.exe 1") end,
	})
else
	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = "*",
		callback = function()
			if tonumber(vim.fn.system("fcitx5-remote")) == 2 then
				vim.fn.system("fcitx5-remote -c")
			end
		end,
	})
end

-- 在终端模式下，vim退出后还原光标样式
if not _G.IS_GUI then
	vim.api.nvim_create_autocmd("VimLeave", {
		pattern = "*",
    nested = true,
		callback = function()
      vim.opt.guicursor:append("a:ver25")
      vim.opt.guicursor:append("a:blinkon1")
      vim.opt.guicursor:append("a:blinkoff1")
		end,
	})
end


-- 复制时高亮
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 100, })
	end,
})

-- treesitter窗口配置
vim.api.nvim_create_autocmd("FileType", {
	pattern = "query",
	callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    -- 加载lua文件相关快捷键
    if not package.loaded["lang.lua"] then
      require("lang.lua")
    end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
    -- 加载lua文件相关快捷键
    if not package.loaded["lang.rust"] then
      require("lang.rust")
    end
	end,
})
