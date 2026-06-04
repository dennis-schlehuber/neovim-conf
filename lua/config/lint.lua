local lint = require('lint')

-- Use the venv Python if available (uv projects use .venv), otherwise fall back to system python3
local pylint = lint.linters.pylint
table.insert(pylint.args, 1, 'pylint')
table.insert(pylint.args, 1, '-m')
pylint.cmd = function()
  local venv = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
  if venv ~= '' then
    local venv_python = venv .. '/bin/python3'
    if vim.fn.executable(venv_python) == 1 then
      return venv_python
    end
  end
  return 'python3'
end

lint.linters_by_ft = {
  javascript      = { 'eslint' },
  typescript      = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescriptreact = { 'eslint' },
  svelte          = { 'eslint' },
  python          = { 'pylint' },
  kotlin          = { 'ktlint' },
}

-- Lint on save, buffer read, and leaving insert mode
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  callback = function()
    lint.try_lint()
  end,
})

-- Manual lint trigger
vim.keymap.set('n', '<leader>ln', function() lint.try_lint() end, { desc = 'Lint: Run linter' })
