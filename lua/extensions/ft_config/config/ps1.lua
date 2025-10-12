-- local group_id = vim.api.nvim_create_augroup("powershell_auto_format_on_save", { clear = false })
local group_name = "powershell_auto_format_on_save:"

---@type ext.ft_config.Config
return {
  setup = function(buf)
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup(group_name .. buf, { clear = true }),
      buffer = buf,
      once = true,
      callback = function()
        vim.lsp.buf.format()
      end
    })
  end,
  teardown = function()
    local autocmds = vim.api.nvim_get_autocmds({
      event = "BufWritePre"
    })

    for _, autocmd in ipairs(autocmds) do
      local is_current_autocmd = string.find(autocmd.group_name, group_name, 1, true) == 1
      if is_current_autocmd then
        vim.api.nvim_del_autocmd(autocmd.id)
      end
    end
  end
}
