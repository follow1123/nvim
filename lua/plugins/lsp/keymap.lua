local nmap = require("utils.keymap").nmap

local function telescope_code_action()
  require("telescope")
  vim.lsp.buf.code_action()
end

local function lsp_hover_and_focus()
  vim.lsp.buf.hover()
  vim.lsp.buf.hover()
end

local function lsp_async_format()
  vim.lsp.buf.format({ async = true })
end

local function diagnostic_open_and_focus()
  vim.diagnostic.open_float()
  vim.diagnostic.open_float()
end
return function(_, bufnr)
  -- 跳转
  nmap("gD", vim.lsp.buf.declaration, "LSP(builtin): goto declaration", bufnr)
  nmap("gd", "<cmd>Telescope lsp_definitions<cr>", "LSP(Telescope): goto definition", bufnr)
  nmap("gi", "<cmd>Telescope lsp_implementations<cr>", "LSP(Telescope): goto implementation", bufnr)
  nmap("gt", "<cmd>Telescope lsp_type_definitions<cr>", "LSP(Telescope): type definition", bufnr)
  nmap("<leader>li", "<cmd>Telescope lsp_incoming_calls<cr>", "LSP(Telescope): list which methods call this method",
    bufnr)
  nmap("<leader>lo", "<cmd>Telescope lsp_outgoing_calls<cr>",
    "LSP(Telescope): list which methods are called in this method", bufnr)
  nmap("gr", "<cmd>Telescope lsp_references<cr>", "LSP(builtin): show references", bufnr)

  -- 符号列表
  nmap("<M-2>", "<cmd>Telescope lsp_document_symbols<cr>", "LSP(custom): toggle document symbols", bufnr)
  nmap("<leader>ls", "<cmd>Telescope lsp_workspace_symbols<cr>", "LSP(Telescope): list workspace symbols", bufnr)

  -- 函数签名 打开函数签名文档并直接调转到文档窗口上
  nmap("K", lsp_hover_and_focus, "LSP(builtin): hover documentation", bufnr)
  -- 代码重构
  nmap("<F2>", vim.lsp.buf.rename, "LSP(builtin): rename", bufnr)
  nmap("<leader>lr", vim.lsp.buf.rename, "LSP(builtin): rename", bufnr)
  nmap("<M-Enter>", telescope_code_action, "LSP(builtin): code action", bufnr)
  nmap("<leader>la", telescope_code_action, "LSP(builtin): code action", bufnr)
  nmap("<leader>lf", lsp_async_format, "LSP(builtin): format code", bufnr)

  -- 代码诊断 显示代码诊断时，光标焦点在弹窗上
  nmap("<leader>lp", diagnostic_open_and_focus, "LSP(builtin): open diagnostic float window", bufnr)
  nmap("]d", vim.diagnostic.goto_next, "LSP(builtin): goto next diagnostic", bufnr)
  nmap("[d", vim.diagnostic.goto_prev, "LSP(builtin): goto previous diagnostic", bufnr)
  nmap("<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", "LSP(Telescope): list current buffer diagnostics", bufnr)
  nmap("<leader>lD", "<cmd>Telescope diagnostics<cr>", "LSP(Telescope): list workspace diagnostics ", bufnr)
end
