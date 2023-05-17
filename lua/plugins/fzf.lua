-- fzf搜索插件
return {
	{
		'junegunn/fzf',
		event = "VeryLazy",
		enabled = false,
		config = function()
		end
	},
	{
		'junegunn/fzf.vim',
		event = "VeryLazy",
		enabled = false,
		config = function()
			-- 默认打开文件树快捷键
			require('util')
				.m('n', '<A-f>', ':Rg<cr>', {noremap = true})
				.m('n', '<c-f>', ':FZF<cr>', {noremap = true})
			-- vim.g.fzf_preview_window = {'right,50%', 'ctrl-/'}
			vim.api.nvim_command([[
			function! RipgrepFzf(query, fullscreen)
			let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
			let initial_command = printf(command_fmt, shellescape(a:query))
			let reload_command = printf(command_fmt, '{q}')
			let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
			let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
			call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
			endfunction
			]])
		end
	}
}
