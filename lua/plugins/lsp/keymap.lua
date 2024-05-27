return function(_, bufnr)
  local keymap_uitl = require("utils.keymap")
  local buf_map = keymap_uitl.buf_map

  -- 跳转
  buf_map(
    "n", "gD", vim.lsp.buf.declaration, "LSP(builtin): Goto Declaration", bufnr)
  buf_map(
    "n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>",
    "LSP(Telescope): Goto definition", bufnr)
  buf_map(
    "n", "gi",
    "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>",
    "LSP(Telescope): Goto implementation", bufnr)
  buf_map(
    "n", "gT",
    "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>",
    "LSP(Telescope): Type definition", bufnr)
  buf_map(
    "n", "gr", vim.lsp.buf.references, "LSP(builtin): Goto references", bufnr)
  -- 符号列表
  buf_map(
    "n", "<leader>ls",
    "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
    "LSP(Telescope): list document symbols", bufnr)
  buf_map(
    "n", "<leader>lS",
    "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>",
    "LSP(Telescope): list workspace symbols", bufnr)
  -- 函数签名 打开函数签名文档并直接调转到文档窗口上
  buf_map(
    "n", "K",
    function() vim.lsp.buf.hover() vim.lsp.buf.hover() end,
    "LSP(builtin): Hover documentation", bufnr)
  -- buf_map(
  --  "n", "<M-k>", vim.lsp.buf.signature_help,
  --  "LSP(builtin): Signature documentation", bufnr)
  -- 代码重构
  buf_map("n", "<F2>", vim.lsp.buf.rename, "LSP(builtin): Rename", bufnr)
  buf_map(
    "n", "<leader>lr", vim.lsp.buf.rename, "LSP(builtin): Rename", bufnr)
  buf_map(
    "n", "<M-Enter>", vim.lsp.buf.code_action,
    "LSP(builtin): Code action", bufnr)
  buf_map(
    "n", "<leader>ca", vim.lsp.buf.code_action,
    "LSP(builtin): Code action", bufnr)
  buf_map(
    "n", "<leader>cf",
    function() vim.lsp.buf.format({ async = true }) end,
    "LSP(builtin): Format code", bufnr)

  -- 代码诊断 显示代码诊断时，光标焦点在弹窗上
  buf_map(
    "n", "<leader>lp",
    function() vim.diagnostic.open_float() vim.diagnostic.open_float() end,
    "LSP(builtin): Open diagnostic float window", bufnr)
  buf_map(
    "n", "]d", vim.diagnostic.goto_next,
    "LSP(builtin): Goto next diagnostic", bufnr)
  buf_map(
    "n", "[d", vim.diagnostic.goto_prev,
    "LSP(builtin): Goto previous diagnostic", bufnr)
  buf_map(
    "n", "<leader>ld",
    "<cmd>lua require('telescope.builtin').diagnostics({ bufnr = 0 })<cr>",
    "LSP(Telescope): List current buffer diagnostics", bufnr)
  buf_map(
    "n", "<leader>lD",
    "<cmd>lua require('telescope.builtin').diagnostics()<cr>",
    "LSP(Telescope): List workspace diagnostics ", bufnr)
end
