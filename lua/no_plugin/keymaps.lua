--#############################################################################
--#                                                                           #
--#                                   keymap                                  #
--#                                                                           #
--#############################################################################

local function map(mode, lhs, rhs, opts)
  opts = vim.fn.empty(opts) == 0 and opts or nil
  local def_opts = { noremap = true, silent = true }
  if type(opts) == "string" then
    def_opts.desc = opts
  elseif type(opts) == "table" then
    def_opts = vim.tbl_extend("force", def_opts, opts)
  end
  vim.keymap.set(mode, lhs, rhs, def_opts)
end

local function nmap(lhs, rhs, opts) map("n", lhs, rhs, opts) end

local function vmap(lhs, rhs, opts) map("v", lhs, rhs, opts) end

local function imap(lhs, rhs, opts) map("i", lhs, rhs, opts) end

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

-- 搜索历史
nmap("n", "'Nn'[v:searchforward]", { expr = true, desc = "base: Next search result" })
nmap("N", "'nN'[v:searchforward]", { expr = true, desc = "base: Prev search result" })

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
vmap("<M-j>", function() return vim.bo.modifiable and ":m '>+1<cr>gv=gv" or "<Ignore>" end, { expr = true, desc = "base: Move down" })
vmap("<M-k>", function() return vim.bo.modifiable and ":m '<-2<cr>gv=gv" or "<Ignore>" end, { expr = true, desc = "base: Move up" })

-- 翻页时保持光标居中
nmap("<C-d>", "<C-d>zz", "base: Scroll dowm and page center")
nmap("<C-u>", "<C-u>zz", "base: Scroll up and page center")

-- 搜索时保持光标居中
nmap("n", "nzz", "base: Search next and page center")
nmap("N", "Nzz", "base: Search previous and page center")

-- quickfix list
nmap("[q", "<cmd>cprevious<cr>zz", "base: Prev quickfix")
nmap("]q", "<cmd>cnext<cr>zz", "base: Next quickfix")

nmap("<M-`>", "<C-^>", "base: Toggle switch buffer")

nmap("<M-q>", "<cmd>lua require('extensions').smart_quit()<cr>", "base: Close window or buffer")

nmap("<M-1>", "<cmd>lua require('no_plugin.netrw').toggle()<cr>", "base: Open Netrw file manager")

nmap("<M-f>", ":find ", { desc = "base: Find files", silent = false })

imap("<C-j>", "<C-n>", "") -- 修改补全弹窗的快捷键
imap("<C-k>", "<C-p>", "")
imap("<C-n>", "<Nop>", "") -- 进入insert模式下禁用
imap("<C-p>", "<Nop>", "")

map("c", "<C-a>", function() vim.api.nvim_input("<Home>") end, "emacs keymap")
map("c", "<C-e>", function() vim.api.nvim_input("<End>") end, "emacs keymap")
map("c", "<C-f>", function() vim.api.nvim_input("<Right>") end, "emacs keymap")
map("c", "<C-b>", function() vim.api.nvim_input("<Left>") end, "emacs keymap")
map("c", "<M-f>", function() vim.api.nvim_input("<C-Right>") end, "emacs keymap")
map("c", "<M-b>", function() vim.api.nvim_input("<C-Left>") end, "emacs keymap")

-- 自定义扩展功能
-- 注释
nmap("<M-e>", "<cmd>lua require('extensions.comment').toggle()<cr>", "base: Comment line")
vmap("<M-e>", "<cmd>lua require('extensions.comment').visual_toggle()<cr>", "base: Comment line selected")

-- 终端
nmap("<M-4>", "<cmd>lua require('extensions.terminal').split_term:toggle()<cr>", "base: Open split terminal")
nmap("<C-\\>", "<cmd>lua require('extensions.terminal').full_term:toggle()<cr>", "base: Open full terminal")
nmap("<M-6>", "<cmd>lua require('extensions.terminal').lazygit_term:toggle()<cr>", "base: Open lazygit terminal")
