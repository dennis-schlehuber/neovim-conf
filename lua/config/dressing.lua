require('dressing').setup({
  input = {
    border = 'rounded',
    relative = 'cursor',
    prefer_width = 40,
    win_options = { winblend = 0 },
  },
  select = {
    backend = { 'telescope', 'builtin' },
    builtin = { border = 'rounded' },
  },
})
