require('scrollbar').setup({
  show_in_active_only = false,
  set_highlights = true,
  handle = {
    blend = 30,
  },
  marks = {
    GitAdd    = { text = '▎' },
    GitChange = { text = '▎' },
    GitDelete = { text = '▎' },
  },
  handlers = {
    cursor      = false,
    diagnostic  = true,
    gitsigns    = true,
    search      = false,
  },
})

require('scrollbar.handlers.gitsigns').setup()
