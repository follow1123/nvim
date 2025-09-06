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

---@param next boolean
---@return fun()
local function lsp_diagnostic_nav(next)
  if next then
    return function()
      vim.diagnostic.jump({ count = 1, float = true })
    end
  else
    return function()
      vim.diagnostic.jump({ count = -1, float = true })
    end
  end
end

---@class custom.OrderedForeachOptions
---@field times integer
---@field order boolean true: asc by index, false desc by index. default: true

---@generic T : any
---@param list T[]
---@param callback fun(T, integer): boolean
---@param opts custom.OrderedForeachOptions
local function ordered_foreach(list, callback, opts)
  if #list == 0 then return end
  opts = opts or {}
  local times = opts.times or 1
  local order = opts.order == nil and true or opts.order
  local len = #list
  local idx = order and 1 or len * times
  local stop = order and len * times or 1
  local step = order and 1 or -1
  local cur_times = 1
  for i = idx, stop, step do
    cur_times = math.floor((i + len - 1) / len)
    if not order then
      cur_times = times - cur_times + 1
    end
    local idx_mod = i % len
    local index = idx_mod == 0 and len or idx_mod
    if not callback(list[index], cur_times) then
      return
    end
  end
end

---@param prev? boolean
local function goto_function(prev)
  ---@param opts vim.lsp.LocationOpts.OnList
  local function on_list(opts)
    local items = opts.items

    ordered_foreach(items, function(item, cur_times)
      if item.kind == "Function" or item.kind == "Method" then
        if cur_times == 2 then
          vim.api.nvim_win_set_cursor(0, { item.lnum, item.col })
          return false
        end
        local cur_line_num = vim.api.nvim_win_get_cursor(0)[1]
        if (not prev and cur_line_num < item.lnum) or
            (prev and cur_line_num > item.lnum)
        then
          vim.api.nvim_win_set_cursor(0, { item.lnum, item.col })
          return false
        end
      end
      return true
    end, { times = 2, order = not prev })
  end
  vim.lsp.buf.document_symbol({ on_list = on_list })
end

---@class plugins.lsp.DocumentHighlighter
---@field highlighted boolean
local DocumentHighlighter = {}

DocumentHighlighter.__index = DocumentHighlighter

function DocumentHighlighter:new()
  return setmetatable({ highlighted = false }, self)
end

function DocumentHighlighter:highlight()
  vim.lsp.buf.document_highlight()
  self.highlighted = true
end

function DocumentHighlighter:clear()
  if self.highlighted then
    vim.lsp.buf.clear_references() -- 清除 LSP 高亮
    self.highlighted = false
  end
end

---@param bufnr integer
function DocumentHighlighter:init(bufnr)
  local highlight_group = vim.api.nvim_create_augroup("document_highlighter:" .. bufnr, { clear = true })
  -- 高亮光标下符号的引用
  vim.api.nvim_create_autocmd("CursorHold", {
    desc = "highlight references when cursor hold",
    group = highlight_group,
    buffer = bufnr,
    callback = function()
      self:highlight()
    end,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged" }, {
    desc = "clear highlight references when cursor moved or mode changed",
    group = highlight_group,
    buffer = bufnr,
    callback = function()
      self:clear()
    end,
  })
end

return function(_, buf)
  local km = vim.keymap.set
  local doc_highlighter = DocumentHighlighter:new()
  doc_highlighter:init(buf)


  -- 跳转
  km("n", "gD", vim.lsp.buf.declaration, { desc = "LSP(builtin): goto declaration", buffer = buf })
  km("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "LSP(Telescope): goto definition", buffer = buf })
  km("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "LSP(Telescope): goto implementation", buffer = buf })
  km("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "LSP(Telescope): type definition", buffer = buf })
  km("n", "<leader>li", "<cmd>Telescope lsp_incoming_calls<cr>",
    { desc = "LSP(Telescope): list which methods call this method", buffer = buf })
  km("n", "<leader>lo", "<cmd>Telescope lsp_outgoing_calls<cr>",
    { desc = "LSP(Telescope): list which methods are called in this method", buffer = buf })
  km("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "LSP(builtin): show references", buffer = buf })

  km({ "n", "v" }, "]f", function() goto_function() end,
    { desc = "LSP(custom): goto next function or method", buffer = buf })
  km({ "n", "v" }, "[f", function() goto_function(true) end,
    { desc = "LSP(custom): goto previous function or method", buffer = buf })

  -- 符号列表
  km("n", "<M-2>", "<cmd>Telescope lsp_document_symbols<cr>",
    { desc = "LSP(custom): toggle document symbols", buffer = buf })
  km("n", "<leader>ls", "<cmd>Telescope lsp_workspace_symbols<cr>",
    { desc = "LSP(Telescope): list workspace symbols", buffer = buf })

  -- 函数签名 打开函数签名文档并直接调转到文档窗口上
  km("n", "K", lsp_hover_and_focus, { desc = "LSP(builtin): hover documentation", buffer = buf })
  -- 代码重构
  km("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP(builtin): rename", buffer = buf })
  km("n", "<M-Enter>", telescope_code_action, { desc = "LSP(builtin): code action", buffer = buf })
  km("n", "<leader>lf", lsp_async_format, { desc = "LSP(builtin): format code", buffer = buf })

  -- 代码诊断 显示代码诊断时，光标焦点在弹窗上
  km("n", "]d", lsp_diagnostic_nav(true), { desc = "LSP(builtin): goto next diagnostic", buffer = buf })
  km("n", "[d", lsp_diagnostic_nav(false), { desc = "LSP(builtin): goto previous diagnostic", buffer = buf })
  km("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>",
    { desc = "LSP(Telescope): list current buffer diagnostics", buffer = buf })
  km("n", "<leader>lD", "<cmd>Telescope diagnostics<cr>",
    { desc = "LSP(Telescope): list workspace diagnostics", buffer = buf })
end
