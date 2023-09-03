-- lua 文件单独配置
local function run_code_on_cursor()
  -- 获取当前光标所在行的文本
  local cur_code = vim.fn.getline('.'):match("^%s*(.-)%s*$")
  if cur_code == "" then
    print("no code on cursor")
  else
    vim.cmd("lua " .. cur_code)
  end
end

local function run_code_file()
  print(123)
end

-- local function run_code_file()
  -- print("run_code_file")
-- end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function ()
    -- 设置lua文件的tab宽度
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    _G.LANGUAGE.lua = {
      run_code_on_cursor = run_code_on_cursor,
      run_code_file = run_code_file
    }
    -- 配置运行当前光标下的代码快捷键和command
    -- local desc = "run code on cursor"
    -- vim.keymap.set("n", "<leader>cr", run_code_on_cursor, {
    --   desc = desc,
    --   buffer = vim.api.nvim_get_current_buf(),
    --   noremap = true,
    --   silent = true,
    -- })
    -- vim.api.nvim_buf_create_user_command(0, "RunCode", run_code_on_cursor, { desc = desc })
  end
})
