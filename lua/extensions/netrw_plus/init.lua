local km = vim.keymap.set

local netrw_plus


return {
  toggle = function()
    if netrw_plus == nil then
      netrw_plus = require("extensions.netrw_plus.netrw_wrapper"):new()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "netrw",
        group = vim.api.nvim_create_augroup("netrw_plus_keymaps", { clear = true }),
        desc = "set some options when enter netrw buffer",
        callback = function(e)
          local netrw_buf = e.buf
          km("n", "gw", "<cmd>e .<cr>", { desc = "netrw plus: Go to current working directory", buffer = netrw_buf })
          km("n", "<C-h>", "<C-w>h", { desc = "netrw plus: Go to left window", buffer = netrw_buf })
          km("n", "<C-l>", "<C-w>l", { desc = "netrw plus: Go to right window", buffer = netrw_buf })
          km("n", "yP", function() vim.fn.setreg("+", netrw_plus.get_file_path()) end,
            { desc = "netrw plus: Copy absolute path", buffer = netrw_buf })
          km("n", "yp", function() vim.fn.setreg("+", vim.fn.fnamemodify(netrw_plus.get_file_path(), ":.")) end,
            { desc = "netrw plus: Copy relative path", buffer = netrw_buf })
          km("n", "<M-f>", function()
            local ok, tb = pcall(require, "telescope.builtin")
            if ok then
              -- 支持搜索文件夹
              tb.find_files({ find_command = { "fd" } })
            else
              vim.api.nvim_input(":find ")
            end
          end, { desc = "netrw plus: Find files and directories", buffer = netrw_buf })
        end
      })
    end
    netrw_plus:toggle()
  end
}
