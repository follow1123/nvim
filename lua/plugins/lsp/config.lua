local M = {}

function M.setup()
  -- 配置 CursorHold 触发时间，用于高亮光标下符号的引用
  vim.o.updatetime = 500
  -- 配合高亮光标下符号的引用使用
  vim.api.nvim_set_hl(0, "LspReferenceWrite", {
    bold = true,
    bg = "#5c3f44", -- 深红棕色
  })


  -- 代码诊断ui相关
  vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    severity_sort = true,
    float = {
      source = "if_many",
    },
  })

  -- lsp config
  M.setup_lsp()
  M.setup_keymap()
end

function M.setup_keymap()
  vim.keymap.del("n", "grn")
  vim.keymap.del("n", "gra")
  vim.keymap.del("n", "grr")
  vim.keymap.del("n", "gri")
  vim.keymap.del("n", "grt")

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(e)
      local buf = e.buf
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      require("plugins.lsp.keymap")(client, buf)
    end
  })
end

function M.setup_lsp()
  -- 通用配置
  vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  })

  vim.lsp.config.lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Both",
          keywordSnippet = "Both",
          postfix = "@",
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  }

  vim.lsp.config.rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
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

  vim.lsp.config.ts_ls = {
    settings = {
      completions = {
        -- 开启方法参数括号和参数补全
        completeFunctionCalls = true,
      },
      -- 开启 jsdoc 检查
      implicitProjectConfiguration = { checkJs = true },
    },
  }

  vim.lsp.config.gopls = {
    settings = {
      gopls = {
        buildFlags = { "-tags=dev" }
      }
    },
  }

  vim.lsp.config.powershell_es = {
    -- bundle_path = vim.fs.joinpath(vim.fs.normalize(vim.env.MASON), "packages/powershell-editor-services"),
    settings = { powershell = { codeFormatting = { Preset = 'OTBS' } } },
  }
end

return M
