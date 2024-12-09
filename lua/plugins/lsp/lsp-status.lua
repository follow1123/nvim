---@class LspStatus
---@field default_statusline string
---@field current_frame_idx integer
local LspStatus = {}

local group = vim.api.nvim_create_augroup("LSP_STATUS", { clear = true })

LspStatus.spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

function LspStatus:init()
  vim.api.nvim_create_autocmd("LspProgress", {
    group = group,
    callback = function()
      -- 参考 vim.lsp.status() 方法源码实现
      local percentage = nil
      for _, client in ipairs(vim.lsp.get_clients()) do
        --- @diagnostic disable-next-line:no-unknown
        for progress in client.progress do
          --- @cast progress {token: lsp.ProgressToken, value: lsp.LSPAny}
          local value = progress.value
          if type(value) == 'table' and value.kind then
            if value.percentage then
              percentage = math.max(percentage or 0, value.percentage)
            end
          end
          -- else: Doesn't look like work done progress and can be in any format
          -- Just ignore it as there is no sensible way to display it
        end
      end
      if percentage then
        self:render_next_frame()
      else
        self:reset_statusline()
      end
    end
  })
  self.default_statusline = vim.o.statusline
  self.current_frame_idx = 1
end

function LspStatus:render_next_frame()
  local frame = self.spinner_frames[self.current_frame_idx]
  self:update_statusline(frame)
  self.current_frame_idx = self.current_frame_idx + 1
  if self.current_frame_idx > #self.spinner_frames then
    self.current_frame_idx = 1
  end
end

---@param frame string
function LspStatus:update_statusline(frame)
  local status_table = { "%y%m ", frame, " LSP Loading …%=%<%F %r%=%-14.(%l,%c%V%) %P" }
  vim.o.statusline = table.concat(status_table)
end

function LspStatus:reset_statusline()
  vim.o.statusline = self.default_statusline
end

return LspStatus
