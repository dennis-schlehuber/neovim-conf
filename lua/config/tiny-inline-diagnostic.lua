require('tiny-inline-diagnostic').setup({
  preset = 'modern',
  options = {
    show_source         = true,
    throttle            = 20,
    softwrap            = 30,
    multiple_diag_under_cursor = true,
    multilines          = {
      enabled    = true,
      always_show = false,
    },
  },
})
