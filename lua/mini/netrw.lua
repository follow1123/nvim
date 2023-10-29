-- ###########################
-- #       目录树(netrw)     #
-- ###########################
local netrw = {}

vim.g.netrw_liststyle = 3                     -- 设置文件管理模式为tree模式
vim.g.netrw_winsize = 20                       -- 设置文件管理器打开时默认的宽度
vim.g.netrw_banner = 0                        -- 不显示顶部的信息
vim.g.netrw_browse_split = 4                  -- 默认在上一个窗口打开文件(同一个窗口)
vim.g.netrw_altv = 1
vim.g.netrw_preview = 1


vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local netrw_keymap_opt = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(0, "n", "<C-l>", "<C-w>l", netrw_keymap_opt) -- 设置ctrl+l移动窗口
    vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "<Plug>NetrwLocalBrowseCheck", netrw_keymap_opt) -- tab打开或关闭目录树
  end
})

netrw.toggle = function()
  -- 目录树打开时直接获取焦点
  local visible_wins = vim.api.nvim_list_wins()
  local cur_win_id = vim.api.nvim_get_current_win()
  local has_netrw = false
  local tree_win_id
  for _, win_id in ipairs(visible_wins) do
    local ft = vim.api.nvim_get_option_value("filetype", {
      win = win_id
    })
    if ft == "netrw" then
      has_netrw = true
      tree_win_id = win_id
      break
    end
  end
  if not has_netrw then
    vim.cmd(":Lex")
    return
  end
  if cur_win_id == tree_win_id then
    vim.cmd(":Lex")
  else
    vim.fn.win_gotoid(tree_win_id)
  end
end

return netrw
