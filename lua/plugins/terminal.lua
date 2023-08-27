-- 浮动终端插件
local toggleterm_mapping = "<C-\\>"                      -- 启动浮动终端的默认按键
local terminal_shell = _G.IS_WINDOWS and "pwsh" or "zsh" -- 终端内默认的shell

-- 计算打开终端的宽度
local get_width = function()
  return math.floor(vim.o.columns * 0.9)
end

-- 计算打开终端的高度
local get_height = function()
  return math.floor(vim.o.lines * 0.9)
end

-- 设置内置终端下默认的快捷键
local function set_term_keymapping()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<Right>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-n>', [[<Down>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-p>', [[<Up>]], opts)
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
    on_open = function()
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<Esc>]], opts)
    end,
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
      local opts = { noremap = true }
      -- 设置切换窗口、调整窗口大小的快捷键
      vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-up>', [[<C-\><C-n><C-W>+:startinsert!<cr>]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-down>', [[<C-\><C-n><C-W>-:startinsert!<cr>]], opts)
      set_term_keymapping()
      -- 临时关闭bufferline和cmdline的高度
      vim.opt_local.laststatus = 0
      vim.opt_local.cmdheight = 0
      vim.cmd("startinsert!")
    end,
    on_close = function()
      vim.opt_local.laststatus = 2
      vim.opt_local.cmdheight = 1
    end,
    hidden = true
  }:toggle()
end

return {
  "akinsho/toggleterm.nvim",
  keys = {
    { toggleterm_mapping, ":ToggleTerm<CR>", desc = "toggle terminal" },
    { "<leader>g",        open_lazygit_term, desc = "open a lazygit float terminal" },
    { "<leader>l",        open_lf_term,      desc = "open a lf float terminal" },
    { "<M-4>",            open_bottom_term,  desc = "open a bottom terminal" },
  },
  config = function()
    -- 默认终端配置
    require("toggleterm").setup {
      open_mapping = toggleterm_mapping,
      shell = terminal_shell,
      direction = "float", -- direction = "vertical" | "horizontal" | "tab" | "float",
      auto_scroll = true,  -- automatically scroll to the bottom on terminal output
      float_opts = {
        border = "curved", -- border = "single" | "double" | "shadow" | "curved" |
        width = get_width, -- 默认占终端长宽的90%
        height = get_height,
        winblend = 3
      },
      on_open = function() -- 开打时设置Esc键退出insert模式
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        set_term_keymapping()
      end,
      shading_factor = 0,
    }

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "term://*toggleterm*" },
      command = "startinsert!",
      nested = true
    })
  end
}
