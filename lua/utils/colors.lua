-- ###########################
-- #        颜色配置         #
-- ###########################

local colors = {
  primary = vim.api.nvim_get_hl(0, { name = "Normal" }).bg,

  white_01 = "White",
  white_02 = "#e9e9e9",
  white_03 = "#d4d4d4",
  white_04 = "#cccccc",

  gray_01 = "Gray",
  gray_02 = "#4b4b4b",
  gray_03 = "#303030",
  gray_04 = "#808080",
  gray_05 = "#767676",
  gray_06 = "#707070",
  gray_07 = "#3e3e3e",

  blcak_01 = "Black",
  blcak_02 = "#262626",
  blcak_03 = "#252525",

  blue_01 = "Blue",
  blue_02 = "#1c7ca1",
  blue_03 = "#215e76",
  blue_04 = "#264f78",

  green_01 = "Green",
  green_02 = "#536232",
  green_03 = "#414733",
  green_04 = "#428850",
  green_05 = "#81e043",

  red_01 = "Red",
  red_02 = "#771b1b",
  red_03 = "#552222",
  red_04 = "#f1502f",

  yellow_01 = "Yellow",

  purple_01 = "Purple",
  purple_02 = "#a986c0",
}

return colors
