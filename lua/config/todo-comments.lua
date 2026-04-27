require('todo-comments').setup({
  signs = true,
  keywords = {
    FIX  = { icon = ' ', color = 'error',   alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
    TODO = { icon = ' ', color = 'info' },
    HACK = { icon = ' ', color = 'warning' },
    WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
    NOTE = { icon = '󰍨 ', color = 'hint',    alt = { 'INFO' } },
    PERF = { icon = '󰅒 ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
  },
  highlight = {
    before  = '',
    keyword = 'wide_bg',
    after   = 'fg',
    pattern = [[.*<(KEYWORDS)\s*:]],
  },
})

vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope<CR>', { desc = 'Search TODOs' })
