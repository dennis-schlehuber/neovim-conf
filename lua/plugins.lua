-- Packer bootstrap
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Packer configuration
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Minimap
  use 'Isrothy/neominimap.nvim'

  -- Colorscheme
  use {
    'rose-pine/neovim',
    config = function()
      require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true, -- Handle deprecated options automatically
        },

        styles = {
            bold = true,
            italic = true,
            transparency = false,
        },

        groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        },

        palette = {
            -- Override the builtin palette per variant
            -- moon = {
            --     base = '#18191a',
            --     overlay = '#363738',
            -- },
        },

        -- NOTE: Highlight groups are extended (merged) by default. Disable this
        -- per group via `inherit = false`
        highlight_groups = {
            -- Comment = { fg = "foam" },
            -- StatusLine = { fg = "love", bg = "love", blend = 15 },
            -- VertSplit = { fg = "muted", bg = "muted" },
            -- Visual = { fg = "base", bg = "text", inherit = false },
        },

        before_highlight = function(group, highlight, palette)
            -- Disable all undercurls
            -- if highlight.undercurl then
            --     highlight.undercurl = false
            -- end
            --
            -- Change palette colour
            -- if highlight.fg == palette.pine then
            --     highlight.fg = palette.foam
            -- end
        end,
      })

      vim.cmd("colorscheme rose-pine")
      -- vim.cmd("colorscheme rose-pine-main")
      -- vim.cmd("colorscheme rose-pine-moon")
      -- vim.cmd("colorscheme rose-pine-dawn")
    end
  }

  -- OneDark colorscheme (optional alternative)
  use 'joshdick/onedark.vim'

  -- Telescope (fuzzy finder)
  use {
    'nvim-telescope/telescope.nvim',
    tag = "0.1.5",
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('config.telescope')
    end
  }

  -- LSP
  use 'neovim/nvim-lspconfig'

  -- Undotree
  use 'mbbill/undotree'

  -- Git signs (inline git blame)
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('config.gitsigns')
    end
  }

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require('config.cmp')
    end
  }

  -- File explorer
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('config.nvim-tree')
    end
  }

  -- Auto-pairs
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('config.autopairs')
    end
  }

  -- Indentation guides
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('config.indent-blankline')
    end
  }

  -- Better notifications
  use {
    'rcarriga/nvim-notify',
    config = function()
      require('config.notify')
    end
  }

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('config.lualine')
    end
  }

  -- Code formatter (Prettier support)
  use {
    'stevearc/conform.nvim',
    config = function()
      require('config.conform')
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

