return {
  "iamcco/markdown-preview.nvim",
  build = function() vim.fn["mkdp#util#install"]() end,
  ft = "markdown",
  init = function()
    if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
      vim.g.mkdp_browser = "explorer"
    elseif vim.fn.has("linux") == 1 then
      vim.g.mkdp_browser = "xdg-open"
    else
      error("Unsupported Platforms")
    end
    vim.g.mkdp_filetypes = { "markdown" }
    local group = vim.api.nvim_create_augroup("markdown_preview_keymap", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      desc = "set toggle markdown preview keymap",
      pattern = "markdown",
      group = group,
      callback = function(e)
        vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>",
          { desc = "markdown preview: Markdown preview toggle", buffer = e.buf })
      end
    })
  end
}
