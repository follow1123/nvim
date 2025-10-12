-- 取消注释后，lsp会自动加载相关方法
-- require("plenary.test_harness")

local FiletypeManager = require("extensions.ft_config.filetype_manager")
local config_path = vim.fs.joinpath(vim.fn.stdpath("cache"), "config.json")


describe("save status rules", function()
  after_each(function()
    local stat = vim.uv.fs_stat(config_path)
    if stat then
      local success, err = vim.uv.fs_unlink(config_path)
      assert.are_true(success, err)
    end
  end)

  it("save empty config", function()
    FiletypeManager.save_status_rules(config_path, {
      working_dir_rule = {},
      file_rule = {}
    })
    local content = vim.fn.readfile(config_path)
    assert.are_equal(1, #content)
    local sr = vim.json.decode(content[1])
    assert.not_nil(sr)
    assert.are_equal(0, #sr.working_dir_rule)
    assert.are_equal(0, #sr.file_rule)
  end)

  it("save config", function()
    FiletypeManager.save_status_rules(config_path, {
      working_dir_rule = {
        {
          working_dir = "/a/b/c",
          exclude_filetype = {},
          enabled = true
        }
      },
      file_rule = {
        {
          file_path = "/b/c/d",
          enabled = false
        }
      }
    })
    local content = vim.fn.readfile(config_path)
    assert.are_equal(1, #content)
    local sr = vim.json.decode(content[1])
    assert.not_nil(sr)
    assert.are_equal(true, sr.working_dir_rule[1].enabled)
    assert.are_equal("/a/b/c", sr.working_dir_rule[1].working_dir)
    assert.are_equal(0, #sr.working_dir_rule[1].exclude_filetype)

    assert.are_equal(false, sr.file_rule[1].enabled)
    assert.are_equal("/b/c/d", sr.file_rule[1].file_path)
  end)
end)

describe("load status rules", function()
  after_each(function()
    local stat = vim.uv.fs_stat(config_path)
    if stat then
      local success, err = vim.uv.fs_unlink(config_path)
      assert.are_true(success, err)
    end
  end)

  it("no config file", function()
    local sr = FiletypeManager.load_config(config_path)

    assert.not_nil(sr)
    assert.are_equal(0, #sr.file_rule)
    assert.are_equal(0, #sr.working_dir_rule)
  end)

  it("load status rules when created", function()
    vim.fn.writefile({ [[{
  "working_dir_rule": [ { "working_dir": "/working/dir/path", "exclude_filetype": [], "enabled": true } ],
  "file_rule": [ { "file_path": "/target/disabled/file/path", "enabled": true } ]
}]] }, config_path)

    local sr = FiletypeManager.load_config(config_path)

    assert.not_nil(sr)
    assert.are_equal("/target/disabled/file/path",
      sr.file_rule[1].file_path)
    assert.are_equal(true,
      sr.file_rule[1].enabled)
    assert.are_equal("/working/dir/path", sr.working_dir_rule[1].working_dir)
    assert.are_equal(0, #sr.working_dir_rule[1].exclude_filetype)
    assert.are_equal(true, sr.working_dir_rule[1].enabled)
  end)
end)


describe("test working dir and filetype", function()
  after_each(function()
    local stat = vim.uv.fs_stat(config_path)
    if stat then
      local success, err = vim.uv.fs_unlink(config_path)
      assert.are_true(success, err)
    end
  end)

  it("enable working dir", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    ftm:enable_working_dir("/d/e/f")
    assert.are_equal(2, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[2].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/d/e/f", ftm.status_rules.working_dir_rule[2].working_dir)
  end)

  it("disable working dir", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:disable_working_dir("/a/b/c")
    assert.are_equal(0, #ftm.status_rules.working_dir_rule)
  end)

  it("enable disabled working dir", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    ftm:disable_working_dir("/a/b/c")
    assert.are_equal(0, #ftm.status_rules.working_dir_rule)

    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)
  end)

  it("disable enabled working dir", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    ftm:disable_working_dir("/a/b/c")
    assert.are_equal(0, #ftm.status_rules.working_dir_rule)
  end)

  it("enable filetype", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    ftm:enable_working_dir("/a/b/c", "lua")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    ftm:enable_working_dir("/d/e/f", "vimscript")
    assert.are_equal(2, #ftm.status_rules.working_dir_rule)
    assert.are_equal(false, ftm.status_rules.working_dir_rule[2].enabled)
    assert.are_equal("vimscript", ftm.status_rules.working_dir_rule[2].exclude_filetype[1])
    assert.are_equal("/d/e/f", ftm.status_rules.working_dir_rule[2].working_dir)

    ftm:enable_working_dir("/d/e/f", "c")
    assert.are_equal(2, #ftm.status_rules.working_dir_rule)
    assert.are_equal(false, ftm.status_rules.working_dir_rule[2].enabled)
    assert.are_equal("c", ftm.status_rules.working_dir_rule[2].exclude_filetype[2])
    assert.are_equal("/d/e/f", ftm.status_rules.working_dir_rule[2].working_dir)
  end)

  it("disable filetype", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:disable_working_dir("/a/b/c", "lua")
    assert.are_equal(0, #ftm.status_rules.working_dir_rule)
  end)

  it("enable disabled filetype", function()
    local ftm = FiletypeManager:new(config_path)

    ftm:enable_working_dir("/a/b/c")
    ftm:disable_working_dir("/a/b/c", "vimscript")
    ftm:disable_working_dir("/a/b/c", "lua")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(2, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("vimscript", ftm.status_rules.working_dir_rule[1].exclude_filetype[1])
    assert.are_equal("lua", ftm.status_rules.working_dir_rule[1].exclude_filetype[2])

    ftm:enable_working_dir("/a/b/c", "lua")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("vimscript", ftm.status_rules.working_dir_rule[1].exclude_filetype[1])

    ftm:enable_working_dir("/a/b/c", "vimscript")
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
  end)

  it("disable enabled filetype", function()
    local ftm = FiletypeManager:new(config_path)

    ftm:enable_working_dir("/a/b/c", "vimscript")
    ftm:enable_working_dir("/a/b/c", "lua")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)
    assert.are_equal(false, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(2, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("vimscript", ftm.status_rules.working_dir_rule[1].exclude_filetype[1])
    assert.are_equal("lua", ftm.status_rules.working_dir_rule[1].exclude_filetype[2])


    ftm:disable_working_dir("/a/b/c", "lua")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("vimscript", ftm.status_rules.working_dir_rule[1].exclude_filetype[1])

    ftm:disable_working_dir("/a/b/c", "vimscript")
    assert.are_equal(0, #ftm.status_rules.working_dir_rule)
  end)
end)

describe("test file path", function()
  after_each(function()
    local stat = vim.uv.fs_stat(config_path)
    if stat then
      local success, err = vim.uv.fs_unlink(config_path)
      assert.are_true(success, err)
    end
  end)

  it("enable file path", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(true, ftm.status_rules.file_rule[1].enabled)
    assert.are_equal("/a/b/c/d.txt", ftm.status_rules.file_rule[1].file_path)

    ftm:enable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)

    ftm:enable_file_path("/a/b/c/e.txt")
    assert.are_equal(2, #ftm.status_rules.file_rule)
    assert.are_equal(true, ftm.status_rules.file_rule[2].enabled)
    assert.are_equal("/a/b/c/e.txt", ftm.status_rules.file_rule[2].file_path)
  end)

  it("disable file path", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:disable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(false, ftm.status_rules.file_rule[1].enabled)
    assert.are_equal("/a/b/c/d.txt", ftm.status_rules.file_rule[1].file_path)

    ftm:disable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)

    ftm:disable_file_path("/a/b/c/e.txt")
    assert.are_equal(2, #ftm.status_rules.file_rule)
    assert.are_equal(false, ftm.status_rules.file_rule[2].enabled)
    assert.are_equal("/a/b/c/e.txt", ftm.status_rules.file_rule[2].file_path)
  end)

  it("enable disabled file path", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:disable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(false, ftm.status_rules.file_rule[1].enabled)
    assert.are_equal("/a/b/c/d.txt", ftm.status_rules.file_rule[1].file_path)

    ftm:enable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(true, ftm.status_rules.file_rule[1].enabled)
  end)

  it("disable enabled file path", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(true, ftm.status_rules.file_rule[1].enabled)
    assert.are_equal("/a/b/c/d.txt", ftm.status_rules.file_rule[1].file_path)

    ftm:disable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(false, ftm.status_rules.file_rule[1].enabled)
  end)
end)

describe("test reset working dir", function()
  after_each(function()
    local stat = vim.uv.fs_stat(config_path)
    if stat then
      local success, err = vim.uv.fs_unlink(config_path)
      assert.are_true(success, err)
    end
  end)

  it("reset", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    ftm:enable_working_dir("/d/e/f")
    assert.are_equal(2, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[2].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/d/e/f", ftm.status_rules.working_dir_rule[2].working_dir)

    ftm:reset_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)

    ftm:reset_working_dir("/d/e/f")
    assert.are_equal(0, #ftm.status_rules.working_dir_rule)
  end)
end)

describe("test reset file path", function()
  after_each(function()
    local stat = vim.uv.fs_stat(config_path)
    if stat then
      local success, err = vim.uv.fs_unlink(config_path)
      assert.are_true(success, err)
    end
  end)

  it("reset", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(true, ftm.status_rules.file_rule[1].enabled)
    assert.are_equal("/a/b/c/d.txt", ftm.status_rules.file_rule[1].file_path)
    ftm:enable_file_path("/a/b/c/e.txt")
    assert.are_equal(2, #ftm.status_rules.file_rule)
    assert.are_equal(true, ftm.status_rules.file_rule[2].enabled)
    assert.are_equal("/a/b/c/e.txt", ftm.status_rules.file_rule[2].file_path)

    ftm:reset_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)

    ftm:reset_file_path("/a/b/c/e.txt")
    assert.are_equal(0, #ftm.status_rules.file_rule)
  end)
end)

describe("clean", function()
  after_each(function()
    local stat = vim.uv.fs_stat(config_path)
    if stat then
      local success, err = vim.uv.fs_unlink(config_path)
      assert.are_true(success, err)
    end
  end)

  it("clean work dir and file path", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(true, ftm.status_rules.file_rule[1].enabled)
    assert.are_equal("/a/b/c/d.txt", ftm.status_rules.file_rule[1].file_path)

    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    ftm:clean()

    assert.are_equal(0, #ftm.status_rules.file_rule)
    assert.are_equal(0, #ftm.status_rules.file_rule)
  end)
end)

describe("test is enabled", function()
  after_each(function()
    local stat = vim.uv.fs_stat(config_path)
    if stat then
      local success, err = vim.uv.fs_unlink(config_path)
      assert.are_true(success, err)
    end
  end)

  it("check enabled working dir", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    assert.are_true(ftm:is_working_dir_enabled("/a/b/c", "lua"))
  end)

  it("check disabled working dir", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)

    assert.are_false(ftm:is_working_dir_enabled("/d/e/f", "lua"))
  end)

  it("check enabled filetype", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c", "lua")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)
    assert.are_equal(false, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(1, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("lua", ftm.status_rules.working_dir_rule[1].exclude_filetype[1])

    assert.are_false(ftm:is_working_dir_enabled("/a/b/c", "vimscript"))
    assert.are_true(ftm:is_working_dir_enabled("/a/b/c", "lua"))
  end)

  it("check disabled filetype", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_working_dir("/a/b/c")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule)
    assert.are_equal("/a/b/c", ftm.status_rules.working_dir_rule[1].working_dir)
    assert.are_equal(true, ftm.status_rules.working_dir_rule[1].enabled)
    assert.are_equal(0, #ftm.status_rules.working_dir_rule[1].exclude_filetype)

    ftm:disable_working_dir("/a/b/c", "lua")
    assert.are_equal(1, #ftm.status_rules.working_dir_rule[1].exclude_filetype)
    assert.are_equal("lua", ftm.status_rules.working_dir_rule[1].exclude_filetype[1])

    assert.are_true(ftm:is_working_dir_enabled("/a/b/c", "vimscript"))
    assert.are_false(ftm:is_working_dir_enabled("/a/b/c", "lua"))
  end)

  it("check enabled file path", function()
    local ftm = FiletypeManager:new(config_path)
    ftm:enable_file_path("/a/b/c/d.txt")
    assert.are_equal(1, #ftm.status_rules.file_rule)
    assert.are_equal(true, ftm.status_rules.file_rule[1].enabled)
    assert.are_equal("/a/b/c/d.txt", ftm.status_rules.file_rule[1].file_path)

    assert.are_true(ftm:is_file_path_enabled("/a/b/c/d.txt"))
  end)

  it("check disabled file path", function()
    local ftm = FiletypeManager:new(config_path)
    assert.are_false(ftm:is_file_path_enabled("/a/b/c/d.txt"))
  end)
end)
