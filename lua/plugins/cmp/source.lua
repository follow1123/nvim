return {
  { name = "nvim_lsp_signature_help", group_index = 1, priority = 999},
  { name = "nvim_lsp", group_index = 1, priority = 998 },
  { name = "luasnip", group_index = 1, priority = 997, max_item_count = 3 },
  {
    name = "buffer",group_index = 1, priority = 996,
    keyword_length = 3, max_item_count  = 3,
    option = {
      indexing_interval = 500, -- 索引扫描间隔
      indexing_batch_size = 400, -- 索引扫描行数
      get_bufnrs = function()
        local buf = vim.api.nvim_get_current_buf()
        local byte_size = vim.api.nvim_buf_get_offset(
          buf, vim.api.nvim_buf_line_count(buf))
        if byte_size > 1024 * 1024 then -- 1 Megabyte max
          return {}
        end
        return { buf }
      end
    }
  },
  {  name = "path", group_index = 2 }
}
