local funcs = {}

funcs.get_cur_file_name = function()
	return vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
end

return funcs
