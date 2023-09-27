local keymap_util = require("utils.keymap")
local buf_map = keymap_util.buf_map

local term_utils = require("extensions.terminal.utils")

local term_config = {}

local shell = _G.IS_WINDOWS and "pwsh" or "zsh"

term_config.terms = {
  -- ######################## 底部终端
  below_term = {
    default_winheight = 15,
    -- 如果nvim-tree窗口是打开的情况下则还原nvim-tree窗口到最左边
    reset_nvim_tree = function()
      local visible_wins = vim.api.nvim_list_wins()
      for _, win_id in ipairs(visible_wins) do
        local bufnr = vim.api.nvim_win_get_buf(win_id)
        local win_width = vim.api.nvim_win_get_width(win_id)
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if filetype == "NvimTree" then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("wincmd H")
            vim.api.nvim_win_set_width(win_id, win_width)
          end)
          break
        end
      end
    end,
    -- 判断当前终端是否打开
    is_open = function()
      local instance = term_config.terms.below_term.instance
      return instance and vim.api.nvim_win_is_valid(instance.win_id)
    end,
    open = function()
      local term = term_config.terms.below_term
      local open_win_id = vim.api.nvim_get_current_win()
      local instance = term_utils.term_open(term, shell, function () -- 打开终端操作
        local default_winheight = term.default_winheight
        vim.cmd(string.format("botright %dsplit", default_winheight))
        local win_id = vim.api.nvim_get_current_win()
        local bufnr = term_utils.create_term_buf()
        vim.api.nvim_win_set_buf(win_id, bufnr)
        term.reset_nvim_tree()
        return bufnr, win_id
      end, function () -- 终端关闭时的操作
          if vim.api.nvim_win_is_valid(term.instance.open_win_id) then
            vim.fn.win_gotoid(term.instance.open_win_id)
          end
          vim.api.nvim_buf_delete(term.instance.bufnr, { force = true })
          term.instance = nil
      end)
      -- 打开的窗口
      instance.open_win_id = open_win_id
      -- 窗口的高度
      instance.winheight = term.default_winheight
      buf_map("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Move cursor up", instance.bufnr)
      buf_map("t", "<M-4>", term.toggle, "Toggle below terminal", instance.bufnr)
      buf_map("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Move cursor left", instance.bufnr)
      buf_map("t", "<C-up>", [[<C-\><C-n><C-w>+i]], "Increase window size", instance.bufnr)
      buf_map("t", "<C-down>", [[<C-\><C-n><C-w>-i]], "Decrease window size", instance.bufnr)
    end,
    toggle = function()
      local term = term_config.terms.below_term
      local instance = term.instance

      -- 不存在buffer则直接打开
      if not instance or not vim.api.nvim_buf_is_valid(instance.bufnr) then
        term.open()
        return
      end
      -- 当前buffer不是term buffer则切换到term buffer
      if not vim.api.nvim_win_is_valid(instance.win_id) then
        local open_win_id = vim.api.nvim_get_current_win()
        vim.cmd(string.format("botright %dsplit | buffer %s", instance.winheight, instance.bufnr)) -- 显示
        instance.win_id = vim.api.nvim_get_current_win()
        instance.open_win_id = open_win_id
        term.reset_nvim_tree()
      else
        -- 保存当前窗口高度
        instance.winheight = vim.api.nvim_win_get_height(instance.win_id)
        -- 还原到打开时的窗口
        if vim.api.nvim_win_is_valid(term.instance.open_win_id) then
          vim.fn.win_gotoid(term.instance.open_win_id)
        end
        vim.api.nvim_win_close(instance.win_id, true)
      end
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
