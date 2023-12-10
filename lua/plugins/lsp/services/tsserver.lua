return {
  root_dir = function ()
    local project_dir = vim.fs.find({"package.json", "vue.config.js"}, {
      upward = true,
      type = "file",
      path = vim.fn.expand("%:p:h")
    })
    local root_dir = project_dir[1]
    return vim.fn.fnamemodify(root_dir, ":p:h")
  end
}
