-- ###########################
-- #        终端插件         #
-- ###########################
local keymap_util = require("utils.keymap")
local buf_map = keymap_util.buf_map
local term_config = require("extensions.terminal.config")
local shell = term_config.shell
local terms = term_config.terms

local terminal = {}

-- 打开终端
terminal.toggle = function(term_name)
  local term = terms[term_name]
  if term then
    term.toggle()
  else
    vim.notify(string.format("no '%s' terminal", term_name), vim.log.levels.WARN)
  end
end

-- 发送消息
terminal.send_msg = function (term_name, msg)
  local term = terms[term_name]
  local instance = term.instance
  if instance and instance.term_id then
    if type(msg) == "string" then
      msg = {msg}
    end
    for _, m in ipairs(msg) do
      vim.api.nvim_chan_send(instance.term_id, m)
    end
  end
end

-- ######################## 终端事件
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*" .. shell,
  callback = function(t)
    buf_map("t", "<Esc>", [[<C-\><C-n>]], "Quit terminal mode", t.buf)
  end
})

vim.api.nvim_create_autocmd({"WinEnter", "BufWinEnter"}, {
  pattern = {"term://*" .. shell, "term://*lazygit"},
  command = "startinsert!"
})

return terminal
