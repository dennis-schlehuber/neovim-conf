require('nvim-treesitter').setup({
  ensure_installed = {
    'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust',
    'jsdoc', 'bash', 'java', 'kotlin', 'svelte', 'html', 'css', 'go',
    'python',
  },
  auto_install = true,
})

-- Disable markdown injections to avoid nvim-treesitter/Neovim 0.12 incompatibility
-- (set-lang-from-info-string! directive crashes when match returns a range table instead of TSNode)
vim.treesitter.query.set('markdown', 'injections', '')
