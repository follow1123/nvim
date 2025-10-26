-- 取消注释后，lsp会自动加载相关方法
-- require("plenary.test_harness")

local cache_path = vim.fn.stdpath("cache")

local function rand_session_root()
  local name = string.format("project_manager_sessions_%d", math.random(10000, 99999))
  return vim.fs.joinpath(cache_path, name)
end

local function delete_session_root(path)
  local fs_t = vim.uv.fs_scandir(path)
  if not fs_t then return end
  while true do
    local name, _ = vim.uv.fs_scandir_next(fs_t)
    if not name then break end
    assert(vim.uv.fs_unlink(vim.fs.joinpath(path, name)))
  end
  assert(vim.uv.fs_rmdir(path))
end

local project_path = assert(vim.uv.cwd())
local session_options = { "curdir", "buffers", "tabpages", "winsize", "folds" }
local project_root_patterns = {
  { name = ".git",          dir = true },
  { name = "src",           dir = true },
  { name = ".editorconfig" },
  { name = "cargo.toml" },
  { name = "package.json" },
  { name = "tsconfig.json" },
  { name = "makefile" },
  { name = "lua",           dir = true },
  { name = "lazy-lock.json" },
  { name = "go.mod" },
  { name = "go.sum" },
  { name = "build.zig" },
  { name = ".gitignore" },
  { name = "README.md" },
}

local Manager = require("extensions.project_manager.manager")

describe("create manager", function()
  local session_root = rand_session_root()
  after_each(function() delete_session_root(session_root) end)

  it("create success", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.are_equal(vim.fs.joinpath(session_root, "sessions.json"), manager.data_path)
      assert.are_equal(0, #manager.projects)
    end)
  end)
  it("create failure", function()
    ---@diagnostic disable-next-line: param-type-mismatch
    assert.has_errors(function() Manager:new(nil) end)
  end)
end)

describe("add project", function()
  local session_root = rand_session_root()
  after_each(function() delete_session_root(session_root) end)

  it("add one", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function() manager:add_project(project_path) end)
      assert.are_equal(1, #manager.projects)
      local stat = vim.uv.fs_stat(manager.data_path)
      assert.not_nil(stat)
      ---@diagnostic disable-next-line: need-check-nil
      assert.are_true(stat.size > 0)
    end)
  end)

  it("add many", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function() manager:add_project(project_path) end)
      assert.no_errors(function() manager:add_project(vim.fn.stdpath("state")) end)
      assert.are_equal(2, #manager.projects)
      local stat = vim.uv.fs_stat(manager.data_path)
      assert.not_nil(stat)
      ---@diagnostic disable-next-line: need-check-nil
      assert.are_true(stat.size > 0)
    end)
  end)

  it("duplicate project", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function() manager:add_project(project_path) end)
      assert.has_errors(function() manager:add_project(project_path) end)
    end)
  end)
end)

describe("update projects", function()
  local session_root = rand_session_root()
  after_each(function() delete_session_root(session_root) end)

  it("add projects", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("cache"),
          vim.fn.stdpath("state")
        })
      end)
      assert.are_equal(2, #manager.projects)

      local saved_projects = Manager.load_projects(manager.data_path)
      assert.are_equal(2, #saved_projects)
    end)
  end)

  it("remove projects", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("cache"),
          vim.fn.stdpath("state")
        })
      end)
      assert.are_equal(2, #manager.projects)

      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("state")
        })
      end)

      assert.are_equal(1, #manager.projects)
      assert.are_equal(vim.fs.normalize(vim.fn.stdpath("state")), manager.projects[1].path)

      local saved_projects = Manager.load_projects(manager.data_path)
      assert.are_equal(1, #saved_projects)
      assert.are_equal(vim.fs.normalize(vim.fn.stdpath("state")), saved_projects[1].path)
    end)
  end)

  it("remove all projects", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("cache"),
          vim.fn.stdpath("state")
        })
      end)
      assert.are_equal(2, #manager.projects)

      assert.no_errors(function()
        manager:update_projects({
          ""
        })
      end)

      assert.are_equal(0, #manager.projects)

      local saved_projects = Manager.load_projects(manager.data_path)
      assert.are_equal(0, #saved_projects)
    end)
  end)

  it("add and remove projects", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("cache"),
          vim.fn.stdpath("state")
        })
      end)
      assert.are_equal(2, #manager.projects)

      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("state"),
          project_path
        })
      end)

      assert.are_equal(2, #manager.projects)

      for _, p in ipairs(manager.projects) do
        assert.not_equal(vim.fs.normalize(vim.fn.stdpath("cache")), p.path)
      end

      local saved_projects = Manager.load_projects(manager.data_path)
      assert.are_equal(2, #saved_projects)

      for _, p in ipairs(saved_projects) do
        assert.not_equal(vim.fs.normalize(vim.fn.stdpath("cache")), p.path)
      end
    end)
  end)

  it("add exists projects", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("cache"),
          vim.fn.stdpath("state")
        })
      end)
      assert.are_equal(2, #manager.projects)

      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("cache"),
          vim.fn.stdpath("state"),
          vim.fn.stdpath("state"),
          vim.fn.stdpath("state"),
          vim.fn.stdpath("state"),
        })
      end)

      assert.are_equal(2, #manager.projects)


      local saved_projects = Manager.load_projects(manager.data_path)
      assert.are_equal(2, #saved_projects)
    end)
  end)


  it("add projects repeatedly", function()
    assert.no_errors(function()
      local manager = Manager:new({
        session_root = session_root,
        session_options = session_options,
        project_root_patterns = project_root_patterns,
      })
      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("cache"),
          vim.fn.stdpath("state")
        })
      end)
      assert.are_equal(2, #manager.projects)

      assert.no_errors(function()
        manager:update_projects({
          vim.fn.stdpath("cache"),
          vim.fn.stdpath("state"),
          project_path,
          project_path,
          project_path,
          project_path,
          project_path,
        })
      end)

      assert.are_equal(3, #manager.projects)


      local saved_projects = Manager.load_projects(manager.data_path)
      assert.are_equal(3, #saved_projects)
    end)
  end)
end)
