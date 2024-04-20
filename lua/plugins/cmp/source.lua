local source = {
  -- 默认补全source
  global_sources = {
      { group_index = 1, name = "luasnip", priority = 997, max_item_count = 5 },
      { group_index = 1, name = "path" },
  },
}

-- 查找是否有重复的源，返回重复的个数
local function contains_source(sources, ...)
  local match_count = 0
  local new_sources = {...}
  for _, value in ipairs(sources)do
    for _, v in ipairs(new_sources) do
      if value.name == v.name then
        match_count = match_count + 1
        if match_count == #new_sources then return match_count end
      end
    end
  end
  return match_count
end


-- 在当前buffer内添加source
local function buf_add_source(bufnr, ...)
  local new_sources = {...}
  if package.loaded["cmp.config"] then
    local cmp_config = require("cmp.config")
    local buf_config = cmp_config.buffers[bufnr]
    if buf_config then
      if contains_source(buf_config.sources, ...) == 0 then
        vim.list_extend(buf_config.sources, new_sources)
      end
    else
      local global_sources = cmp_config.global.sources and cmp_config.global.sources or source.global_sources
      if contains_source(global_sources, ...) == 0 then
        cmp_config.set_buffer({
          sources = vim.list_extend(new_sources, global_sources)
        }, bufnr)
      end
    end
  end
end

-- 加载buffer的source
source.load_buffer_cmp = function(bufnr)
  bufnr = bufnr and bufnr or vim.api.nvim_get_current_buf()
  local max_filesize = 1024 * 1024 -- 1M
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size <= max_filesize then
    if not package.loaded["cmp_buffer"] then
      require("cmp_buffer")
    end
    buf_add_source(bufnr, {
      group_index = 1,
      name = "buffer",
      keyword_length = 3,
      priority = 996,
      max_item_count  = 3,
      option = {
        indexing_interval = 500, -- 索引扫描间隔
        indexing_batch_size = 400, -- 索引扫描行数
      }
    })
  end
end

-- 加载lsp的source
source.load_lsp_cmp = function(bufnr)
  bufnr = bufnr and bufnr or vim.api.nvim_get_current_buf()

  if #vim.lsp.get_active_clients({bufnr = bufnr}) ~= 0 then
    if not package.loaded["cmp_nvim_lsp"] or not package.loaded["cmp_nvim_lsp_signature_help"] then
      require("cmp_nvim_lsp")
      require("cmp_nvim_lsp_signature_help")
    end
    buf_add_source(bufnr,
      { group_index = 1, name = "nvim_lsp", priority = 999 },
      { group_index = 1, name = "nvim_lsp_signature_help", priority = 998}
    )
  end
end

-- lsp 关联是加载lsp补全
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*",
  nested = true,
  callback = function(e)
    source.load_lsp_cmp(e.buf)
  end
})

-- 打开文件时加载buffer、treesitter补全
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  nested = true,
  callback = function(e)
    source.load_buffer_cmp(e.buf)
  end
})

return source
