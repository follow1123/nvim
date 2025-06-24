local key = require("utils.keymap")

local buf = vim.api.nvim_get_current_buf()

key.nmap("<space>x", ":execute '!' . getline('.')<cr>", "shell: execute code", buf)
key.vmap("<space>x", function()
  vim.api.nvim_input("<esc>")
  vim.schedule(function()
    -- 获取选区的起止行（注意 Lua 下标从 1 开始，get_lines 是从 0 开始）
    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")
    local start_line = start_pos[1] - 1
    local end_line = end_pos[1]

    -- 获取选中的行内容
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

    -- 拼接为一整个 bash 命令
    local cmd = table.concat(lines, "\n")

    -- 执行命令
    local result = vim.fn.system({ "bash", "-c", cmd })

    -- 显示输出结果
    vim.notify(result, vim.log.levels.INFO)
  end)
end, "shell: execute selected code", buf)
