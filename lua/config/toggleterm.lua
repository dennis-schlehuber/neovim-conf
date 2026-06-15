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
    -- Pass Esc through to lazygit instead of exiting terminal mode
    vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<Esc>', '<Esc>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  end,
})

vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end, { desc = 'Toggle lazygit' })

-- Project tree sidebar
local tree_buf = nil
local tree_win = nil

local function apply_tree_highlights(buf)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd([[
      syntax clear
      syntax match TreeHeader    /\%1l.*/
      syntax match TreeSeparator /\%2l.*/
      syntax match TreeStructure /[│├└─]/
      syntax match TreeDir       /[^ ├└│─.]\+\/\s*$/
      syntax match TreeSymlink   /[^ ├└│─.]\+@\s*$/
      syntax match TreeExec      /[^ ├└│─.]\+\*\s*$/
      syntax match TreeSummary   /^\d\+ director.*/
      highlight default TreeHeader    guifg=#8caaee gui=bold
      highlight default TreeSeparator guifg=#414559
      highlight default TreeStructure guifg=#51576d
      highlight default TreeDir       guifg=#8caaee gui=bold
      highlight default TreeSymlink   guifg=#81c8be gui=italic
      highlight default TreeExec      guifg=#a6d189
      highlight default TreeSummary   guifg=#737994 gui=italic
    ]])
  end)
end

local function toggle_tree_sidebar()
  if tree_win and vim.api.nvim_win_is_valid(tree_win) then
    vim.api.nvim_win_close(tree_win, true)
    tree_win = nil
    return
  end

  local root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.getcwd()) .. ' rev-parse --show-toplevel 2>/dev/null')[1]
  if not root or root == '' then root = vim.fn.getcwd() end

  local base_ignore = '".git|node_modules|__pycache__|.venv"'
  local gitignore_flag = vim.fn.filereadable(root .. '/.gitignore') == 1 and ' --gitignore' or ''
  local lines = vim.fn.systemlist('tree -F -I ' .. base_ignore .. gitignore_flag .. ' ' .. vim.fn.shellescape(root))

  -- Header
  local name = vim.fn.fnamemodify(root, ':t')
  table.insert(lines, 1, '  ' .. name)
  table.insert(lines, 2, string.rep('─', math.max(#name + 4, 30)))

  if not tree_buf or not vim.api.nvim_buf_is_valid(tree_buf) then
    tree_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[tree_buf].buftype   = 'nofile'
    vim.bo[tree_buf].bufhidden = 'hide'
    vim.bo[tree_buf].swapfile  = false
    vim.keymap.set('n', 'q', function()
      if tree_win and vim.api.nvim_win_is_valid(tree_win) then
        vim.api.nvim_win_close(tree_win, true)
        tree_win = nil
      end
    end, { buffer = tree_buf, silent = true })
  end

  vim.bo[tree_buf].modifiable = true
  vim.api.nvim_buf_set_lines(tree_buf, 0, -1, false, lines)
  vim.bo[tree_buf].modifiable = false
  apply_tree_highlights(tree_buf)

  -- Dynamic width: fit content up to a cap
  local max_len = 35
  for _, line in ipairs(lines) do
    max_len = math.max(max_len, #line)
  end
  local width = math.min(60, max_len + 2)

  vim.cmd('botright vsplit')
  tree_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(tree_win, tree_buf)
  vim.api.nvim_win_set_width(tree_win, width)
  vim.wo[tree_win].number         = false
  vim.wo[tree_win].relativenumber = false
  vim.wo[tree_win].signcolumn     = 'no'
  vim.wo[tree_win].wrap           = false
  vim.wo[tree_win].list           = true
  vim.wo[tree_win].listchars      = 'extends:›,precedes:‹'
  vim.cmd('wincmd p')
end

vim.keymap.set('n', '<leader>t', toggle_tree_sidebar, { desc = 'Toggle project tree sidebar' })

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
