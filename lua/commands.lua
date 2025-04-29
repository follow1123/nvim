-- command --------------------------------------------------------------------

vim.api.nvim_create_user_command("FormatJson", "1,$!jq", { desc = "Format json file" })
vim.api.nvim_create_user_command("FormatXml", "1,$!xmllint --format %", { desc = "Format xml file" })
vim.api.nvim_create_user_command("PrettierFormat", function()
  local cmd = vim.fn.exepath("prettier")
  if vim.fn.empty(cmd) == 1 then
    return
  end
  vim.cmd("silent !" .. cmd .. " % -w")
  vim.cmd.edit({ bang = true })
end, { desc = "use prettier format files" })
