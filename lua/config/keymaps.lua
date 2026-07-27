-- Set leader key to spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Buffer navigation
vim.keymap.set('n', '<S-h>', '<cmd>bprev<CR>', { desc = 'Buffer: Previous' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Buffer: Next' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Buffer: Close' })

-- Window navigation
vim.keymap.set('n', '<leader><Left>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader><Right>', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('n', '<leader><Up>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<leader><Down>', '<C-w>j', { desc = 'Move to lower window' })

-- Split current file to the right; close with <leader>fc
vim.keymap.set('n', '<leader>fo', '<cmd>vsplit<CR><C-w>l', { desc = 'Window: Open current file in right split' })
vim.keymap.set('n', '<leader>fc', '<cmd>close<CR>', { desc = 'Window: Close current split' })

-- File explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

-- Paste without overwriting register (visual mode)
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle undotree' })

-- Aerial (file outline)
vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle<CR>', { desc = 'Toggle file outline' })

-- LSP Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>.', vim.diagnostic.open_float, { desc = 'Show diagnostic error message' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Telescope LSP keymaps (wrapped in functions to handle lazy loading)
local function safe_telescope_keymap(key, func_name, desc)
  vim.keymap.set('n', key, function()
    local ok, builtin = pcall(require, 'telescope.builtin')
    if ok and builtin[func_name] then
      builtin[func_name]()
    else
      vim.notify('Telescope not available', vim.log.levels.WARN)
    end
  end, { desc = desc })
end

safe_telescope_keymap('<leader>lr', 'lsp_references', 'LSP: References')
safe_telescope_keymap('<leader>ll', 'lsp_references', 'LSP: References')
safe_telescope_keymap('<leader>ld', 'lsp_definitions', 'LSP: Definitions')
safe_telescope_keymap('<leader>li', 'lsp_implementations', 'LSP: Implementations')
safe_telescope_keymap('<leader>lt', 'lsp_type_definitions', 'LSP: Type definitions')
safe_telescope_keymap('<leader>ls', 'lsp_document_symbols', 'LSP: Document symbols')
safe_telescope_keymap('<leader>lS', 'lsp_workspace_symbols', 'LSP: Workspace symbols')

-- Project notes
vim.keymap.set('n', '<leader>n', function() require('config.project-notes').open() end, { desc = 'Open project notes' })

-- Open cwd in IntelliJ IDEA
vim.keymap.set('n', '<leader>ij', function()
  vim.system({ vim.fn.expand('~/Library/Application Support/JetBrains/Toolbox/scripts/idea'), vim.fn.getcwd() }, { detach = true })
end, { desc = 'Open cwd in IntelliJ IDEA' })

-- Open cwd in PyCharm
vim.keymap.set('n', '<leader>ip', function()
  vim.system({ vim.fn.expand('~/Library/Application Support/JetBrains/Toolbox/scripts/pycharm'), vim.fn.getcwd() }, { detach = true })
end, { desc = 'Open cwd in PyCharm' })
