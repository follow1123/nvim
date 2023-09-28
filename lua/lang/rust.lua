local keymap_uitl = require("utils.keymap")
local nmap = keymap_uitl.nmap

local term_name = "below_term"

local terminal = require("extensions.terminal")

-- 终端没有打开则打开
local function term_toggle()
  local term = terminal.get_term(term_name)
  if not term.is_open() then
    term.toggle()
  end
end

local function rust_test()
  vim.cmd("w")
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  local cur_path = vim.fs.normalize(vim.fn.expand("%:p:r"))
  local test_file = string.gsub(cur_path, cwd, "")
  if not string.match(test_file, "^/tests/") then
    vim.notify("not tests module", vim.log.levels.WARN)
    return
  end
  term_toggle()
  test_file = string.gsub(test_file, "^/tests/", "")
  terminal.send_msg(term_name, string.format("cargo test --test %s -- --nocapture --color always\r", test_file))
end

local function rust_run()
  vim.cmd("w")
  term_toggle()
  terminal.send_msg(term_name, "cargo run\r")
end

nmap("<leader>ct", rust_test, "run cargo test command")

vim.api.nvim_create_user_command("RustTest", rust_test, {
  desc = "run cargo test command"
})

nmap("<leader>cr", rust_run, "cargo run command")

vim.api.nvim_create_user_command("RustRun", rust_run, {
  desc = "cargo run command"
})
