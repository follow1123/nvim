local util = require("vim.lsp.util")
local ms = require("vim.lsp.protocol").Methods

local km = vim.keymap.set

local group_name = "lua_auto_format_on_save:"

---@type ext.ft_config.Config
return {
  setup = function(buf)
    -- 设置缩进样式
    vim.bo[buf].tabstop = 2
    vim.bo[buf].shiftwidth = 2
    vim.bo[buf].expandtab = true

    -- 设置直接运行代码快捷键
    km("n", "<space>x", "<cmd>.lua<cr>", { desc = "lua: execute code", buffer = buf })
    km("v", "<space>x", ":lua<cr>", { desc = "lua: execute selected code", buffer = buf })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup(group_name .. buf, { clear = true }),
      buffer = buf,
      callback = function()
        -- 文件内容没有变更直接返回
        if not vim.api.nvim_get_option_value("modified", { buf = 0 }) then return end
        local clients = vim.lsp.get_clients({ bufnr = buf, name = "lua_ls" })
        if #clients == 0 then return end
        local lua_ls = clients[1]
        local method = ms.textDocument_formatting
        lua_ls:request(method, util.make_formatting_params(), function(...)
          local handler = lua_ls.handlers[method] or vim.lsp.handlers[method]
          handler(...)
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! noautocmd w")
          end)
        end, buf)
      end
    })
  end,
  teardown = function(buf)
    vim.keymap.del({ "n", "v" }, "<space>x", { buffer = buf })
    -- vim.api.nvim_del_augroup_by_id(group_id)
  end
}
