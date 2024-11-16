vim.opt_local.signcolumn = "no"
-- netrw每打开一个目录时会创建一个buffer，在切换目录后将之前的buffer移除
vim.opt_local.bufhidden = "wipe"

-- 移动窗口键被netrw默认按键覆盖，重新设置
vim.keymap.set("n", "<c-l>", "<c-w>l", {
  noremap = true, silent = true, buffer = true,
  desc = "netrw: Move cursor to right window"
})
vim.keymap.set("n", "<c-[>", "<c-w>l", {
  noremap = true, silent = true, buffer = true,
  desc = "netrw: Move cursor to right window"
})

-- 文件浏览器切换到当前的工作目录
vim.keymap.set("n", "gw", "<cmd>e .<cr>", {
  noremap = true, silent = true, buffer = true,
  desc = "netrw: Go to current working directory"
})

-- 复制光标下文件的绝对路径
vim.keymap.set(
  "n", "yP",
  "<cmd>lua require('extensions.netrw-plus').copy_absolute_path()<cr>",
  {
    noremap = true, silent = true, buffer = true,
    desc = "netrw: Copy absolute path"
  }
)

-- 复制光标下文件的相对路径
vim.keymap.set(
  "n", "yp",
  "<cmd>lua require('extensions.netrw-plus').copy_relative_path()<cr>",
  {
    noremap = true, silent = true, buffer = true,
    desc = "netrw: Copy relative path"
  }
)

vim.keymap.set(
  "n", "<M-f>",
  function()
    local ok, tb = pcall(require, "telescope.builtin")
    if ok then
      tb.find_files({
        find_command = { "fd", "-t", "d" }
      })
    else
      vim.api.nvim_input(":find ")
    end
  end,
  {
    noremap = true, silent = true, buffer = true,
    desc = "netrw: Copy relative path"
  }
)
