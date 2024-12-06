return {
  "iamcco/markdown-preview.nvim",
  build = function() vim.fn["mkdp#util#install"]() end,
  ft = "markdown",
  init = function()
    vim.g.mkdp_browser = _G.IS_WINDOWS and "explorer" or "xdg-open"
    vim.g.mkdp_filetypes = { "markdown" }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      group = vim.api.nvim_create_augroup("MARKDOWN_PREVIEW_KEYMAP", { clear = true }),
      desc = "set toggle markdown preview keymap",
      callback = function(args)
        require("utils.keymap").nmap("<leader>mp", function()
          vim.cmd("MarkdownPreviewToggle")
        end, "markdown: Markdown preview toggle", args.buf)
      end

    })
  end
}
