-- LSP Configuration (Neovim v0.11+)

-- Capabilities for nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp = require('cmp_nvim_lsp')
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Common on_attach function
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Go to definition - use direct LSP function for reliable cross-file navigation
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', bufopts, { desc = 'Go to declaration' }))
  vim.keymap.set('n', 'gd', function()
    vim.lsp.buf.definition()
  end, vim.tbl_extend('force', bufopts, { desc = 'Go to definition' }))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', bufopts, { desc = 'Hover' }))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', bufopts, { desc = 'Go to implementation' }))
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', bufopts, { desc = 'Signature help' }))
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend('force', bufopts, { desc = 'Type definition' }))
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = 'Rename' }))
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code action' }))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', bufopts, { desc = 'References' }))
end

-- Set up global on_attach for all LSP clients
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    on_attach(args.data.client, args.buf)
  end,
})

-- TypeScript/JavaScript/React - Use ts_ls (replaces deprecated tsserver)
vim.lsp.config.ts_ls = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  settings = {
    typescript = {
      preferences = {
        includePackageJsonAutoImports = 'on',
      },
    },
    javascript = {
      preferences = {
        includePackageJsonAutoImports = 'on',
      },
    },
  },
  init_options = {
    preferences = {
      includePackageJsonAutoImports = 'on',
    },
  },
}
vim.lsp.enable('ts_ls')

-- Go
vim.lsp.config.gopls = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', 'go.work', '.git' },
}
vim.lsp.enable('gopls')

-- Java
vim.lsp.config.jdtls = {
  cmd = { 'jdtls' },
  filetypes = { 'java' },
  root_markers = { '.project', '.classpath', 'pom.xml', 'build.gradle', '.git' },
}
vim.lsp.enable('jdtls')

-- Kotlin
vim.lsp.config.kotlin_language_server = {
  cmd = { 'kotlin-language-server' },
  filetypes = { 'kotlin' },
  root_markers = { 'build.gradle', 'build.gradle.kts', 'settings.gradle', '.git' },
}
vim.lsp.enable('kotlin_language_server')

