local treesitter = {}

treesitter.has_parser = function(bufnr)
  local ok, _ = pcall(vim.treesitter.get_parser, bufnr)
  return ok
end

return treesitter
