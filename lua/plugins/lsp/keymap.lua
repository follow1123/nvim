-- 按键映射
local function lsp_keymap(bufnr)
  local keymap_uitl = require("utils.keymap")
  local buf_map = keymap_uitl.buf_map

  -- 符号跳转
  buf_map("n", "gD", vim.lsp.buf.declaration, "LSP: Goto Declaration", bufnr)
  buf_map("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "LSP: Goto definition", bufnr)
  buf_map("n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", "LSP: Goto implementation", bufnr)
  buf_map("n", "gT", "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", "LSP: Type definition", bufnr)
  buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "LSP: Goto references", bufnr)

  -- 符号列表
  buf_map("n", "<leader>ls", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "LSP: list document symbols", bufnr)
  buf_map("n", "<leader>lS", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", "LSP: list workspace symbols", bufnr)

  -- 函数签名
  buf_map("n", "K", function () -- 打开函数签名文档并直接调转到文档窗口上
    vim.lsp.buf.hover() -- 这个函数的说明是调用两次会跳转到文档窗口上，我这里直接调用两遍
    vim.lsp.buf.hover()
  end, "LSP: Hover documentation", bufnr)
  -- buf_map("n", "<M-k>", vim.lsp.buf.signature_help, "LSP: Signature documentation", bufnr)

  -- lsp工作区
  -- buf_map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, "LSP: Workspace add folder", bufnr)
  -- buf_map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "LSP: Workspace remove folder", bufnr)
  -- buf_map("n", "<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP: Workspace list folders", bufnr)

  -- 代码重构
  buf_map("n", "<F2>", vim.lsp.buf.rename, "LSP: Rename", bufnr)
  buf_map("n", "<leader>lr", vim.lsp.buf.rename, "LSP: Rename", bufnr)
  buf_map("n", "<M-Enter>", vim.lsp.buf.code_action, "LSP: Code action", bufnr)
  buf_map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action", bufnr)
  buf_map("n", "<leader>cf", function() vim.lsp.buf.format { async = true } end, "LSP: Format code", bufnr)

  -- 代码诊断
  buf_map("n", "<leader>lp", function () -- 显示代码诊断时，光标焦点在弹窗上
    vim.diagnostic.open_float()
    vim.diagnostic.open_float()
  end, "LSP: Open diagnostic float window", bufnr)
  buf_map("n", "]d", vim.diagnostic.goto_next, "LSP: Goto next diagnostic", bufnr)
  buf_map("n", "[d", vim.diagnostic.goto_prev, "LSP: Goto previous diagnostic", bufnr)
  buf_map("n", "<leader>ld", "<cmd>lua require('telescope.builtin').diagnostics({ bufnr = 0 })<cr>", "LSP: List current buffer diagnostics", bufnr)
  buf_map("n", "<leader>lD", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "LSP: List workspace diagnostics ", bufnr)
end

return {
  setup = lsp_keymap
}
