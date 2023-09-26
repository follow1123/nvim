local keymap_util = require("utils.keymap")
local buf_map = keymap_util.buf_map

local term_utils = require("extensions.terminal.utils")

local term_config = {}

local shell = _G.IS_WINDOWS and "pwsh" or "zsh"

term_config.terms = {
  -- ######################## 底部终端
  below_term = {
    default_winheight = 15,
    open = function()
      local term = term_config.terms.below_term
      local instance = term_utils.term_open(term, shell, function ()
        local default_winheight = term.default_winheight
        vim.cmd(string.format("%dsplit", default_winheight))
        local win_id = vim.api.nvim_get_current_win()
        local bufnr = term_utils.create_term_buf()
        vim.api.nvim_win_set_buf(win_id, bufnr)
        return bufnr, win_id
      end)
      instance.winheight = term.default_winheight
      buf_map("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Move cursor up", instance.bufnr)
      buf_map("t", "<M-4>", term.toggle, "Toggle below terminal", instance.bufnr)
      buf_map("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Move cursor left", instance.bufnr)
      buf_map("t", "<C-up>", [[<C-\><C-n><C-w>+i]], "Increase window size", instance.bufnr)
      buf_map("t", "<C-down>", [[<C-\><C-n><C-w>-i]], "Decrease window size", instance.bufnr)
    end,
    toggle = function()
      local term = term_config.terms.below_term
      term_utils.term_toggle(term,
        function (instance)
          vim.cmd(string.format("%dsplit | buffer %s", instance.winheight, instance.bufnr)) -- 显示
          instance.win_id = vim.api.nvim_get_current_win()
        end,
        function (instance)
          instance.winheight = vim.api.nvim_win_get_height(instance.win_id)
          vim.api.nvim_win_close(instance.win_id, true)
        end)
    end
  },

  -- ######################## 全屏终端
  full_term = {
    open = function ()
      local term = term_config.terms.full_term
      term.full_window = true
      local instance = term_utils.term_open(term, shell)
      buf_map("t", "<C-\\>", term.toggle, "Toggle terminal", instance.bufnr)
    end,
    toggle = function()
      local term = term_config.terms.full_term
      term_utils.term_toggle(term)
    end
  },
}

-- ######################## lazygit终端
vim.fn.system("lazygit --version")
if vim.v.shell_error == 0 then
  term_config.terms.lazygit_term = {
    open = function ()
      local term = term_config.terms.lazygit_term
      term.full_window = true
      local instance = term_utils.term_open(term, "lazygit")
      buf_map("t", "<M-6>", term.toggle, "Toggle lazygit", instance.bufnr)
    end,
    toggle = function()
      local term = term_config.terms.lazygit_term
      term_utils.term_toggle(term)
    end
  }
end

term_config.shell = shell

return term_config
