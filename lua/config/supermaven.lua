require('supermaven-nvim').setup({
  keymaps = {
    accept_suggestion = '<Tab>',
    clear_suggestion = '<C-]>',
    accept_word = '<C-j>',
  },
  ignore_filetypes = { 'TelescopePrompt' },
  color = {
    suggestion_color = '#6b7280', -- subtle grey ghost text
  },
})
