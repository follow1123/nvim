return {
  -- 颜色显示
  "norcalli/nvim-colorizer.lua",
  cmd = "ColorizerToggle",
  opts = {
    "*",
    css = { rgb_fn = true, }, -- Enable parsing rgb(...) functions in css.
    html = { names = false, } -- Disable parsing "names" like Blue or Gray
  }
}
