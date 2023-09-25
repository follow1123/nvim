local keymap_uitl = require("utils.keymap")
local lazy_map = keymap_uitl.lazy_map

-- 项目管理插件
return {
  "follow1123/project_session.nvim",
  lazy = not _G.IS_GUI,
  keys = {
    lazy_map("n", "<leader>pf", "<cmd>lua require('telescope').extensions.projects.recent_projects()<cr>", "project: List recent projects"),
    lazy_map("n", "<leader>pa", "<cmd>lua require('project_session').add()<cr>", "project: Add project"),
    lazy_map("n", "<leader>po", "<cmd>lua require('project_session').open()<cr>", "project: Open project"),
    lazy_map("n", "<leader>ps", "<cmd>lua require('project_session').save()<cr>", "project: Save project"),
  },
  config = function()
    local project_session = require("project_session")
    project_session.setup()
    if _G.IS_GUI then
      project_session.load_last()
      pcall(vim.api.nvim_command, "TSEnable highlight")
    end
  end
}
