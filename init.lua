-- Load keymaps (must come before plugins so leader key is set)
require('config.keymaps')

-- Bootstrap lazy.nvim and load plugins
require('plugins')

-- Load set configuration
require('config.set')

-- LSP configuration is loaded via plugins.lua (nvim-lspconfig config function)
-- Telescope configuration is loaded via plugins.lua (telescope config function)

vim.opt.guicursor = "i:ver25"
