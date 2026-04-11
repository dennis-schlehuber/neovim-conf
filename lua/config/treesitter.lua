-- nvim-treesitter v2 API (Neovim 0.11+)
-- To install a missing parser: :TSInstall <language>

-- nvim-treesitter stores queries under runtime/queries/ but Neovim only adds
-- the plugin root to rtp. Add the runtime subdir so query lookups work.
vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/site/pack/packer/start/nvim-treesitter/runtime')

-- Schedule async installation of all required parsers on startup
require('nvim-treesitter').install({
  'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust',
  'jsdoc', 'bash', 'java', 'kotlin', 'svelte', 'html', 'css', 'go',
})

-- Enable treesitter highlighting for every buffer that has a parser available
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
