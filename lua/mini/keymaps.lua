-- ###########################
-- #        按键映射         #
-- ###########################

local keymap_util = require("mini.utils").keymap

local map = keymap_util.map
local nmap = keymap_util.nmap
local vmap = keymap_util.vmap
local imap = keymap_util.imap

-- 禁用翻页键
nmap("<C-f>", "<Nop>", "base: Disable pagedown key")
nmap("<C-b>", "<Nop>", "base: Disable pageup key")

-- 切换窗口
nmap("<C-h>", "<C-w>h", "base: Move cursor to left window")
nmap("<C-l>", "<C-w>l", "base: Move cursor to right window")
nmap("<C-j>", "<C-w>j", "base: Move cursor to above window")
nmap("<C-k>", "<C-w>k", "base: Move cursor to below window")

-- 设置窗口大小
nmap("<C-left>", "<C-w><", "base: Decrease window width")
nmap("<C-right>", "<C-w>>", "base: Increase window width")
nmap("<C-up>", "<C-w>-", "base: Decrease window height")
nmap("<C-down>", "<C-w>+", "base: Increase window height")

-- visual模式下tab        
vmap("<", "<gv", "base: Left tab")
vmap(">", ">gv", "base: Right tab")

-- buffer
nmap("<S-h>", "<cmd>bprevious<cr>", "base: Prev buffer")
nmap("<S-l>", "<cmd>bnext<cr>", "base: Next buffer")
nmap("[b", "<cmd>bprevious<cr>","base: Prev buffer")
nmap("]b", "<cmd>bnext<cr>", "base: Next buffer")

-- 切换两个buffer
nmap("<leader>bb", "<cmd>e #<cr>", "buffer: Switch to Other Buffer")
nmap("<leader>`", "<cmd>e #<cr>", "base: Switch to Other Buffer")
nmap("<C-Tab>", "<C-^>", "base: Switch to Other Buffer")

-- 搜索历史
nmap("n", "'Nn'[v:searchforward]", { expr = true, desc = "base: Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "base: Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "base: Next search result" })
nmap("N", "'nN'[v:searchforward]", { expr = true, desc = "base: Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "base: Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "base: Prev search result" })

-- visual line模式
nmap("<leader>v", "V", "base: Visual line mode")

-- 清除搜索的高亮文本
imap("<esc>", "<cmd>noh<cr><esc>", "base: Clear lighlight search")
nmap("<esc>", "<cmd>noh<cr><esc>", "base: Clear lighlight search")

-- Ctrl+s保存
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", "base: Save file")

-- 添加保存存档点
imap(",", ",<c-g>u", "base: Add undo break-points")
imap(".", ".<c-g>u", "base: Add undo break-points")
imap(";", ";<c-g>u", "base: Add undo break-points")

-- 上下移动选中的行
nmap("<M-j>", "<cmd>m .+1<cr>==", "base: Move up")
nmap("<M-k>", "<cmd>m .-2<cr>==", "base: Move down")
vmap("<M-j>", ":m '>+1<cr>gv=gv", "base: Move up")
vmap("<M-k>", ":m '<-2<cr>gv=gv", "base: Move down")

-- 翻页时保持光标居中
nmap("<C-d>", "<C-d>zz", "base: Scroll dowm and page center")
nmap("<C-u>", "<C-u>zz", "base: Scroll up and page center")

-- 搜索时保持光标居中
nmap("n", "nzz", "base: Search next and page center")
nmap("N", "Nzz", "base: Search previous and page center")

-- 快捷关闭窗口或Buffer
-- 如果当前窗口的buffer是共享的，则只关闭当前窗口，否则直接关闭当前的buffer
-- 如果当前buffer是最后一个listed的buffer则提示使用:q方式关闭
nmap("<M-q>", function ()
  local cur_bufnr = vim.api.nvim_get_current_buf()
  local listed_buf = vim.fn.getbufinfo({buflisted = 1})
  local is_listed_buf = false
  for _, buf in ipairs(listed_buf) do
    if buf.bufnr == cur_bufnr then
      --  如果当前窗口是listed的buffer，并且是Command Line窗口，或有共享当前buffer的窗口，则使用wincmd c关闭窗口
      if #buf.windows > 1 or string.match(buf.name, "Command Line") then
        vim.cmd("wincmd c")
        return
      else
        is_listed_buf = true
        break
      end
    end
  end
  -- 判断是否为listed的buffer
  if is_listed_buf then
    -- 判断listed的buffer的数量是否大于1
    if #listed_buf > 1 then
      vim.cmd("bdelete!")
    else
      -- 否则提示使用:q方式关闭
      vim.notify("is last buffer, use :q to exit vim", vim.log.levels.WARN)
    end
  -- 不是listed的buffer则使用关闭窗口的方式关闭
  else
    vim.cmd("wincmd c")
  end
end, "base: Close window or buffer")

nmap("<M-1>", "<cmd>lua require('mini.netrw').toggle()<cr>", "base: Open Netrw file manager")

nmap("<M-f>", ":find ", {
  desc = "base: Find files",
  silent = false
})


imap("<C-j>", "<C-n>", "") -- 修改补全弹窗的快捷键
imap("<C-k>", "<C-p>", "")
imap("<C-n>", "<Nop>", "") -- 进入insert模式下禁用
imap("<C-p>", "<Nop>", "")

nmap("<M-e>", "<cmd>lua require('mini.extensions.comment').toggle()<cr>", "base: Comment line")
vmap("<M-e>", "<cmd>lua require('mini.extensions.comment').visual_toggle()<cr>", "base: Comment line selected")
