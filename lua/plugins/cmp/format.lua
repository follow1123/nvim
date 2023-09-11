-- 补全类型图标
local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

-- 补全提示
local source_names = {
  nvim_lsp = "[LSP]",
  path = "[Path]",
  luasnip = "[Snippet]",
  buffer = "[Buffer]",
  nvim_lsp_signature_help = "[Param]",
}
local duplicates = {
  buffer = 1,
  path = 1,
  nvim_lsp = 0,
  luasnip = 1,
}
local duplicates_default = 0


-- 补全提示文本格式化，[类型图标] [补全名称] [类型]
local format = function(entry, vim_item)
  local max_width = 30
  if #vim_item.abbr > max_width then
    vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
  end
  vim_item.kind = kind_icons[vim_item.kind]
  vim_item.menu = source_names[entry.source.name]
  vim_item.dup = duplicates[entry.source.name]
  or duplicates_default
  return vim_item
end


return  {
  expandable_indicaotr = true,
  fields = { "kind", "abbr", "menu" },
  format = format
}
