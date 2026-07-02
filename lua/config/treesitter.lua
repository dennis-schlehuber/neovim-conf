require('nvim-treesitter').setup({
  ensure_installed = {
    'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust',
    'jsdoc', 'bash', 'java', 'kotlin', 'svelte', 'html', 'css', 'go',
    'python',
  },
  auto_install = true,
})
