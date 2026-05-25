require('toggleterm').setup({
  size = function(term)
    if term.direction == 'horizontal' then return 15
    elseif term.direction == 'vertical' then return math.floor(vim.o.columns * 0.4)
    end
  end,
  open_mapping = [[<C-\>]],
  hide_numbers  = true,
  start_insert  = true,
  insert_mappings = true,
  persist_size  = true,
  direction     = 'float',
  close_on_exit = true,
  shell         = vim.o.shell,
  float_opts = {
    border   = 'curved',
    winblend = 8,
  },
})

-- Exit terminal mode with Esc, navigate windows normally
vim.keymap.set('t', '<Esc>',   [[<C-\><C-n>]],          { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>',   [[<C-\><C-n><C-w>h]],    { desc = 'Terminal → left window' })
vim.keymap.set('t', '<C-l>',   [[<C-\><C-n><C-w>l]],    { desc = 'Terminal → right window' })
vim.keymap.set('t', '<C-k>',   [[<C-\><C-n><C-w>k]],    { desc = 'Terminal → upper window' })
vim.keymap.set('t', '<C-j>',   [[<C-\><C-n><C-w>j]],    { desc = 'Terminal → lower window' })

-- Lazygit floating window
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({
  cmd = 'lazygit',
  dir = 'git_dir',
  direction = 'float',
  float_opts = { border = 'curved' },
  on_open = function(term)
    vim.cmd('startinsert!')
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  end,
})

vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end, { desc = 'Toggle lazygit' })

-- uv run: run current Python file in a float terminal
vim.keymap.set('n', '<leader>rr', function()
  local file = vim.fn.expand('%:p')
  local pyproject = vim.fn.findfile('pyproject.toml', vim.fn.expand('%:p:h') .. ';')
  local dir = pyproject ~= '' and vim.fn.fnamemodify(pyproject, ':h') or vim.fn.expand('%:p:h')
  Terminal:new({
    cmd = 'uv run python ' .. vim.fn.shellescape(file),
    dir = dir,
    direction = 'float',
    float_opts = { border = 'curved' },
    close_on_exit = false,
    on_open = function() vim.cmd('startinsert!') end,
  }):toggle()
end, { desc = 'uv run current file' })
