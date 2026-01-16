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

  -- Colorscheme - Catppuccin
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      require("catppuccin").setup({
        flavour = "frappe", -- latte, frappe, macchiato, mocha
        transparent_background = false,
        term_colors = true,
        integrations = {
          lualine = true,
          nvimtree = true,
          treesitter = true,
        },
      })

      -- Load the colorscheme
      vim.cmd("colorscheme catppuccin-frappe")
    end
  }

  -- TokyoNight colorscheme (optional alternative)
  use {
    'folke/tokyonight.nvim',
  }

  -- Rose Pine colorscheme (optional alternative)
  use {
    'rose-pine/neovim',
    as = 'rose-pine',
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

  -- LSP Configuration
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('config.lsp')
    end
  }

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
      'hrsh7th/cmp-cmdline',
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

  -- File outline (symbols sidebar)
  use {
    'stevearc/aerial.nvim',
    config = function()
      require('config.aerial')
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
