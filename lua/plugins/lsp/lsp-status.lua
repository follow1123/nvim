---@class LspStatus
---@field clients table<string>
---@field timer uv_timer_t
---@field default_statusline string
local LspStatus = {}

local group = vim.api.nvim_create_augroup("LSP_STATUS", { clear = true })

LspStatus.spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

function LspStatus:init()
  vim.api.nvim_create_autocmd("User", {
    pattern = "LspProgressUpdate",
    group = group,
    callback = function()
      local messages = vim.lsp.util.get_progress_messages()
      for _, msg in ipairs(messages) do
        if msg.done then
          self:stop(msg.name)
        else
          self:start(msg.name)
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
  vim.schedule(function()
    vim.o.statusline = self.default_statusline
  end)
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
  if self:has_loading_clients() then return end
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
