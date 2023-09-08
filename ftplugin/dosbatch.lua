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
