require('trouble').setup({
  modes = {
    diagnostics = {
      auto_open = false,
      auto_close = true,   -- close when no more issues
    },
  },
  icons = {
    error       = ' ',
    warning     = ' ',
    hint        = ' ',
    information = ' ',
  },
})

local map = function(key, cmd, desc)
  vim.keymap.set('n', key, cmd, { desc = desc, silent = true })
end

map('<leader>T',  '<cmd>Trouble diagnostics toggle<CR>',              'Trouble: Toggle')
-- Replace the old <leader>dq loclist binding
map('<leader>dq', '<cmd>Trouble diagnostics toggle<CR>',          'Trouble: Workspace diagnostics')
map('<leader>df', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', 'Trouble: File diagnostics')
map('<leader>ds', '<cmd>Trouble symbols toggle<CR>',              'Trouble: Document symbols')
map('<leader>dl', '<cmd>Trouble loclist toggle<CR>',              'Trouble: Location list')
map('<leader>dx', '<cmd>Trouble quickfix toggle<CR>',             'Trouble: Quickfix')
-- Jump between items without opening the panel
map('[q', function() require('trouble').prev({ skip_groups = true, jump = true }) end, 'Trouble: Previous item')
map(']q', function() require('trouble').next({ skip_groups = true, jump = true }) end, 'Trouble: Next item')
