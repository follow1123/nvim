-- ###########################
-- #        command定义      #
-- ###########################

-- 新打开终端
vim.api.nvim_create_user_command("TermNew", "lua require('extensions.terminal').new()", { desc = "New terminal" })

-- windows下保存管理员权限文件
if _G.IS_WINDOWS then
  vim.api.nvim_create_user_command("SudoSave", "lua require('extensions').sudo_save()", { desc = "save readonly file" })
end

-- 格式化
vim.api.nvim_create_user_command("Format",
  function(opts)
    require("extensions.formatter").format(opts.args)
  end,
  {
    desc = "Format file use external command",
    nargs = "?", -- 允许0或1个参数
    complete = function ()
      return { "json", "xml" }
    end
  }
)

