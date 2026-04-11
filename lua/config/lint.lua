local lint = require('lint')

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
vim.keymap.set('n', '<leader>cl', function() lint.try_lint() end, { desc = 'Lint: Run linter' })
