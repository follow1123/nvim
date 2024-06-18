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
      cmp.complete()
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
    elseif luasnip.jumpable(1) or luasnip.jumpable(-1) then
      luasnip.unlink_current()
    else
      fallback()
    end
  end, {"i", "s"}),
  -- 确认补全或跳转代码片段
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then -- 如果不是代码片段，并且正在选择补全的时候直接确认第一个
      cmp.confirm(confirm_opts)
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end,
    {"i", "s"}),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, {"i", "s"}),
}
