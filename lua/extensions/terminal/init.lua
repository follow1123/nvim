-- ###########################
-- #        终端插件         #
-- ###########################
local M = {}

M.scratch_term = require("extensions.terminal.scratch_term"):new()

M.lazygit_term = require("extensions.terminal.lazygit_term"):new()

M.split_term = require("extensions.terminal.split_terminal"):new("pwsh")

return M
