local nmap = require("utils.keymap").nmap
local vmap = require("utils.keymap").vmap

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

---@class custom.OrderedForeachOptions
---@field times integer
---@field order boolean true: asc by index, false desc by index. default: true

---comment
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
local function goto_reference(prev)
  ---@param opts vim.lsp.LocationOpts.OnList
  local function on_list(opts)
    local position = opts.context.params.position
    local uri = opts.context.params.textDocument.uri
    local items = opts.items

    local found = false

    ordered_foreach(items, function(item)
      local item_uri = item.user_data.uri

      if item_uri == uri then
        local range = item.user_data.range
        if found then
          vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
          return false
        end
        if position.line >= range.start.line and position.line <= range["end"].line and
            position.character >= range.start.character and position.character <= range["end"].character
        then
          found = true
        end
      end
      return true
    end, { times = 2, order = not prev })
  end
  vim.lsp.buf.references(nil, { on_list = on_list })
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

return function(_, bufnr)
  local doc_highlighter = DocumentHighlighter:new()
  doc_highlighter:init(bufnr)

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

  nmap("]r", function() goto_reference() end, "LSP(custom): goto next reference", bufnr)
  nmap("[r", function() goto_reference(true) end, "LSP(custom): goto previous reference", bufnr)

  nmap("]f", function() goto_function() end, "LSP(custom): goto next function or method", bufnr)
  nmap("[f", function() goto_function(true) end, "LSP(custom): goto previous function or method", bufnr)
  vmap("]f", function() goto_function() end, "LSP(custom): goto next function or method", bufnr)
  vmap("[f", function() goto_function(true) end, "LSP(custom): goto previous function or method", bufnr)

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
