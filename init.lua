-- 设置需要加载的配置文件目录
vimConfigPath = string.sub(debug.getinfo(1).source, 2, string.len("/init.lua") * -1)
baseConfigPath = vimConfigPath .. "config-lua" 
pluginConfigPath = vimConfigPath .. "config-lua/plugin" 
package.path = ";" .. baseConfigPath .. "/?.lua;" .. package.path
package.path = ";" .. pluginConfigPath .. "/?.lua;" .. package.path
-- 定义全局变量
map = vim.api.nvim_set_keymap
Plug = vim.fn ['plug#']
-- 配置的配置
require "conf"
-- 基础配置
require "base"
-- 基础按键映射配置
require "baseKeyMapping"
-- 插件配置
require "plugin"
-- 释放内存
map = nil
Plug = nil
vimConfigPath = nil
baseConfigPath = nil
pluginConfigPaht = nil
