local nmap = require("utils.keymap").nmap
return function(_, bufnr)
  -- 跳转
  nmap("gD", vim.lsp.buf.declaration, "LSP(builtin): Goto Declaration", bufnr)
  nmap("gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "LSP(Telescope): Goto definition", bufnr)
  nmap("gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", "LSP(Telescope): Goto implementation", bufnr)
  nmap("gt", "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", "LSP(Telescope): Type definition", bufnr)
  nmap("gr", "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "LSP(builtin): Goto references", bufnr)
  -- 符号列表
  nmap("<leader>ls", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "LSP(Telescope): list document symbols", bufnr)
  nmap("<leader>lS", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", "LSP(Telescope): list workspace symbols", bufnr)
  -- 函数签名 打开函数签名文档并直接调转到文档窗口上
  nmap("K", function() vim.lsp.buf.hover() vim.lsp.buf.hover() end, "LSP(builtin): Hover documentation", bufnr)
  -- 代码重构
  nmap("<F2>", vim.lsp.buf.rename, "LSP(builtin): Rename", bufnr)
  nmap("<leader>lr", vim.lsp.buf.rename, "LSP(builtin): Rename", bufnr)
  nmap("<M-Enter>", vim.lsp.buf.code_action, "LSP(builtin): Code action", bufnr)
  nmap("<leader>ca", vim.lsp.buf.code_action, "LSP(builtin): Code action", bufnr)
  nmap("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "LSP(builtin): Format code", bufnr)

  -- 代码诊断 显示代码诊断时，光标焦点在弹窗上
  nmap("<leader>lp", function() vim.diagnostic.open_float() vim.diagnostic.open_float() end, "LSP(builtin): Open diagnostic float window", bufnr)
  nmap("]d", vim.diagnostic.goto_next, "LSP(builtin): Goto next diagnostic", bufnr)
  nmap("[d", vim.diagnostic.goto_prev, "LSP(builtin): Goto previous diagnostic", bufnr)
  nmap("<leader>ld", "<cmd>lua require('telescope.builtin').diagnostics({ bufnr = 0 })<cr>", "LSP(Telescope): List current buffer diagnostics", bufnr)
  nmap("<leader>lD", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "LSP(Telescope): List workspace diagnostics ", bufnr)
end
