require('mason').setup()

require('mason-lspconfig').setup({
  automatic_enable = {
    exclude = { 'pylsp' },
  },
  ensure_installed = {
    'ts_ls',
    'kotlin_language_server',
    'jdtls',
    'svelte',
    'gopls',
    'lemminx',
    'html',
    'cssls',
    'pyright',
    -- spring_boot is not in the mason registry; install manually
  },
})

require('mason-tool-installer').setup({
  ensure_installed = {
    'prettier',
    'stylua',
    'ktlint',
    'ruff',
    'java-debug-adapter',
    'java-test',
    -- google-java-format installed via: brew install google-java-format
  },
})
