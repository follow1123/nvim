local util = {}

-- 封装按键映射方法
function util.m(mode, key, tarKey, opts)
	if (opts) then
		opts = {
			noremap = true,
			silent = true,
		}
	end
	-- vim.api.nvim_set_keymap(mode, key, tarKey, opts)
	vim.keymap.set(mode, key, tarKey, opts)
	return util
end

-- visual模式下按键映射 
function util.v(key, tarKey)
	util.m('v', key, tarKey)
	return util
end

-- normal模式下按键映射 
function util.n(key, tarKey)
	util.m('n', key, tarKey)
	return util
end

-- 判断是否为windwos系统
function util.is_windows()
	local has = vim.fn.has
	if (has('win32') ~= 0 or has('win64') ~= 0) then
		return true
	end
	return false
end

-- 判断是否为gui运行
function util.is_gui()
	local has = vim.fn.has
	if (has('gui_running') ~= 0) then
		return true
	end
	return false
end

return util
