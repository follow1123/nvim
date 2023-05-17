local util = {}

-- 封装按键映射方法
function util.m(mode, key, tarKey, type)
    -- vim.api.nvim_set_keymap(mode, key, tarKey, type)
	vim.keymap.set(mode, key, tarKey, type)
	return util
end

-- visual模式下按键映射 
function util.v(key, tarKey)
	util.m('v', key, tarKey, {noremap = true})
	return util
end

-- normal模式下按键映射 
function util.n(key, tarKey)
	util.m('n', key, tarKey, {noremap = true})
	return util
end

return util
