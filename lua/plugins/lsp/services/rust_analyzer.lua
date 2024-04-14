-- rust lsp 配置
local config = {
  settings = {
    ['rust-analyzer'] = {
      completion = {
        autoimport = {
          enable = true
        },
        callable = {
          snippets = "fill_arguments"
        },
        postfix = {
          enable = true
        }
      },
      diagnostics = {
        enable = true;
      }
    }
  }
}

return config
