---@class LspStatus
---@field clients table<string, string>
---@field timer uv_timer_t
---@field default_statusline string
local LspStatus = {}

local group = vim.api.nvim_create_augroup("LSP_STATUS", { clear = true })

LspStatus.spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

function LspStatus:init()
  vim.api.nvim_create_autocmd("LspProgress", {
    group = group,
    callback = function()
      -- 参考 vim.lsp.status() 方法源码实现
      local percentage = nil
      local percentage_map = {} --- @type table<string, integer>
      for _, client in ipairs(vim.lsp.get_clients()) do
        percentage_map[client.name] = -1
        --- @diagnostic disable-next-line:no-unknown
        for progress in client.progress do
          --- @cast progress {token: lsp.ProgressToken, value: lsp.LSPAny}
          local value = progress.value
          if type(value) == 'table' and value.kind then
            if value.percentage then
              percentage = math.max(percentage or 0, value.percentage)
              percentage_map[client.name] = percentage
            end
          end
          -- else: Doesn't look like work done progress and can be in any format
          -- Just ignore it as there is no sensible way to display it
        end
      end
      for client_name, per in pairs(percentage_map) do
        if per == -1 then
          self:stop(client_name)
        else
          self:start(client_name)
        end
      end
    end
  })
  vim.api.nvim_create_autocmd("VimLeave", {
    group = group,
    callback = function()
      if self.timer then self.timer:close() end
    end,
  })
  self.clients = {}
  self.default_statusline = vim.o.statusline
end

---@param frame_idx integer
function LspStatus:update_statusline(frame_idx)
  vim.schedule(function()
    local status_table = { "%y%m ", self.spinner_frames[frame_idx], " LSP Loading...%=%<%F %r%=%-14.(%l,%c%V%) %P" }
    vim.o.statusline = table.concat(status_table)
  end)
end

function LspStatus:reset_statusline()
  vim.o.statusline = self.default_statusline
end

function LspStatus:has_loading_clients()
  return not vim.tbl_isempty(self.clients)
end

function LspStatus:loading()
  if self.timer == nil then
    self.timer = vim.uv.new_timer()
  end
  local frames_num = #self.spinner_frames
  local frame_idx = 0
  self.timer:start(0, 100, function()
    frame_idx = frame_idx % frames_num
    self:update_statusline(frame_idx + 1)
    frame_idx = frame_idx + 1
  end)
end

function LspStatus:done()
  if self.timer == nil then return end
  self.timer:stop()
  self:reset_statusline()
end

---@param client_name string
function LspStatus:start(client_name)
  if self.clients[client_name] then return end
  self.clients[client_name] = client_name
  self:loading()
end

---@param client_name string
function LspStatus:stop(client_name)
  self.clients[client_name] = nil
  self:done()
end

return LspStatus
