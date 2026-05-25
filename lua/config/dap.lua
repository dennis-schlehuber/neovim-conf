local dap = require('dap')
local dapui = require('dapui')

-- Inline variable values while debugging
require('nvim-dap-virtual-text').setup({
  commented = true,
})

-- DAP UI layout
dapui.setup({
  icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
  layouts = {
    {
      elements = {
        { id = 'scopes',      size = 0.4 },
        { id = 'breakpoints', size = 0.2 },
        { id = 'stacks',      size = 0.2 },
        { id = 'watches',     size = 0.2 },
      },
      position = 'left',
      size = 40,
    },
    {
      elements = {
        { id = 'repl',    size = 0.5 },
        { id = 'console', size = 0.5 },
      },
      position = 'bottom',
      size = 12,
    },
  },
})

-- Auto open/close UI with session
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

-- Signs
vim.fn.sign_define('DapBreakpoint',          { text = '●', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DapBreakpointRejected',  { text = '○', texthl = 'DiagnosticHint' })
vim.fn.sign_define('DapStopped',             { text = '▶', texthl = 'DiagnosticOk', linehl = 'DapStoppedLine' })

-- ── Adapters ────────────────────────────────────────────────────────────────

-- Python — requires: uv add --dev debugpy  (or pip install debugpy)
local function find_python()
  -- Prefer activated venv
  local venv = os.getenv('VIRTUAL_ENV')
  if venv then return venv .. '/bin/python' end
  -- Search project root for common venv dirs (works with uv, venv, poetry, etc.)
  local root = vim.fn.getcwd()
  for _, name in ipairs({ '.venv', 'venv', 'env', '.env' }) do
    for _, bin in ipairs({ '/bin/python3', '/bin/python' }) do
      local python = root .. '/' .. name .. bin
      if vim.fn.executable(python) == 1 then return python end
    end
  end
  return vim.fn.exepath('python3') or 'python3'
end

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    cb({ type = 'server', port = config.port or 5678, host = config.host or '127.0.0.1' })
  else
    -- Use the same python as the program so debugpy is found in the venv
    cb({
      type = 'executable',
      command = config.pythonPath or find_python(),
      args = { '-m', 'debugpy.adapter' },
    })
  end
end
dap.configurations.python = {
  {
    type = 'python', request = 'launch', name = 'Launch file',
    program = '${file}',
    pythonPath = find_python,
  },
}

-- Node / TypeScript — requires: npm install -g js-debug-adapter
-- (or install via mason: MasonInstall js-debug-adapter)
dap.adapters['pwa-node'] = {
  type = 'server', host = 'localhost', port = '${port}',
  executable = {
    command = 'node',
    args = {
      vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
      '${port}',
    },
  },
}
for _, lang in ipairs({ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }) do
  dap.configurations[lang] = {
    { type = 'pwa-node', request = 'launch', name = 'Launch file', program = '${file}', cwd = '${workspaceFolder}' },
    { type = 'pwa-node', request = 'attach', name = 'Attach to process', processId = require('dap.utils').pick_process, cwd = '${workspaceFolder}' },
  }
end

-- Go — requires: go install github.com/go-delve/delve/cmd/dlv@latest
dap.adapters.delve = {
  type = 'server', port = '${port}',
  executable = { command = 'dlv', args = { 'dap', '-l', '127.0.0.1:${port}' } },
}
dap.configurations.go = {
  { type = 'delve', name = 'Debug',      request = 'launch', program = '${file}' },
  { type = 'delve', name = 'Debug test', request = 'launch', mode = 'test', program = '${file}' },
}

-- ── Keymaps ─────────────────────────────────────────────────────────────────
local map = function(key, fn, desc) vim.keymap.set('n', key, fn, { desc = 'DAP: ' .. desc }) end

map('<leader>dc', dap.continue,          'Continue / Start')
map('<leader>di', dap.step_into,         'Step into')
map('<leader>dn', dap.step_over,         'Step over')
map('<leader>dO', dap.step_out,          'Step out')
map('<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
map('<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Condition: '))
end, 'Conditional breakpoint')
map('<leader>dl', function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log message: '))
end, 'Log point')
map('<leader>dt', dap.terminate,         'Terminate')
map('<leader>dr', dap.repl.open,         'Open REPL')
map('<leader>du', dapui.toggle,          'Toggle UI')
