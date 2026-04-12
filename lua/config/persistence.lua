require('persistence').setup({
  dir = vim.fn.stdpath('state') .. '/sessions/',
  need = 1,      -- minimum number of buffers to save a session
  branch = true, -- use git branch in session name (separate session per branch)
})

-- Auto-restore session when nvim is opened with no file arguments,
-- or with a single directory argument (e.g. `nvim .`).
-- vim.schedule defers until after lazy.nvim finishes loading all plugins
-- (VimEnter has already fired by the time this config function runs).
local function should_restore()
  if vim.fn.argc() == 0 then return true end
  if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then return true end
  return false
end

if should_restore() then
  vim.schedule(function()
    require('persistence').load()
  end)
end

local map = function(key, cmd, desc)
  vim.keymap.set('n', key, cmd, { desc = desc, silent = true })
end

map('<leader>qw', function()
  require('persistence').save()
  vim.notify('Session saved', vim.log.levels.INFO, { title = 'Session' })
end, 'Session: Save now')
map('<leader>qs', function() require('persistence').load() end,                'Session: Restore for cwd')
map('<leader>qS', function() require('persistence').select() end,              'Session: Select to restore')
map('<leader>ql', function() require('persistence').load({ last = true }) end, 'Session: Restore last')
map('<leader>qd', function() require('persistence').stop() end,                'Session: Stop saving')
