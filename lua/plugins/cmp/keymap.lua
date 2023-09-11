local cmp = require("cmp")
local luasnip = require("luasnip")

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end
-- 确认补全是的配置
local confirm_opts = {
  select = true,                         -- 没有选中补全项时，默认选择第一个
  behavior = cmp.ConfirmBehavior.Insert, -- 补全时插入文本不替换后面的文本
}
-- 补全选择时默认配置
local select_item_opts = {
  behavior = cmp.SelectBehavior.Select -- 选择时默认不补全，只显示虚拟文本
}


local insert_keymap = {
  ["<C-j>"] = {i = cmp.mapping.select_next_item(select_item_opts)}, -- 下一个
  ["<C-k>"] = {i = cmp.mapping.select_prev_item(select_item_opts)}, -- 上一个
  ["<C-u>"] = {i = cmp.mapping.scroll_docs(-4)}, -- 文档向上滚动
  ["<C-d>"] = {i = cmp.mapping.scroll_docs(4)}, -- 文件向下滚动
  ["<C-p>"] = {i = cmp.mapping.complete()}, -- 打开补全弹框
  ["<C-c>"] = cmp.mapping(function(fallback)  -- 打断补全或打断代码片段跳转
    if cmp.visible() then
      cmp.mapping.abort()()
    elseif luasnip.jumpable(1) or luasnip.jumpable(-1) then
      luasnip.unlink_current()
    else
      fallback()
    end
  end, {"i", "s"}),
  ["<CR>"] = {i = cmp.mapping.confirm(confirm_opts)}, -- 完成补全
  -- 确认补全或跳转代码片段
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then -- 如果不是代码片段，并且正在选择补全的时候直接确认第一个
      cmp.mapping.confirm(confirm_opts)()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif check_backspace() then
      fallback()
    else
      fallback()
    end
  end,
  {"i", "s"}),
  -- shift tab
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, {"i", "s"}),
  ["<M-d>"] = {
    i = function() -- 文档弹窗开关
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end
  }
}

local cmdline_keymap = cmp.mapping.preset.cmdline{
  ["<C-n>"] = {c = function() vim.api.nvim_input("<Down>") end}, -- 历史记录上一个
  ["<C-p>"] = {c = function() vim.api.nvim_input("<Up>") end}, -- 历史记录下一个
  ["<C-j>"] = {c = cmp.mapping.select_next_item(select_item_opts)}, -- 下一个
  ["<C-k>"] = {c = cmp.mapping.select_prev_item(select_item_opts)}, -- 上一个
  ["<C-c>"] = {c = cmp.mapping.abort()}, -- 打断补全

  -- emacs方式移动快捷键
  ["<C-a>"] = {c = function() vim.api.nvim_input("<Home>") end},
  ["<C-e>"] = {c = function() vim.api.nvim_input("<End>") end},
  ["<C-f>"] = {c = function() vim.api.nvim_input("<Right>") end},
  ["<C-b>"] = {c = function() vim.api.nvim_input("<Left>") end},
  ["<M-f>"] = {c = function() vim.api.nvim_input("<C-Right>") end},
  ["<M-b>"] = {c = function() vim.api.nvim_input("<C-Left>") end},

  ["<Tab>"] = {c = function()
    if cmp.visible() then -- 补全弹框打开时，确认选中的补全
      cmp.mapping.confirm(confirm_opts)()
    else -- 补全弹框关闭时，打开补全弹框
      cmp.mapping.complete()()
    end
  end},
  ["<S-Tab>"] = {c = function () end} -- 禁用向上选择的功能
}

return {
  insert = cmp.mapping.preset.insert(insert_keymap),
  cmdline = cmp.mapping.preset.cmdline(cmdline_keymap),
}
