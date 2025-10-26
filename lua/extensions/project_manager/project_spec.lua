-- 取消注释后，lsp会自动加载相关方法
-- require("plenary.test_harness")

local project_path = assert(vim.uv.cwd())
local session_root = vim.fn.stdpath("cache")
local session_options = { "curdir", "buffers", "tabpages", "winsize", "folds" }

local Project = require("extensions.project_manager.project")

describe("create project", function()
  it("create success", function()
    assert.no_errors(function() Project:new(project_path) end)
  end)
  it("create failure", function()
    assert.has_errors(function() Project:new("/a/b/c") end)
  end)
end)

describe("init project session", function()
  it("init success", function()
    local project = Project:new(project_path)
    assert.no_errors(function() project:init(session_root) end)
    assert.no_errors(function() project:delete() end)
  end)
  it("init failure", function()
    local project = Project:new(project_path)
    assert.has_errors(function() project:init("/a/b/c") end)
  end)
end)

describe("save", function()
  it("save session", function()
    local project = Project:new(project_path)
    assert.no_errors(function() project:save(session_root, session_options) end)
    assert.no_errors(function() project:delete() end)
  end)
end)
