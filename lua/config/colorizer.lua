require('colorizer').setup({
  filetypes = {
    'css', 'scss', 'sass', 'less',
    'html',
    'javascript', 'javascriptreact',
    'typescript', 'typescriptreact',
    'lua', 'vim', 'json', 'yaml',
  },
  user_default_options = {
    RGB      = true,
    RRGGBB   = true,
    names    = false,
    RRGGBBAA = true,
    AARRGGBB = true,
    rgb_fn   = true,
    hsl_fn   = true,
    css      = true,
    css_fn   = true,
    mode     = 'background',
    tailwind = true,
  },
})
