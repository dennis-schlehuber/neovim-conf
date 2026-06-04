local jdtls = require('jdtls')
local mason_packages = vim.fn.stdpath('data') .. '/mason/packages'

local function get_bundles()
  local bundles = {}
  -- java-debug-adapter
  local debug_glob = mason_packages .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'
  vim.list_extend(bundles, vim.split(vim.fn.glob(debug_glob), '\n', { trimempty = true }))
  -- java-test
  local test_glob = mason_packages .. '/java-test/extension/server/*.jar'
  vim.list_extend(bundles, vim.split(vim.fn.glob(test_glob), '\n', { trimempty = true }))
  return bundles
end

local lombok_jar = vim.fn.expand('~/.local/share/jdtls/lombok.jar')
local cmd = { 'jdtls' }
if vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(cmd, '--jvm-arg=-javaagent:' .. lombok_jar)
  table.insert(cmd, '--jvm-arg=-Xbootclasspath/a:' .. lombok_jar)
end

local root_dir = vim.fs.root(0, { 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git' })
local project_name = root_dir and vim.fn.fnamemodify(root_dir, ':t') or 'default'
local workspace_dir = vim.fn.expand('~/.local/share/jdtls/workspaces/') .. project_name
vim.list_extend(cmd, { '-data', workspace_dir })

jdtls.start({
  cmd = cmd,
  root_dir = root_dir,
  settings = {
    java = {
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      configuration = { updateBuildConfiguration = 'automatic' },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      import = {
        gradle = { enabled = true, wrapper = { enabled = true } },
        maven = { enabled = true },
      },
      autobuild = { enabled = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
    },
  },
  init_options = {
    bundles = get_bundles(),
  },
  on_attach = function()
    jdtls.setup_dap({ hotcodereplace = 'auto' })
  end,
})

-- Java-specific keymaps
local map = function(mode, key, fn, desc)
  vim.keymap.set(mode, key, fn, { buffer = 0, desc = 'Java: ' .. desc })
end

map('n', '<leader>ji', jdtls.organize_imports,                                   'Organize imports')
map('n', '<leader>jv', jdtls.extract_variable,                                   'Extract variable')
map('v', '<leader>jv', function() jdtls.extract_variable(true) end,              'Extract variable')
map('n', '<leader>jm', jdtls.extract_method,                                     'Extract method')
map('v', '<leader>jm', function() jdtls.extract_method(true) end,                'Extract method')
map('n', '<leader>jt', jdtls.test_class,                                         'Run test class')
map('n', '<leader>jn', jdtls.test_nearest_method,                                'Run nearest test')
map('n', '<leader>jd', function() jdtls.test_nearest_method({ debug = true }) end, 'Debug nearest test')
