local M = {}

---@param mode string | table
---@param lhs string
---@param rhs string | function
---@param opts string | table
---封装vim.keymap.set方法，将最后一个参数修改为描述或options，参数详细描述参考原始方法
function M.map(mode, lhs, rhs, opts)
  local def_opts = { noremap = true, silent = true }
  if type(opts) == "string" then
    def_opts.desc = opts
  elseif type(opts) == "table" then
    def_opts = vim.tbl_extend("force", def_opts, opts)
  end
  vim.keymap.set(mode, lhs, rhs, def_opts)
end

---@param mode string | table
---@param lhs string
---@param rhs string | function
---@param opts string | table
---@param bufnr number buffer nunmber
---封装vim.keymap.set方法，添加buffer number只定义当前buffer内的快捷键
function M.buf_map(mode, lhs, rhs, opts, bufnr)
  bufnr = bufnr and tonumber(bufnr) or 0
  local def_opts = { buffer = bufnr }
  if type(opts) == "string" then
    def_opts.desc = opts
  elseif type(opts) == "table" then
    def_opts = vim.tbl_extend("force", def_opts, opts)
  end
  vim.keymap.set(mode, lhs, rhs, def_opts)
end


---@param mode string | table
---@param lhs string | table
---@param bufnr number
---封装vim.keymap.del方法，添加同时删除多个key的方式
function M.del_map(mode, lhs, bufnr)
  lhs = vim.fn.empty(lhs) == 0 and lhs or {}
  local opts = bufnr and {buffer = bufnr} or nil
  if type(lhs) == "string" then
    vim.keymap.del(mode, lhs, opts)
  elseif type(lhs) == "table" then
    for _, l in ipairs(lhs) do
      vim.keymap.del(mode, l, opts)
    end
  end
end

---@param mode string
---@param lhs string
---@param rhs string | function
---@param opts string | table
---@return table LazyKeysSpec lazy插件keys属性使用
--- 配合lazy.nvim插件使用
function M.lazy_map(mode, lhs, rhs, opts)
  local lazy_key = { lhs, rhs , mode = mode, noremap = true, silent = true}
  if type(opts) == "string" then
    lazy_key.desc = opts
  elseif type(opts) == "table" then
    lazy_key = vim.tbl_extend("force", lazy_key, opts)
  end
  return lazy_key
end

---@param lhs string
---@param rhs string | function
---@param opts string | table
---设置normal模式下快捷键
function M.nmap(lhs, rhs, opts) M.map("n", lhs, rhs, opts) end

---@param lhs string
---@param rhs string | function
---@param opts string | table
---设置visual模式下快捷键
function M.vmap(lhs, rhs, opts) M.map("v", lhs, rhs, opts) end

---@param lhs string
---@param rhs string | function
---@param opts string | table
---设置insert模式下快捷键
function M.imap(lhs, rhs, opts) M.map("i", lhs, rhs, opts) end

return M
