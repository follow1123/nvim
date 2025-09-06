local util = require("vim.lsp.util")
local ms = require("vim.lsp.protocol").Methods

local buf = vim.api.nvim_get_current_buf()
local auto_organize_group = vim.api.nvim_create_augroup("go_auto_organize_on_save:" .. buf, { clear = true })


---执行整理 imports 的 code action
---@param client vim.lsp.Client
local function do_organize_imports(client)
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

---执行格式化操作
---@param client vim.lsp.Client
local function do_format(client)
  local method = ms.textDocument_formatting
  client:request(method, util.make_formatting_params(), function(...)
    local handler = client.handlers[method] or vim.lsp.handlers[method]
    handler(...)
    do_organize_imports(client)
  end, buf)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = auto_organize_group,
  buffer = buf,
  callback = function()
    -- 文件内容没有变更直接返回
    if not vim.api.nvim_get_option_value("modified", { buf = 0 }) then return end
    local clients = vim.lsp.get_clients({ bufnr = buf, name = "gopls" })
    -- 没有 lsp 服务时使用命令行格式化代码
    if #clients == 0 then
      vim.cmd("silent !gofmt -w %")
      return
    end
    local gopls = clients[1]
    do_format(gopls)
  end
})
