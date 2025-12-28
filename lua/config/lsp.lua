-- LSP Configuration using Neovim 0.11+ built-in LSP with nvim-lspconfig

-- Common on_attach function for LSP keymaps
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Navigation (using Telescope for better cross-file support)
  vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, vim.tbl_extend('force', bufopts, { desc = 'Go to declaration' }))
  
  vim.keymap.set('n', '<leader>gd', function()
    require('telescope.builtin').lsp_definitions()
  end, vim.tbl_extend('force', bufopts, { desc = 'Go to definition' }))
  
  vim.keymap.set('n', '<leader>gi', function()
    require('telescope.builtin').lsp_implementations()
  end, vim.tbl_extend('force', bufopts, { desc = 'Go to implementation' }))
  
  vim.keymap.set('n', '<leader>D', function()
    require('telescope.builtin').lsp_type_definitions()
  end, vim.tbl_extend('force', bufopts, { desc = 'Type definition' }))
  
  -- Documentation
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', bufopts, { desc = 'Hover documentation' }))
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', bufopts, { desc = 'Signature help' }))
  
  -- Code actions
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code action' }))
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code action' }))
  
  -- Rename
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = 'Rename' }))
  
  -- References
  vim.keymap.set('n', 'grr', function()
    require('telescope.builtin').lsp_references()
  end, vim.tbl_extend('force', bufopts, { desc = 'Find references' }))
  
  -- Formatting
  if client.supports_method('textDocument/formatting') then
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend('force', bufopts, { desc = 'Format buffer' }))
  end
end

-- Set up LspAttach autocommand to apply on_attach for all servers
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      on_attach(client, args.buf)
    end
  end,
})

-- Configure language servers
-- Note: Language servers must be installed separately
-- e.g., npm i -g typescript-language-server, pyright, etc.

-- TypeScript/JavaScript/React
vim.lsp.config('ts_ls', {
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
})

-- Kotlin
vim.lsp.config('kotlin_language_server', {
  settings = {
    kotlin = {
      compiler = {
        jvm = {
          target = 'default',
        },
      },
    },
  },
})

-- Java
vim.lsp.config('jdtls', {
  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = 'automatic',
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
    },
  },
})

-- Svelte
vim.lsp.config('svelte', {})

-- Go
vim.lsp.config('gopls', {})

-- XML
vim.lsp.config('lemminx', {})

-- HTML
vim.lsp.config('html', {})

-- CSS
vim.lsp.config('cssls', {})

-- Python
vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "basic",
      },
    },
  },
})

-- Enable all configured language servers
-- These will auto-start when you open files of the appropriate type
vim.lsp.enable('ts_ls')        -- TypeScript/JavaScript/React
vim.lsp.enable('kotlin_language_server')  -- Kotlin
vim.lsp.enable('jdtls')        -- Java
vim.lsp.enable('svelte')       -- Svelte
vim.lsp.enable('gopls')        -- Go
vim.lsp.enable('lemminx')      -- XML
vim.lsp.enable('html')         -- HTML
vim.lsp.enable('cssls')        -- CSS
vim.lsp.enable('pyright')      -- Python

