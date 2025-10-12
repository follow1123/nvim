---@class ext.ft_config.PrettierFiletype
---@field filetype string
---@field group_name string
local PrettierFiletype = {}

---@private
PrettierFiletype.__index = PrettierFiletype

---@param filetype string
---@return ext.ft_config.PrettierFiletype
function PrettierFiletype:new(filetype)
  return setmetatable({ filetype = filetype, group_name = filetype .. "_auto_format_on_save:" }, self)
end

---@param buf integer
function PrettierFiletype:setup(buf)
  vim.wo[vim.fn.bufwinid(buf)].colorcolumn = "120"
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup(self.group_name .. buf, { clear = true }),
    buffer = buf,
    callback = function()
      local cmd = vim.fn.exepath("prettier")
      if vim.fn.empty(cmd) == 1 then return end
      vim.cmd("silent !" .. cmd .. " % -w")
    end,
  })
end

function PrettierFiletype:teardown()
end

return PrettierFiletype
