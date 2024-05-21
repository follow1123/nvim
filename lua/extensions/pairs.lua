---@class Symbol
---@field left string
---@field right string

---@class Pairs
---@field setup function
---@field symbols Symbol[]
local M = {}

---自动配对的符号
---@type Symbol[]
M.symbols = {
  { left = "{", right = "}" },
  { left = "[", right = "]" },
  { left = "(", right = ")" },
  { left = '"', right = '"' },
  { left = "'", right = "'" },
}

---直接输出符号对并向左移动光标
---@param symbol Symbol
local function complete_pair(symbol)

  if symbol.left == "(" then
    local line = vim.fn.line(".") - 1
    local col = vim.fn.col(".") - 1
    local next_char = vim.api.nvim_buf_get_text(0, line, col, line, col + 1, {})[1]

    if string.match(next_char, "%S") then
      vim.api.nvim_put({ symbol.left } , "", false, true)
      return
    end
  end

  vim.api.nvim_put({ symbol.left .. symbol.right } , "", false, true)
  vim.api.nvim_input("<Left>")
end

function M.setup()
  for _, symbol in ipairs(M.symbols) do
    vim.keymap.set("i", symbol.left,
      function() complete_pair(symbol) end,
      { desc = string.format("pairs: `%s` pair", symbol.left) }
    )
  end
end

return M
