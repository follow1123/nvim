local keymap = {}

keymap.map = function(mode, lhs, rhs, opts)
  opts = vim.fn.empty(opts) == 0 and opts or nil
  local def_opts = { noremap = true, silent = true }
  if type(opts) == "string" then
    def_opts.desc = opts
  elseif type(opts) == "table" then
    def_opts = vim.tbl_extend("force", def_opts, opts)
  end
  vim.keymap.set(mode, lhs, rhs, def_opts)
end

keymap.buf_map = function(mode, lhs, rhs, opts, bufnr)
  opts = vim.fn.empty(opts) == 0 and opts or nil
  bufnr = bufnr and tonumber(bufnr) or 0
  local def_opts = { buffer = bufnr }
  if type(opts) == "string" then
    def_opts.desc = opts
  elseif type(opts) == "table" then
    def_opts = vim.tbl_extend("force", def_opts, opts)
  end
  vim.keymap.set(mode, lhs, rhs, def_opts)
end

keymap.del_map = function(mode, lhs, bufnr)
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

keymap.lazy_map = function(mode, lhs, rhs, opts)
  opts = vim.fn.empty(opts) == 0 and opts or nil
  local lazy_key = { lhs, rhs , mode = mode, noremap = true, silent = true}
  if type(opts) == "string" then
    lazy_key.desc = opts
  elseif type(opts) == "table" then
    lazy_key = vim.tbl_extend("force", lazy_key, opts)
  end
  return lazy_key
end

keymap.nmap = function(lhs, rhs, opts)
  keymap.map("n", lhs, rhs, opts)
end

keymap.vmap = function(lhs, rhs, opts)
  keymap.map("v", lhs, rhs, opts)
end

keymap.imap = function(lhs, rhs, opts)
  keymap.map("i", lhs, rhs, opts)
end


return keymap
