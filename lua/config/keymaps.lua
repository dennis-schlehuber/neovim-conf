-- Set leader key to spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- File explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

-- Paste without overwriting register (visual mode)
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle undotree' })

-- LSP Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic error message' })
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
safe_telescope_keymap('<leader>ld', 'lsp_definitions', 'LSP: Definitions')
safe_telescope_keymap('<leader>li', 'lsp_implementations', 'LSP: Implementations')
safe_telescope_keymap('<leader>lt', 'lsp_type_definitions', 'LSP: Type definitions')
safe_telescope_keymap('<leader>ls', 'lsp_document_symbols', 'LSP: Document symbols')
safe_telescope_keymap('<leader>lS', 'lsp_workspace_symbols', 'LSP: Workspace symbols')
