local plugin = {
	"folke/persistence.nvim",
	module = "persistence",
	lazy = true,
}

plugin.config = function()
	require("persistence").setup {
		dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
		options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
		pre_save = nil,                                        -- a function to call before saving the session
	}
end

vim.api.nvim_create_autocmd('UIEnter', {
	callback = function()
		-- require("persistence").load {
			-- last = true
		-- }
	end
})
return plugin
