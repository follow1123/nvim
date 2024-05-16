if vim.fn.exists(":MarkdownPreviewToggle") == 2 then
  vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", {
    desc = "markdown: Markdown preview toggle",
    buffer = true
  })
end
