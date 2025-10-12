local util = require("vim.lsp.util")
local ms = require("vim.lsp.protocol").Methods

local group_name = "go_auto_format_and_organize_on_save:"


---执行整理 imports 的 code action
---@param client vim.lsp.Client
---@param buf integer
local function do_organize_imports(client, buf)
  local method = ms.textDocument_codeAction
  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = { only = { "source.organizeImports" } }
  client:request(method, params, function(err, actions)
    if err then
      vim.notify("LSP code actions organizeImports error: " .. err.message, vim.log.levels.ERROR)
      return
    end

    if actions ~= nil and not vim.tbl_isempty(actions) then
      -- 自动执行第一个可用的 organizeImports action
      for _, action in ipairs(actions) do
        if action.edit then
          util.apply_workspace_edit(action.edit, util._get_offset_encoding(buf))
        else
          client:exec_cmd(action.command)
        end
      end
    end
    -- 这个操作是异步执行的，切换buffer太快如果切换到不可以修改的buffer会报错
    -- 执行 buf 执行操作
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("noautocmd w!")
    end)
  end, buf)
end

---@type ext.ft_config.Config
return {
  setup = function(buf)
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup(group_name .. buf, { clear = true }),
      buffer = buf,
      callback = function()
        -- 文件内容没有变更直接返回
        if not vim.api.nvim_get_option_value("modified", { buf = buf }) then return end
        local clients = vim.lsp.get_clients({ bufnr = buf, name = "gopls" })
        -- 没有 lsp 服务时使用命令行格式化代码
        if #clients == 0 then
          vim.cmd("silent !gofmt -w %")
          return
        end

        local client = clients[1]
        local method = ms.textDocument_formatting
        client:request(method, util.make_formatting_params(), function(...)
          local handler = client.handlers[method] or vim.lsp.handlers[method]
          handler(...)
          do_organize_imports(client, buf)
        end, buf)
      end
    })
  end,
  teardown = function()
    -- vim.api.nvim_del_augroup_by_id(group_id)
  end
}
