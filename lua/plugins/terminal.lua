-- 浮动终端插件
local toggleterm_mapping = "<C-\\>"                         -- 启动浮动终端的默认按键
local terminal_shell = _G.IS_WINDOWS and "pwsh" or "zsh"    -- 终端内默认的shell

-- 计算打开终端的宽度
local get_width = function()
  return math.floor(vim.o.columns * 0.9)
end

-- 计算打开终端的高度
local get_height = function()
  return math.floor(vim.o.lines * 0.9)
end

-- 打开一个lazygit浮动终端
local function open_lazygit_term()
  require("toggleterm.terminal").Terminal:new({
    cmd = "lazygit",
    direction = "float",
    float_opts = {
      border = "curved", -- border = "single" | "double" | "shadow" | "curved" |
      width = get_width, -- 默认占终端长宽的90%
      height = get_height,
      winblend = 3
    },
    hidden = true
  }):toggle()
end

-- 打开一个lf浮动终端
local function open_lf_term()
  require("toggleterm.terminal").Terminal:new {
    cmd = "lf",
    direction = "float",
    float_opts = {
      border = "curved", -- border = "single" | "double" | "shadow" | "curved" |
      width = get_width, -- 默认占终端长宽的90%
      height = get_height,
      winblend = 3
    },
    hidden = true
  }:toggle()
end

-- 打开一个底部的终端
local function open_bottom_term()
   require("toggleterm.terminal").Terminal:new {
    cmd = terminal_shell,
    direction = "horizontal",
    on_open = function()
      local opts = {noremap = true}
      vim.cmd("setlocal laststatus=0")
      vim.cmd("setlocal cmdheight=0")
      vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
      vim.cmd("startinsert!")
    end,
    on_close = function()
      vim.cmd("setlocal laststatus=2")
      vim.cmd("setlocal cmdheight=1")
    end,
    hidden = true
  }:toggle()
end

-- terminal模式下设置临时按键映射
-- function _G.set_terminal_keymaps()
--   local opts = {noremap = true}
--   vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
--   vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
--   vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
--   vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
--   vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
-- end

-- 打开terminal模式后设置临时按键映射
-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

return {
	"akinsho/toggleterm.nvim",
	keys = {
		{ toggleterm_mapping, ":ToggleTerm<CR>", desc = "toggle terminal" },
		{ "<leader>g", open_lazygit_term, desc = "open a lazygit float terminal" },
		{ "<leader>l", open_lf_term, desc = "open a lf float terminal" },
		{ "<M-4>", open_bottom_term, desc = "open a bottom terminal" },
	},
	config = function()
		-- 默认终端配置
		require("toggleterm").setup {
			open_mapping = toggleterm_mapping,
			shell = terminal_shell, 
			direction = "float", -- direction = "vertical" | "horizontal" | "tab" | "float",
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
      float_opts = {
        border = "curved", -- border = "single" | "double" | "shadow" | "curved" |
        width = get_width, -- 默认占终端长宽的90%
        height = get_height,
        winblend = 3
      },
			shading_factor = 0,
		}
	end
}
