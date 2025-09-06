return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local normal_text = "#bcbec4"
    local selection = "#26282e"
    local panel = "#2b2d30"

    require("catppuccin").setup {
      float = {
        transparent = false,
        solid = false,
      },
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
    vim.cmd.colorscheme("catppuccin-mocha")

    -- 设置浮动窗口颜色
    vim.api.nvim_create_autocmd("WinNew", {
      group = vim.api.nvim_create_augroup("catppuccin-change-color", { clear = true }),
      desc = "set background color when some filetype open",
      callback = vim.schedule_wrap(function()
        if vim.bo.filetype == "harpoon" or
            vim.bo.filetype == "projectmanager" or
            vim.bo.filetype == "tabbedterminal"
        then
          vim.api.nvim_set_option_value("winhighlight", "Normal:Normal,FloatBorder:Normal,FloatTitle:Normal", {
            win = vim.api.nvim_get_current_win()
          })
        end
      end)
    })
  end
}
