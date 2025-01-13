local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local themes = require("telescope.themes")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local M = {}

function M.multigrep()
  local opts = themes.get_dropdown({
      layout_strategy = "vertical",
      borderchars = {
        prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
      layout_config = {
        width = 0.8,
        height = 0.9,
        prompt_position = "bottom"
      }
  })
  opts.cwd = vim.uv.cwd();
  -- local opts = { cwd = vim.uv.cwd() }
  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if prompt == nil or prompt == "" then return nil end
      local args = vim.list_extend({}, conf.vimgrep_arguments)
      table.insert(args, "--path-separator")
      table.insert(args, "/")
      local pieces = vim.split(prompt, "  ")
      local content
      if #pieces > 1 then
        table.insert(args, "-g")
        table.insert(args, pieces[#pieces])
        table.remove(pieces, #pieces)
        content = table.concat(pieces, "  ")
      else
        content = pieces[1]
      end
      table.insert(args, "-e")
      table.insert(args, content)

      -- rg --color=never --no-heading --with-filename --line-number --column --smart-case --path-separator / -e <content> [-g <globs>]
      return args
    end,
    cwd = opts.cwd,
    entry_maker = make_entry.gen_from_vimgrep(opts)
  })
  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Multi Grep",
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty()
  }):find()
end


return M
