require('illuminate').configure({
  providers = { 'lsp', 'treesitter', 'regex' },
  delay = 200,
  filetypes_denylist = { 'neo-tree', 'aerial', 'toggleterm', 'trouble', 'TelescopePrompt' },
  under_cursor = true,
  min_count_to_highlight = 1,
})
