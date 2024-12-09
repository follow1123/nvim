-- 参考 `:h vim.lsp.ClientConfig`
---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line
return {
  on_attach = require("plugins.lsp.keymap"),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = {
    ['rust-analyzer'] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true
      },
      completion = {
        callable = {
          -- fill_arguments - 插入括号并显示方法的所有参数的代码片段
          -- add_parentheses - 只插入括号
          -- none - 禁用
          snippets = "add_parentheses"
        }
      }
    }
  }
}
