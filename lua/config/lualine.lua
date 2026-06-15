-- lualine status bar configuration

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = { 'neo-tree', 'toggleterm', 'aerial', 'trouble', 'dap-repl' },
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        function() return '󰉖 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end,
        color = { fg = '#8caaee', gui = 'bold' },
      },
      'filename',
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {
    lualine_c = {
      {
        function() return require('nvim-navic').get_location() end,
        cond = function()
          local ok, navic = pcall(require, 'nvim-navic')
          return ok and navic.is_available()
        end,
      },
    },
  },
  inactive_winbar = {},
  extensions = {}
})

