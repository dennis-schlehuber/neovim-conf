-- LSP Configuration using Neovim 0.11+ built-in LSP with nvim-lspconfig

-- Common on_attach function for LSP keymaps
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Mappings
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Navigation (using Telescope for better cross-file support)
  vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, vim.tbl_extend('force', bufopts, { desc = 'Go to declaration' }))
  
  vim.keymap.set('n', '<leader>gd', function()
    require('telescope.builtin').lsp_definitions()
  end, vim.tbl_extend('force', bufopts, { desc = 'Go to definition' }))

  vim.keymap.set('n', '<leader>cc', function()
    require('telescope.builtin').lsp_definitions()
  end, vim.tbl_extend('force', bufopts, { desc = 'Go to definition (tag jump)' }))
  
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
  vim.keymap.set('n', '<leader>,', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code action' }))
  vim.keymap.set('v', '<leader>,', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code action' }))
  
  -- Rename
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = 'Rename' }))
  
  -- References
  vim.keymap.set('n', 'grr', function()
    require('telescope.builtin').lsp_references()
  end, vim.tbl_extend('force', bufopts, { desc = 'Find references' }))

  -- Code lens (inline usage counts)
  vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, vim.tbl_extend('force', bufopts, { desc = 'Run code lens' }))

end

-- Set up LspAttach autocommand to apply on_attach for all servers
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      on_attach(client, args.buf)
      if client.supports_method('textDocument/codeLens') then
        vim.lsp.codelens.refresh({ bufnr = args.buf })
      end
    end
  end,
})

-- Keep code lenses fresh
vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost' }, {
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    for _, client in ipairs(clients) do
      if client.supports_method('textDocument/codeLens') then
        vim.lsp.codelens.refresh({ bufnr = args.buf })
        break
      end
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
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      preferences = {
        includePackageJsonAutoImports = 'on',
      },
    },
    javascript = {
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      preferences = {
        includePackageJsonAutoImports = 'on',
      },
    },
  },
})

-- Kotlin
-- Force Java 21 via cmd_env: system JAVA_HOME points to Java 24 (Temurin) which
-- breaks kotlin-language-server 1.3.13 (built for Java 21).
vim.lsp.config('kotlin_language_server', {
  cmd_env = {
    JAVA_HOME = '/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home',
  },
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
local lombok_jar = vim.fn.expand('~/.local/share/jdtls/lombok.jar')
local jdtls_cmd = { 'jdtls' }
if vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(jdtls_cmd, '--jvm-arg=-javaagent:' .. lombok_jar)
  table.insert(jdtls_cmd, '--jvm-arg=-Xbootclasspath/a:' .. lombok_jar)
end

vim.lsp.config('jdtls', {
  cmd = jdtls_cmd,
  settings = {
    java = {
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      configuration = {
        updateBuildConfiguration = 'automatic',
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      -- Lombok: allow annotation processors
      autobuild = { enabled = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
})

-- Spring Boot Language Server
vim.lsp.config('spring_boot', {
  cmd = { 'spring-boot-language-server' },
  filetypes = { 'java', 'kotlin' },
  root_markers = { 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git' },
  settings = {
    spring_boot = {
      ls = {
        problem = {
          application_properties = { other = { SHOW = 'WARNING' } },
        },
      },
    },
  },
})

-- Svelte
vim.lsp.config('svelte', {})

-- Go
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      codelenses = {
        references = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        gc_details = false,
      },
    },
  },
})

-- XML
vim.lsp.config('lemminx', {})

-- HTML
vim.lsp.config('html', {})

-- CSS
vim.lsp.config('cssls', {})

-- Python
vim.lsp.config('pyright', {
  on_init = function(client)
    local root = client.config.root_dir
    if not root then return end
    -- Try common venv directory names
    for _, name in ipairs({ '.venv', 'venv', 'env', '.env' }) do
      for _, bin in ipairs({ '/bin/python3', '/bin/python' }) do
        local python = root .. '/' .. name .. bin
        if vim.fn.executable(python) == 1 then
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
            python = { pythonPath = python },
          })
          client.notify('workspace/didChangeConfiguration', { settings = nil })
          return
        end
      end
    end
  end,
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
vim.lsp.enable('ts_ls')                   -- TypeScript/JavaScript/React
vim.lsp.enable('kotlin_language_server')  -- Kotlin
vim.lsp.enable('jdtls')                   -- Java (with Lombok)
vim.lsp.enable('spring_boot')             -- Spring Boot (Java/Kotlin)
vim.lsp.enable('svelte')                  -- Svelte
vim.lsp.enable('gopls')                   -- Go
vim.lsp.enable('lemminx')                 -- XML
vim.lsp.enable('html')                    -- HTML
vim.lsp.enable('cssls')                   -- CSS
vim.lsp.enable('pyright')                 -- Python

