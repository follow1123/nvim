local M = {}

local def_opts = { noremap = true, silent = true }

-- 合并 opts
---@param opts table|nil
---@param desc string
---@param bufnr? number
---@return table opts # keymap options
local function merge_opts(opts, desc, bufnr)
  opts = opts or {}
  opts = vim.tbl_extend("force", def_opts, opts)
  opts.desc = desc or "TODO need set keymap desc"
  if bufnr then opts.buffer = bufnr end
  return opts;
end

-- 封装vim.keymap.set方法
-- 将常用的选项单独作为参数传递
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param opts? table|nil
function M.map(mode, lhs, rhs, desc, bufnr, opts)
  vim.keymap.set(mode, lhs, rhs, merge_opts(opts, desc, bufnr))
end

-- 配合 lazy.nvim 插件使用
---@param mode string
---@param lhs string
---@param rhs string|function
---@param desc string
---@param opts? table|nil
---@return table LazyKeysSpec lazy 插件 keys 属性使用
function M.lazy_map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts = vim.tbl_extend("force", def_opts, opts)
  opts.desc = desc
  opts.mode = mode
  opts[1] = lhs
  opts[2] = rhs
  return opts
end

-- 配置 normal 模式下 keymap
---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param opts? table|nil
function M.nmap(lhs, rhs, desc, bufnr, opts)
  M.map("n", lhs, rhs, desc, bufnr, opts)
end

-- 配置 visual 模式下 keymap
---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param opts? table|nil
function M.vmap(lhs, rhs, desc, bufnr, opts)
  M.map("v", lhs, rhs, desc, bufnr, opts)
end

-- 配置 insert 模式下 keymap
---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param opts? table|nil
function M.imap(lhs, rhs, desc, bufnr, opts)
  M.map("i", lhs, rhs, desc, bufnr, opts)
end
--
-- 配置 command 模式下 keymap
---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param opts? table|nil
function M.cmap(lhs, rhs, desc, bufnr, opts)
  M.map("c", lhs, rhs, desc, bufnr, opts)
end

-- 配置 terminal 模式下 keymap
---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param opts? table|nil
function M.tmap(lhs, rhs, desc, bufnr, opts)
  M.map("t", lhs, rhs, desc, bufnr, opts)
end

return M
