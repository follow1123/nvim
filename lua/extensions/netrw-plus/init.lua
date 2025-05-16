local nmap = require("utils.keymap").nmap
local netrw = require("extensions.netrw-plus.netrw"):new()
local netrw_group = vim.api.nvim_create_augroup("NETRW_PLUS", { clear = true })
local util = require("extensions.util")


vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  group = netrw_group,
  desc = "set some options when enter netrw buffer",
  callback = function(e)
    -- 设置按键映射
    -- 文件浏览器切换到当前的工作目录
    nmap("gw", "<cmd>e .<cr>", "netrw: Go to current working directory", e.buf)
    nmap("<C-h>", "<C-w>h", "netrw: Go to left window", e.buf)
    nmap("<C-l>", "<C-w>l", "netrw: Go to right window", e.buf)
    -- 复制光标下文件的绝对路径
    nmap("yP", function()
      vim.fn.setreg("+", netrw:get_file_path())
    end, "netrw: Copy absolute path", e.buf)
    -- 复制光标下文件的相对路径
    nmap("yp", function()
      vim.fn.setreg("+", vim.fn.fnamemodify(netrw:get_file_path(), ":."))
    end, "netrw: Copy relative path", e.buf)
    -- 搜索文件或目录
    nmap("<M-f>", function()
      local ok, tb = pcall(require, "telescope.builtin")
      if ok then
        tb.find_files({ find_command = { "fd" } })
      else
        vim.api.nvim_input(":find ")
      end
    end, "netrw: Find files and directories", e.buf)
    local path = vim.api.nvim_buf_get_name(e.buf)
    -- 添加 netrw buffer
    netrw:put_netrw_buffer(path, e.buf)
  end
})

-- 在netrw内定位当前文件
nmap("<leader>fL", function()
  -- netrw buffer 没用显示直接退出
  local netrw_buf = netrw:get_visible_netrw()
  if netrw_buf == nil then return end
  local buf = vim.api.nvim_get_current_buf()
  -- 当前就是 netrw buffer 直接退出
  if buf == netrw_buf then return end

  local file_full_path = vim.api.nvim_buf_get_name(buf)
  netrw:locate_file(file_full_path, netrw_buf)
end, "netrw: Locate current file in netrw buffer")

return netrw
