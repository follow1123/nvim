-- 补全提示
local source_names = {
  nvim_lsp = "[LSP]",
  luasnip = "[Snippet]",
  nvim_lsp_signature_help = "[Param]",
  lazydev = "[NvimDev]"
}
local duplicates = {
  nvim_lsp = 0,
  luasnip = 1,
}

local duplicates_default = 0

local max_width = 30

return {
  expandable_indicaotr = true,
  fields = { "abbr", "kind", "menu" },
  -- 补全提示文本格式化，[类型图标] [补全名称] [类型]
  format = function(entry, vim_item)
    if #vim_item.abbr > max_width then
      vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
    end
    vim_item.kind = vim_item.kind
    vim_item.menu = source_names[entry.source.name]
    vim_item.dup = duplicates[entry.source.name]
    or duplicates_default
    return vim_item
  end
}
