-- ###########################
-- #        command定义      #
-- ###########################

-- 格式化
vim.api.nvim_create_user_command("Format",
  function(opts)
    local clinets = vim.lsp.get_active_clients()
    -- 有lsp服务，参数为空则使用lsp服务的格式化操作，否则使用自定义格式化操作
    if #clinets ~= 0 and vim.fn.empty(opts.args) == 1 then
      vim.lsp.buf.format()
    else
      require("extensions.formatter").format(opts.args)
    end
  end,
  {
    desc = "Format file use external command",
    nargs = "?", -- 允许0或1个参数
    complete = function ()
      return { "json", "xml" }
    end
  }
)

-- 新打开终端
-- vim.api.nvim_create_user_command("TermNew", "lua require('extensions.terminal').new()", { desc = "New terminal" })

-- windows下保存管理员权限文件
if _G.IS_WINDOWS then
  vim.api.nvim_create_user_command("SudoSave", "lua require('extensions').sudo_save()", { desc = "save readonly file" })
end
