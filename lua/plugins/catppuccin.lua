return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local normal_text = "#bcbec4"
    local selection = "#26282e"
    local panel = "#2b2d30"

    require("catppuccin").setup {
      color_overrides = {
        mocha = {
          base = "#1e1f22",
          crust = "#9298b1",
          mantle = panel,
          text = normal_text,
          blue = normal_text,
          lavender = normal_text,
        },
      },
      highlight_overrides = {
        mocha = function()
          return {
            Pmenu = { bg = panel },
            Comment = { fg = "#7A7E85" },
            CursorLine = { bg = selection },
            ColorColumn = { bg = selection },
          }
        end
      }
    }
    -- 禁用lsp的高亮
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end
    vim.cmd.colorscheme("catppuccin-mocha")
    vim.api.nvim_create_autocmd("WinNew", {
      group = vim.api.nvim_create_augroup("catppuccin-change-color", { clear = true }),
      desc = "set background color when some filetype open",
      callback = vim.schedule_wrap(function()
        if vim.bo.filetype == "harpoon" or vim.bo.filetype == "projectmgr" then
          vim.api.nvim_set_option_value("winhighlight", "Normal:Normal", {
            win = vim.api.nvim_get_current_win()
          })
        end
      end)
    })
  end
}
