local cmp = require("cmp")
local luasnip = require("luasnip")

-- 确认补全是的配置
local confirm_opts = {
  select = true,                         -- 没有选中补全项时，默认选择第一个
  behavior = cmp.ConfirmBehavior.Insert, -- 补全时插入文本不替换后面的文本
}
-- 选择时默认不补全
local select_item_opts = { behavior = cmp.SelectBehavior.Select }

return {
  ["<C-n>"] = cmp.mapping(function()
    if cmp.visible() then
      cmp.select_next_item(select_item_opts) -- 下一个
    end
  end),
  ["<C-p>"] = cmp.mapping(function()
    if cmp.visible() then
      cmp.select_prev_item(select_item_opts) -- 上一个
    end
  end),
  ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- 文档向上滚动
  ["<C-d>"] = cmp.mapping.scroll_docs(4), -- 文件向下滚动
  ["<CR>"] = cmp.mapping.confirm(confirm_opts), -- 完成补全
  ["<C-k>"] = cmp.mapping(function() -- 开启补全或开关文档窗口
    if not cmp.visible() then
      local sources = {}
      local rows, cols = unpack(vim.api.nvim_win_get_cursor(0))
      rows = rows == 0 and rows or rows - 1
      cols = cols == 0 and cols or cols - 1
      -- 指定方法调用块在不同语言的类型
      local node_type = {}
      if vim.o.filetype == "lua" then
        table.insert(node_type, "function_call")
      elseif vim.o.filetype == "rust" then
        table.insert(node_type, "call_expression")
      end
      -- 如果在方法调用块内就显示方法参数签名补全信息，否则显示其他lsp的补全信息
      local node = vim.treesitter.get_node({ pos = { rows, cols } })
      if node and node:parent() and vim.tbl_contains(node_type, node:parent():type()) then
        table.insert(sources, { name = "nvim_lsp_signature_help" })
      else
        table.insert(sources, { name = "nvim_lsp" })
      end

      -- 只有当前行是空行的情况下才显示代码片段补全信息
      local text = vim.api.nvim_get_current_line()
      if text ~= nil and #vim.trim(text) == 0 then
        table.insert(sources, { name = "luasnip" })
      end
      cmp.complete({ config = { sources = sources } })
      return
    end
    if cmp.visible_docs() then
      cmp.close_docs()
    else
      cmp.open_docs()
    end
  end),
  ["<C-c>"] = cmp.mapping(function(fallback) -- 打断补全或打断代码片段跳转
    if cmp.visible() then
      cmp.abort()
    elseif luasnip.jumpable() then
      luasnip.unlink_current()
    else
      fallback()
    end
  end, {"i", "s"}),
  -- 确认补全或跳转代码片段
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.confirm(confirm_opts)
    elseif luasnip.locally_jumpable(1) then
      luasnip.jump(1)
    else
      fallback()
    end
  end,
    {"i", "s"}),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, {"i", "s"}),
}
