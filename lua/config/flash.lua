require('flash').setup({
  labels = 'asdfghjklqwertyuiopzxcvbnm',
  search = { multi_window = true },
  jump = { autojump = false },
  label = {
    uppercase = false,
    rainbow = { enabled = true, shade = 5 },
  },
  modes = {
    char = { jump_labels = true }, -- show labels on f/t/F/T motions
  },
})

-- s  → jump to any location on screen
-- S  → jump and select a Treesitter node (great for selecting functions/blocks)
-- r  → (operator pending) remote action — e.g. yr<label> to yank from distance
-- R  → (op pending) treesitter search
-- C-s → toggle flash in / search mode
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end,              { desc = 'Flash: Jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end,        { desc = 'Flash: Treesitter select' })
vim.keymap.set('o',               'r', function() require('flash').remote() end,             { desc = 'Flash: Remote action' })
vim.keymap.set({ 'o', 'x' },      'R', function() require('flash').treesitter_search() end, { desc = 'Flash: Treesitter search' })
vim.keymap.set('c',            '<C-s>', function() require('flash').toggle() end,            { desc = 'Flash: Toggle in search' })
