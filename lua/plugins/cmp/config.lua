local cmp = require("cmp")
local luasnip = require("luasnip")

local M = {}

---@param str string
---@return integer
local function find_last_blank(str)
  local str_r = string.reverse(str)
  local idx_r = string.find(str_r, "%S")
  return #str - idx_r + 1
end

---@param entry cmp.Entry
---@return boolean
local function has_parameters(entry)
  local function_cmp_text = entry.filter_text
  local s, e = string.find(function_cmp_text, "(", 1, true)
  if not s then return false end
  local s1, _ = string.find(function_cmp_text, ")", e, true)
  return s1 - s > 1
end

-- 因为有时候在补全一些常量是，回车后补全弹框会再次弹出来的问题
-- 特别是在代码片段内，会导致无法跳转到下一处
local function fix_complete_enmu_in_snippet_area()
  if luasnip.locally_jumpable() then
    vim.schedule_wrap(cmp.close)()
  end
end

-- 在方法补全完成后自动插入括号
-- 目前只支持lua，并且需要将 lua_ls 配置的 completion.callSnippet 改成 Disable
---@param entry cmp.Entry
local function auto_pairs_when_complete_function(entry)
  if vim.bo.filetype ~= "lua" then return end
  local kind = cmp.lsp.CompletionItemKind
  local entry_kind = entry:get_kind()
  if entry_kind ~= kind.Function and entry_kind ~= kind.Method then return end
  local insert_text = entry:get_insert_text()
  -- 如果补全的方法有回车或换行，说明是一个特殊的代码片段，直接跳过
  if string.find(insert_text, "[\r\n]") then return end
  local rows, cols = unpack(vim.api.nvim_win_get_cursor(0))
  rows = rows - 1

  local col_end_of_line = vim.fn.col('$')
  local next_char = vim.api.nvim_buf_get_text(0, rows, cols, rows, cols + 1, {})[1]
  local next_is_whitespace = #next_char == 0 or string.match(next_char, "%s")
  local has_params = has_parameters(entry)
  -- 如果有没有参数则直接插入两个括号
  if not has_params then
    vim.api.nvim_feedkeys("()", "i", true)
    return
  end
  -- 有参数，并且右边是空白字符，则插入两个括号并将光标移动到括号内，好显示参数信息
  if next_is_whitespace then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("()<Left>", true, false, true), "i", true)
    return
  end

  -- 有参数，并且右边不是空白字符，则先插入左边一半的括号
  -- 将光标移动到这行最后一个非空白字符的位置
  -- 再插入右边一半的括号，并将光标移动到括号内
  local after_text = vim.api.nvim_buf_get_text(0, rows, cols, rows, col_end_of_line, {})[1]
  local last_blank_char_idx = find_last_blank(after_text)
  local termcodes = vim.api.nvim_replace_termcodes("(" .. string.rep("<Right>", last_blank_char_idx) .. ")<Left>", true, false, true)
  vim.api.nvim_feedkeys(termcodes, "i", true)
end

function M.setup_config()
  -- 补全配置
  cmp.setup({
    enabled = function()
      -- disable completion in comments
      local context = require 'cmp.config.context'
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment")
        and not context.in_syntax_group("Comment")
      end
    end,
    ---@diagnostic disable-next-line
    performance = { max_view_entries = 60 }, -- 最大只显示60条补全数据
    -- 禁用自动选择 item
    preselect = cmp.PreselectMode.None,
    mapping = require("plugins.cmp.keymap"), -- 补全按键
    snippet = {
      expand = function(args) -- 代码片段引擎配置
        require("luasnip").lsp_expand(args.body)
      end,
    },
    -- 补全默认选中第一个
    completion = {
      keyword_length = 1,
      completeopt = "menu,menuone,noinsert"
    },
    formatting = require("plugins.cmp.format"), -- 补全弹窗数据格式
    -- 补全来源
    -- group_index 每次补全只显示相同组的 source
    -- priority 相同组内不同 sources 优先级（受 group_index 影响，group_index 越小，越早匹配）
    sources = {
      { name = "lazydev", group_index = 0 },
      { name = "nvim_lsp_signature_help", group_index = 1, priority = 99},
      { name = "nvim_lsp", group_index = 2, priority = 98 },
      { name = "luasnip", group_index = 2, priority = 97 },
    },
    view = { docs = { auto_open = true } }, -- 自动开打补全文档弹窗
    -- 补全弹窗样式配置
    window = {
      documentation = {  max_height = 20 } -- 文档窗口边框
    },
  })

  -- Telescope搜索时禁用补全功能
  cmp.setup.filetype({ "TelescopePrompt" }, { enabled = false })
  -- 默认在注释内不开启补全，但是在在lua内有文档注释，需要开启补全
  cmp.setup.filetype({ "lua", "javascript" }, { enabled = true })
  -- 补全完成后执行的操作
  cmp.event:on("confirm_done", function(evt)
    fix_complete_enmu_in_snippet_area()
    if evt.commit_character then return end
    auto_pairs_when_complete_function(evt.entry)
  end)
end

return M
