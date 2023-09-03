-- powershell脚本配置

local function run_code_on_cursor()
  -- 获取当前光标所在行的文本
  local cur_code = vim.fn.getline('.'):match("^%s*(.-)%s*$")
  if cur_code ~= "" then
    local command = _G.LANGUAGE.ps1.shell
    local shellopts = _G.LANGUAGE.ps1.shellopts or {}
    for _, value in ipairs(shellopts) do
      command = command .. " " .. value
    end
    vim.notify(vim.fn.system(command .. " " .. cur_code))
  else
    print("no code on cursor")
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ps1",
  callback = function ()
    _G.LANGUAGE.ps1= {
      shell = "pwsh",
      shellopts = { "-nop", "-c" },
      run_code_on_cursor = run_code_on_cursor,
    }
  end
})
