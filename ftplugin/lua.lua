local util = require("vim.lsp.util")
local ms = require("vim.lsp.protocol").Methods

local km = vim.keymap.set

local buf = vim.api.nvim_get_current_buf()
local auto_format_group = vim.api.nvim_create_augroup("go_auto_format_on_save:" .. buf, { clear = true })

-- 设置缩进样式
vim.bo[buf].tabstop = 2
vim.bo[buf].shiftwidth = 2
vim.bo[buf].expandtab = true

-- 设置直接运行代码快捷键
km("n", "<space>x", "<cmd>.lua<cr>", { desc = "lua: execute code", buffer = buf })
km("v", "<space>x", "<cmd>lua<cr>", { desc = "lua: execute selected code", buffer = buf })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = auto_format_group,
  buffer = buf,
  callback = function()
    -- 文件内容没有变更直接返回
    if not vim.api.nvim_get_option_value("modified", { buf = 0 }) then return end
    local clients = vim.lsp.get_clients({ bufnr = buf, name = "lua_ls" })
    if #clients == 0 then return end
    local lua_ls = clients[1]
    local method = ms.textDocument_formatting
    lua_ls.request(method, util.make_formatting_params(), function(...)
      local handler = lua_ls.handlers[method] or vim.lsp.handlers[method]
      handler(...)
      vim.cmd("silent! noautocmd w")
    end, buf)
  end
})
