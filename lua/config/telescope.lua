-- Telescope configuration

require('telescope').setup({
  defaults = {
    file_ignore_patterns = {},
    path_display = { "smart" },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
  },
})

local builtin = require('telescope.builtin')

-- Helper function to get the project directory (git root, or cwd as fallback)
local function get_project_dir()
  local git_root = vim.fn.system('git -C ' .. vim.fn.shellescape(vim.fn.getcwd()) .. ' rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
  if git_root ~= '' and not git_root:find('fatal:') then
    return git_root
  end
  return vim.fn.getcwd()
end

-- Keymaps
vim.keymap.set('n', '<leader>ff', function()
    builtin.live_grep({
        cwd = get_project_dir(),
    })
end, { desc = 'Find text in files' })
vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({
        cwd = get_project_dir(),
        hidden = true,
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
vim.keymap.set('n', '<leader>sw', function()
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
vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = 'Switch buffers' })