-- nvim-autopairs configuration

local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

npairs.setup({
  check_ts = true,
  ts_config = {
    lua = { 'string', 'source' },
    javascript = { 'string', 'template_string' },
    java = false,
  },
  disable_filetype = { 'TelescopePrompt', 'vim' },
  fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'PmenuSel',
    highlight_grey = 'LineNr'
  },
})

-- Integrate with nvim-cmp
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

