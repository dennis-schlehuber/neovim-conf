require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust',
    'jsdoc', 'bash', 'java', 'kotlin', 'svelte', 'html', 'css', 'go',
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})
