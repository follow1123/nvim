return function(e)
  local nmap = require("utils.keymap").nmap
  -- netrw 每打开一个目录都会创建一个 buffer
  -- 在打开目录后将之前的 buffer 移除
  vim.opt_local.bufhidden = "wipe"

  -- 文件浏览器切换到当前的工作目录
  nmap("gw", "<cmd>e .<cr>", "netrw: Go to current working directory", e.buf)
  nmap("<C-h>", "<C-w>h", "netrw: Go to left window", e.buf)
  nmap("<C-l>", "<C-w>l", "netrw: Go to right window", e.buf)
  -- 复制光标下文件的绝对路径
  nmap("yP", "<cmd>lua require('extensions.netrw-plus.util').copy_absolute_path()<cr>", "netrw: Copy absolute path", e.buf)
  -- 复制光标下文件的相对路径
  nmap("yp", "<cmd>lua require('extensions.netrw-plus.util').copy_relative_path()<cr>", "netrw: Copy relative path", e.buf)
  -- 搜索文件或目录
  nmap("<M-f>", function()
    local ok, tb = pcall(require, "telescope.builtin")
    if ok then
      tb.find_files({ find_command = { "fd" } })
    else
      vim.api.nvim_input(":find ")
    end
  end, "netrw: Find files and directories", e.buf)
end
