require('bufferline').setup({
  options = {
    mode              = 'buffers',
    numbers           = 'none',
    close_command     = 'bdelete! %d',
    right_mouse_command = 'bdelete! %d',
    left_mouse_command  = 'buffer %d',
    indicator         = { icon = '▎', style = 'icon' },
    buffer_close_icon = '✕',
    modified_icon     = '●',
    close_icon        = '✕',
    left_trunc_marker  = '',
    right_trunc_marker = '',
    diagnostics       = 'nvim_lsp',
    diagnostics_indicator = function(count, level)
      local icon = level:match('error') and ' ' or ' '
      return icon .. count
    end,
    show_buffer_icons       = true,
    show_buffer_close_icons = true,
    show_close_icon         = true,
    show_tab_indicators     = true,
    separator_style         = 'slant',
    always_show_bufferline  = true,
    hover = { enabled = true, delay = 200, reveal = { 'close' } },
  },
})

-- Navigate buffers
vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Buffer: Previous' })
vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Buffer: Next' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>',               { desc = 'Buffer: Close' })
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>',   { desc = 'Buffer: Pin' })
vim.keymap.set('n', '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Buffer: Close unpinned' })
-- Jump to buffer by position
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<CR>', { desc = 'Buffer: Go to ' .. i })
end
