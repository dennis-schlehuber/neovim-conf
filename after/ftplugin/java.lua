local jdtls = require('jdtls')

-- Without a project root jdtls can't index anything useful; bail out early.
local root_dir = vim.fs.root(0, { 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git' })
if not root_dir then return end

local mason_packages = vim.fn.stdpath('data') .. '/mason/packages'
local workspace_dir  = vim.fn.stdpath('data') .. '/jdtls-workspaces/' .. vim.fn.fnamemodify(root_dir, ':t')

local function get_bundles()
  local bundles = {}
  local globs = {
    mason_packages .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar',
    mason_packages .. '/java-test/extension/server/*.jar',
  }
  for _, g in ipairs(globs) do
    vim.list_extend(bundles, vim.split(vim.fn.glob(g), '\n', { trimempty = true }))
  end
  return bundles
end

local cmd = { 'jdtls', '-data', workspace_dir }
local lombok_jar = vim.fn.expand('~/.local/share/jdtls/lombok.jar')
if vim.fn.filereadable(lombok_jar) == 1 then
  vim.list_extend(cmd, {
    '--jvm-arg=-javaagent:' .. lombok_jar,
    '--jvm-arg=-Xbootclasspath/a:' .. lombok_jar,
  })
end

jdtls.start({
  cmd          = cmd,
  root_dir     = root_dir,

  on_init = function(client)
    -- jdtls semantic tokens use @lsp.type.X.java groups that have higher priority than
    -- treesitter extmarks but aren't themed → text renders plain. Let treesitter own it.
    client.server_capabilities.semanticTokensProvider = nil
  end,

  on_attach = function()
    jdtls.setup_dap({ hotcodereplace = 'auto' })
  end,

  settings = {
    java = {
      configuration     = { updateBuildConfiguration = 'automatic' },
      eclipse           = { downloadSources = true },
      maven             = { downloadSources = true },
      import            = {
        gradle = { enabled = true, wrapper = { enabled = true } },
        maven  = { enabled = true },
      },
      autobuild         = { enabled = true },
      signatureHelp     = { enabled = true },
      contentProvider   = { preferred = 'fernflower' },
      referencesCodeLens      = { enabled = true },
      implementationsCodeLens = { enabled = true },
      sources           = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
    },
  },

  init_options = { bundles = get_bundles() },
})

local map = function(mode, key, fn, desc)
  vim.keymap.set(mode, key, fn, { buffer = 0, desc = 'Java: ' .. desc })
end

map('n', '<leader>ji',  jdtls.organize_imports,                                    'Organize imports')
map('n', '<leader>jv',  jdtls.extract_variable,                                    'Extract variable')
map('v', '<leader>jv',  function() jdtls.extract_variable(true) end,               'Extract variable')
map('n', '<leader>jm',  jdtls.extract_method,                                      'Extract method')
map('v', '<leader>jm',  function() jdtls.extract_method(true) end,                 'Extract method')
map('n', '<leader>jt',  jdtls.test_class,                                          'Run test class')
map('n', '<leader>jn',  jdtls.test_nearest_method,                                 'Run nearest test')
map('n', '<leader>jd',  function() jdtls.test_nearest_method({ debug = true }) end, 'Debug nearest test')
