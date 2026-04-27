require('neo-tree').setup({
  close_if_last_window = true,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = true,
  default_component_configs = {
    container = { enable_character_fade = true },
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = '│',
      last_indent_marker = '└',
      highlight = 'NeoTreeIndentMarker',
      with_expanders = true,
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
    icon = {
      folder_closed = '',
      folder_open = '',
      folder_empty = '󰜌',
      highlight = 'NeoTreeFileIcon',
    },
    modified = { symbol = '●', highlight = 'NeoTreeModified' },
    name = { trailing_slash = false, use_git_status_colors = true, highlight = 'NeoTreeFileName' },
    git_status = {
      symbols = {
        added     = '',
        modified  = '',
        deleted   = '✖',
        renamed   = '󰁕',
        untracked = '',
        ignored   = '',
        unstaged  = '󰄱',
        staged    = '',
        conflict  = '',
      },
    },
  },
  window = {
    position = 'left',
    width = 40,
    mapping_options = { noremap = true, nowait = true },
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = { enabled = true, leave_dirs_open = false },
    group_empty_dirs = true,
    hijack_netrw_behavior = 'disabled',
    use_libuv_file_watcher = true,
  },
  buffers = {
    follow_current_file = { enabled = true },
    group_empty_dirs = true,
    show_unloaded = true,
  },
  git_status = {
    window = { position = 'float' },
  },
})

vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle file explorer' })
