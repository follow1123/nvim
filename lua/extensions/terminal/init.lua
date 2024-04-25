-- ###########################
-- #        终端插件         #
-- ###########################
local M = {}

M.full_term = require("extensions.terminal.full_term"):new()

M.lazygit_term = require("extensions.terminal.lazygit_term"):new()

M.split_term = require("extensions.terminal.split_term"):new()

return M
