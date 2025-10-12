---@class ext.ft_config.Config
---@field fixed? boolean
---@field setup fun(buf:integer)
---@field teardown? fun(buf:integer)

local PrettierFiletype = require("extensions.ft_config.config.prettier_supported_filetype")

local M = {}

---@type { [string]: ext.ft_config.Config }
M.configs = {
  ["ps1"] = require("extensions.ft_config.config.ps1"),
  ["help"] = {
    fixed = true,
    setup = function()
      vim.cmd([[
setlocal wrap
setlocal signcolumn=no
setlocal colorcolumn=0
]])
    end
  },
  ["query"] = {
    fixed = true,
    setup = function()
      vim.cmd([[
setlocal nonumber
setlocal norelativenumber
setlocal signcolumn=no
]])
    end
  },
  ["sh"] = {
    fixed = true,
    setup = function(buf)
      local km = vim.keymap.set
      km("n", "<space>x", "<cmd>execute '!' . getline('.')<cr>",
        { desc = "shell: execute code", buffer = buf })
      km("v", "<space>x", function()
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
      end, { desc = "shell: execute selected code", buffer = buf })
    end
  },
  ["lua"] = require("extensions.ft_config.config.lua"),
  ["go"] = require("extensions.ft_config.config.go"),
}

local same_config_filetypes = {
  "css",
  "html",
  "javascript",
  "javascriptreact",
  "markdown",
  "markdown.mdx",
  "typescript",
  "typescriptreact",
  "astro"
}

for _, ft in ipairs(same_config_filetypes) do
  local pft = PrettierFiletype:new(ft)
  M.configs[ft] = {
    setup = function(buf)
      pft:setup(buf)
    end,
    teardown = function()
      pft:teardown()
    end
  }
end


M.filetypes = vim.tbl_keys(M.configs)

M.config_file = vim.fs.joinpath(vim.fn.stdpath("data"), "filetype_config.json")

return M
