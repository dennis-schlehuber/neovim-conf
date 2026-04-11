require('persistence').setup({
  dir = vim.fn.stdpath('state') .. '/sessions/',
  need = 1,      -- minimum number of buffers to save a session
  branch = true, -- use git branch in session name (separate session per branch)
})

-- Auto-restore session when nvim is opened with no file arguments.
-- Deferred to VimEnter so all plugins are fully loaded before restoring.
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  nested = true, -- allow FileType/BufRead autocmds to fire during restore
  callback = function()
    if vim.fn.argc() == 0 then
      require('persistence').load()
    end
  end,
})

local map = function(key, cmd, desc)
  vim.keymap.set('n', key, cmd, { desc = desc, silent = true })
end

map('<leader>qw', function() require('persistence').save() end,                'Session: Save now')
map('<leader>qs', function() require('persistence').load() end,                'Session: Restore for cwd')
map('<leader>qS', function() require('persistence').select() end,              'Session: Select to restore')
map('<leader>ql', function() require('persistence').load({ last = true }) end, 'Session: Restore last')
map('<leader>qd', function() require('persistence').stop() end,                'Session: Stop saving')
