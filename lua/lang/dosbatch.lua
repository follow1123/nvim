-- windows批处理配置

local function run_code_on_cursor()
  -- 获取当前光标所在行的文本
  local cur_code = vim.fn.getline('.'):match("^%s*(.-)%s*$")
  if cur_code == "" then
    print("no code on cursor")
  else
    vim.notify(vim.fn.system(cur_code))
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dosbatch",
  callback = function ()
    _G.LANGUAGE.dosbatch = {
      run_code_on_cursor = run_code_on_cursor
    }
  end
})
