require('mason').setup()

require('mason-lspconfig').setup({
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
  },
})
