-- command --------------------------------------------------------------------

vim.api.nvim_create_user_command("FormatJson", "1,$!jq", { desc = "Format json file" })
vim.api.nvim_create_user_command("FormatXml", "1,$!xmllint --format %", { desc = "Format xml file" })
