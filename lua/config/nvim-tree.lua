-- nvim-tree configuration

require('nvim-tree').setup({
  sort_by = "case_sensitive",
  view = {
    width = 40,
  },
  update_focused_file = {
    enable = true,
    update_root = false, -- set true if you want root to change
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
    indent_markers = {
      enable = true,
    },
  },
  filters = {
    dotfiles = false,
    git_ignored = false,
  },
})

-- Always start with the tree closed, even if session restores it
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.schedule(function()
      require('nvim-tree.api').tree.close()
    end)
  end,
})

-- Keymap to toggle nvim-tree
vim.keymap.set('n', '<leader>e', function()
  require('nvim-tree.api').tree.toggle()
end, { desc = 'Toggle file explorer' })

