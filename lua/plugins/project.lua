-- 根据session list 获取对应session的root
local function get_session_root(path)
  local session_dir = require("persistence.config").options.dir
  path = path:sub(session_dir:len() + 1, path:len())
  path = path:gsub("%%", ":", 1)
  path = path:gsub("%%", "/")
  return path:sub(1, path:len() - 4)
end


-- local function create_finder()
--   local results = history.get_recent_projects()
--
--   -- Reverse results
--   for i = 1, math.floor(#results / 2) do
--     results[i], results[#results - i + 1] = results[#results - i + 1], results[i]
--   end
--   local displayer = entry_display.create({
--     separator = " ",
--     items = {
--       {
--         width = 30,
--       },
--       {
--         remaining = true,
--       },
--     },
--   })
--
--   local function make_display(entry)
--     return displayer({ entry.name, { entry.value, "Comment" } })
--   end
--
--   return finders.new_table({
--     results = results,
--     entry_maker = function(entry)
--       local name = vim.fn.fnamemodify(entry, ":t")
--       return {
--         display = make_display,
--         name = name,
--         value = entry,
--         ordinal = name .. " " .. entry,
--       }
--     end,
--   })
-- end

-- local function delete_project(prompt_bufnr)
--   local state = require("telescope.actions.state")
--   local history = require("project_nvim.utils.history")
--   local selectedEntry = state.get_selected_entry(prompt_bufnr)
--   local actions = require("telescope.actions")
--   if selectedEntry == nil then
--     actions.close(prompt_bufnr)
--     return
--   end
--   local choice = vim.fn.confirm("Delete '" .. selectedEntry.value .. "' from project list?", "&Yes\n&No", 2)
--
--   if choice == 1 then
--     history.delete_project(selectedEntry)
--
--     local finder = create_finder()
--     state.get_current_picker(prompt_bufnr):refresh(finder, {
--       reset_prompt = true,
--     })
--   end
-- end
-- 由于project.nvim插件实现的telescope扩展不规范，需要使用这种方式修改自定义按键
local function select_projects()
  local state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  require('telescope').extensions.projects.projects{
    attach_mappings = function(prompt_bufnr, _) -- telescope配置按键映射方法
      actions.select_default:replace(function () -- telescope修改选择默认方法
        -- 获取选项的值
        local selected_entry = state.get_selected_entry(prompt_bufnr)
        if selected_entry == nil then
          actions.close(prompt_bufnr)
          return
        end
        local project_path = selected_entry.value
        actions.close(prompt_bufnr)

        -- 查找对应的session并打开
        local persistence = require("persistence")
        local session_list = persistence.list()
        for _, value in pairs(session_list) do
          if project_path:match(get_session_root(value)) then
            vim.cmd("%bdelete!")
            vim.cmd("silent! source " .. vim.fn.fnameescape(value))
            break
          end
        end
        persistence.start() -- 开启保存session功能
        vim.api.nvim_set_current_dir(project_path) -- 切换当前工作目录
      end)
      return true
    end,
  }
end

return {
  { -- 项目管理
    "ahmedkhalf/project.nvim",
    keys = {
      { "<leader>pf", select_projects, desc = "list projects" },
    },
    config = function()
      require("project_nvim").setup {
        manual_mode = true, -- 手动管理项目的目录
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "Cargo.toml", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
        ignore_lsp = {},
        exclude_dirs = { "~/.cargo/*", },
        -- Show hidden files in telescope
        show_hidden = false,
        -- When set to false, you will get a message when project.nvim changes your
        -- directory.
        silent_chdir = true,
        scope_chdir = 'global',
        datapath = vim.fn.stdpath("data"),
      }
    end
  },
  { -- session
    "folke/persistence.nvim",
    module = "persistence",
    lazy = true,
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- session保存
        options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        pre_save = nil,                                          -- 保存session前执行的方法
      }
      -- 默认关闭保存session功能
      require("persistence").stop()
    end
  }
}
