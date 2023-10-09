-- ###########################
-- #         vimdiff 未使用   #
-- ###########################

-- diff颜色
-- Add #536232 Change #1c7ca1 Delete #771b1b
vim.api.nvim_set_hl(0, "DiffAdd", { fg = "", bg = "#414733" }) -- diff新增
vim.api.nvim_set_hl(0, "DiffChange", { fg = "", bg = "#215e76" }) -- diff修改
vim.api.nvim_set_hl(0, "DiffDelete", { fg = "", bg = "#552222" }) -- diff删除
vim.api.nvim_set_hl(0, "DiffText", { fg = "", bg = "#414733" }) -- diff文本
vim.api.nvim_set_hl(0, "FoldColumn", { fg = "", bg = "#1e1e1e" }) -- diff模式最左侧显示的折叠栏的颜色

-- 创建diff选择时状态颜色信息的namespace
local diff_options_ns = vim.api.nvim_create_namespace("DiffOptions")
vim.api.nvim_set_hl(diff_options_ns, "StatusLineNC", { fg = "Yellow", bg = "#613214", })


--[[
设置diff选择时的状态栏颜色和信息
]]
local function set_diff_win_options(winnr, bufnr, statusline, reset)
  local hl_ns = reset and 0 or diff_options_ns
  vim.api.nvim_set_option_value("statusline", statusline, { buf = bufnr })
  vim.api.nvim_win_set_hl_ns(winnr, hl_ns)
end

-- diffget
local function diff_get(bufnr, all)
  if all then
    vim.cmd(".,$diffget " .. bufnr)
  else
    vim.cmd("diffget " .. bufnr)
  end
end

-- diffput
local function diff_put(bufnr, all)
  if all then
    vim.cmd(".,$diffput " .. bufnr)
  else
    vim.cmd("diffput " .. bufnr)
  end
end

--[[
封装diff操作

@param opt 
  true: diffget
  otherwise: diffput

@param all
  true: 选择从当前行到最后一行
  otherwise: 选择当前行
]]
local function vim_diff(opt, all)
  if not vim.o.diff then return end
  local cur_win_list = vim.api.nvim_list_wins()
  if #cur_win_list == 1 then return end
  local cur_bufnr = vim.fn.bufnr()
  local diff_win_list = {}
  if #cur_win_list == 2 then
    local cur_winnr = vim.fn.win_getid()
    local other_winnr = vim.tbl_filter(function (v) return cur_winnr ~= v end, cur_win_list)[1]
    local bufnr = vim.fn.winbufnr(other_winnr)
    if opt then
  vim.notify("1")
  vim.notify(tostring(bufnr))
      diff_get(bufnr, all)
   else
  vim.notify("2")
      diff_put(bufnr, all)
    end
    return
  end
  vim.notify("6")
  -- 获取当前屏幕上现实的所有winnr
  for _, winnr in ipairs(cur_win_list) do
    -- 根据winnr获取对应的buffer
    local bufnr = vim.fn.winbufnr(winnr)
    if bufnr ~= cur_bufnr then
      -- 临时存储其他buffer的状态信息
      table.insert(diff_win_list, {
        bufnr = bufnr,
        winnr = winnr,
        statusline = vim.api.nvim_get_option_value("statusline", { buf = bufnr }),
      })
      local statusline = string.rep(" ", (vim.fn.winwidth(winnr) - #diff_win_list) / 2) .. #diff_win_list
      set_diff_win_options(winnr, bufnr, statusline)
    end
  end

  -- 由于设置状态信息再监听输入时会阻塞，导致无法设置状态栏的信息，所以需要延时监听当前的输入
  _G.util.handle_input_char(function (input_char)
    local num = tonumber(input_char)
    if num and num > 0 and  num <= #diff_win_list then
      local bufnr = diff_win_list[num].bufnr
      if opt then
        diff_get(bufnr, all)
      else
        diff_put(bufnr, all)
      end
    else
      vim.notify("please input a number on statusline", vim.log.levels.WARN)
    end
    -- 还原状态栏颜色和信息
    for _, v in ipairs(diff_win_list) do
      set_diff_win_options(v.winnr, v.bufnr, v.statusline, true)
    end
  end)
end

local vimdiff_status = { }


local function register_diff_keymap(bufnr)
  local diff_opts = { noremap = true, silent = true }
  -- diff移动相关快捷键
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cj", "]c", diff_opts) -- 下一个冲突
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ck", "[c", diff_opts) -- 上一个冲突
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cJ", "999]c", diff_opts) -- 第一个冲突
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cK", "999[c", diff_opts) -- 最后一个冲突
  -- diff合并相关快捷键
  vim.keymap.set("n", "<leader>cm", function () vim_diff(true, false) end, vim.tbl_extend("force", diff_opts, { desc = "diffget", buffer = bufnr })) -- 冲突合并
  vim.keymap.set("n", "<leader>cM", function () vim_diff(true, true) end, vim.tbl_extend("force", diff_opts, { desc = "diffgetall", buffer = bufnr })) -- 冲突全部合并
  vim.keymap.set("n", "<leader>cp", function () vim_diff(false, false) end, vim.tbl_extend("force", diff_opts, { desc = "diffput", buffer = bufnr })) -- diff put
  vim.keymap.set("n", "<leader>cP", function () vim_diff(false, true) end, vim.tbl_extend("force", diff_opts, { desc = "diffputall", buffer = bufnr })) -- diff put all
  vimdiff_status[tostring(bufnr)]  = true
end

local function unregister_diff_keymap(bufnr)
  vim.keymap.del("n", "<leader>cj", { buffer = bufnr })
  vim.keymap.del("n", "<leader>ck", { buffer = bufnr })
  vim.keymap.del("n", "<leader>cJ", { buffer = bufnr })
  vim.keymap.del("n", "<leader>cK", { buffer = bufnr })
  vim.keymap.del("n", "<leader>cm", { buffer = bufnr })
  vim.keymap.del("n", "<leader>cM", { buffer = bufnr })
  vim.keymap.del("n", "<leader>cp", { buffer = bufnr })
  vim.keymap.del("n", "<leader>cP", { buffer = bufnr })
  vimdiff_status[tostring(bufnr)]  = false
end


-- diff模式设置快捷键
vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave", "BufWinEnter", "BufWinLeave" }, {
  pattern = "*",
  nested = true,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local status = vimdiff_status[tostring(bufnr)]
    if vim.o.diff then
      if not status then
        register_diff_keymap(bufnr)
      end
    else
      if status then
        unregister_diff_keymap(bufnr)
      end
    end
  end
})
