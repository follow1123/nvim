local Config          = require("extensions.ft_config.config")
local FiletypeManager = require("extensions.ft_config.filetype_manager")


local ft_manager = FiletypeManager:new(Config.config_file)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("set config on filetypes", { clear = true }),
  pattern = Config.filetypes,
  callback = function(e)
    local buf = e.buf
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    local ft_config = Config.configs[ft]
    if not ft_config then return end
    if ft_config.fixed then
      ft_config.setup(buf)
      return
    end

    local file_path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
    if ft_manager:is_file_path_enabled(file_path) then
      ft_config.setup(buf)
      return
    end

    local cwd, err = vim.uv.cwd()
    assert(cwd, string.format("get current working directory error: %s", err))
    cwd = vim.fs.normalize(cwd)
    if ft_manager:is_working_dir_enabled(cwd, ft) then
      ft_config.setup(buf)
    end
  end
})

local arg_options = { "workingdir", "filetype", "file" }

---@param buf integer
local function reload_buf(buf)
  vim.api.nvim_buf_call(buf, function()
    -- 不是正常的文件退出
    local file_path = vim.api.nvim_buf_get_name(buf)
    file_path = vim.fs.normalize(file_path)
    local stat = vim.uv.fs_stat(file_path)
    if stat == nil then return end

    -- 文件无法编辑，退出
    if not vim.api.nvim_get_option_value("modified", { buf = buf }) then return end

    vim.cmd("e")
  end)
end

vim.api.nvim_create_user_command("FtConfigEnable", function(o)
  local rule_type = o.args
  local buf = vim.api.nvim_get_current_buf()
  local cwd, err = vim.uv.cwd()
  assert(cwd, string.format("get current working directory error: %s", err))
  cwd = vim.fs.normalize(cwd)
  if rule_type == "workingdir" then
    ft_manager:enable_working_dir(cwd)
  elseif rule_type == "filetype" then
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    ft_manager:enable_working_dir(cwd, ft)
  elseif rule_type == "file" then
    local file_path = vim.api.nvim_buf_get_name(buf)
    file_path = vim.fs.normalize(file_path)
    ft_manager:enable_file_path(file_path)
  else
    vim.notify(string.format("invalid rule type: %s", rule_type), vim.log.levels.ERROR)
  end
  reload_buf(buf)
end, {
  desc = "enable custom filetype config",
  nargs = 1,
  complete = function()
    return arg_options
  end
})

vim.api.nvim_create_user_command("FtConfigDisable", function(o)
  local rule_type = o.args
  local buf = vim.api.nvim_get_current_buf()
  local cwd, err = vim.uv.cwd()
  assert(cwd, string.format("get current working directory error: %s", err))
  cwd = vim.fs.normalize(cwd)
  if rule_type == "workingdir" then
    ft_manager:disable_working_dir(cwd)
  elseif rule_type == "filetype" then
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    ft_manager:disable_working_dir(cwd, ft)
  elseif rule_type == "file" then
    local file_path = vim.api.nvim_buf_get_name(buf)
    file_path = vim.fs.normalize(file_path)
    ft_manager:disable_file_path(file_path)
  else
    vim.notify(string.format("invalid rule type: %s", rule_type), vim.log.levels.ERROR)
  end
  reload_buf(buf)
end, {
  desc = "disable custom filetype config",
  nargs = 1,
  complete = function()
    return arg_options
  end
})

vim.api.nvim_create_user_command("FtConfigReset", function(o)
  local rule_type = o.args
  local buf = vim.api.nvim_get_current_buf()
  local cwd, err = vim.uv.cwd()
  assert(cwd, string.format("get current working directory error: %s", err))
  cwd = vim.fs.normalize(cwd)
  if rule_type == "workingdir" then
    ft_manager:reset_working_dir(cwd)
  elseif rule_type == "file" then
    local file_path = vim.api.nvim_buf_get_name(buf)
    file_path = vim.fs.normalize(file_path)
    ft_manager:reset_file_path(file_path)
  else
    vim.notify(string.format("invalid rule type: %s", rule_type), vim.log.levels.ERROR)
  end
  reload_buf(buf)
end, {
  desc = "reset custom filetype config",
  nargs = 1,
  complete = function()
    return { "workingdir", "file" }
  end
})

vim.api.nvim_create_user_command("FtConfigClean", function()
  local buf = vim.api.nvim_get_current_buf()
  ft_manager:clean()
  reload_buf(buf)
end, { desc = "clean invalid custom filetype config" })

vim.api.nvim_create_user_command("FtConfigIsEnabled", function(o)
  local rule_type = o.args
  local buf = vim.api.nvim_get_current_buf()
  local cwd, err = vim.uv.cwd()
  assert(cwd, string.format("get current working directory error: %s", err))
  cwd = vim.fs.normalize(cwd)
  if rule_type == "workingdir" then
    vim.notify(tostring(ft_manager:is_working_dir_enabled(cwd)), vim.log.levels.INFO)
  elseif rule_type == "filetype" then
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    vim.notify(tostring(ft_manager:is_working_dir_enabled(cwd, ft)), vim.log.levels.INFO)
  elseif rule_type == "file" then
    local file_path = vim.api.nvim_buf_get_name(buf)
    file_path = vim.fs.normalize(file_path)
    vim.notify(tostring(ft_manager:is_file_path_enabled(file_path)), vim.log.levels.INFO)
  else
    vim.notify(string.format("invalid rule type: %s", rule_type), vim.log.levels.ERROR)
  end
end, {
  desc = "check filetype config is enabled",
  nargs = 1,
  complete = function()
    return arg_options
  end
})
