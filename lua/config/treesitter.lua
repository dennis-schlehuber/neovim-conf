-- nvim-treesitter v2 API (requires Neovim 0.11+)
-- setup() only accepts install_dir; highlight/indent are enabled separately

-- Install parsers (no-op if already installed)
require('nvim-treesitter').install({
    'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust',
    'jsdoc', 'bash', 'java', 'kotlin', 'svelte', 'html', 'css',
})

-- Enable treesitter highlighting and indent for all supported filetypes
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
