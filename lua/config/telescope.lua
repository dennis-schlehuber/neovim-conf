-- Telescope configuration

require('telescope').setup({
  defaults = {
    file_ignore_patterns = {},
    path_display = { "smart" },
  },
})

local builtin = require('telescope.builtin')

-- Helper function to get the project directory
local function get_project_dir()
    -- If there's a file open, use its directory
    local current_file = vim.fn.expand('%:p')
    if current_file and current_file ~= '' then
        return vim.fn.expand('%:p:h')
    end
    -- Otherwise, check if a path was passed as argument
    local argv = vim.fn.argv(0)
    if argv and argv ~= '' then
        local path = vim.fn.fnamemodify(argv, ':p:h')
        if vim.fn.isdirectory(path) == 1 then
            return path
        end
    end
    -- Fall back to current working directory
    return vim.fn.getcwd()
end

-- Keymaps
vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({
        cwd = get_project_dir(),
        hidden = false,
        no_ignore = false,
    })
end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>pg', function()
    builtin.git_files({
        cwd = get_project_dir(),
    })
end, { desc = 'Git files' })
vim.keymap.set('n', '<leader>pws', function()
    local word = vim.fn.expand("<cword>")
    builtin.grep_string({ search = word })
end, { desc = 'Search word under cursor' })
vim.keymap.set('n', '<leader>pWs', function()
    local word = vim.fn.expand("<cWORD>")
    builtin.grep_string({ search = word })
end, { desc = 'Search WORD under cursor' })
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = 'Grep search' })
vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = 'Help tags' })