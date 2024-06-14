vim.keymap.set("n", "<leader>mp",
  function()
    if vim.fn.exists(":MarkdownPreviewToggle") == 2 then
      vim.cmd("MarkdownPreviewToggle")
    end
  end,
  { desc = "markdown: Markdown preview toggle", buffer = true }
)
