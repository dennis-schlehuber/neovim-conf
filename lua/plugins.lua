-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Minimap
  "Isrothy/neominimap.nvim",

  -- Colorscheme - Catppuccin (load first so UI is styled before other plugins init)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe", -- latte, frappe, macchiato, mocha
        transparent_background = false,
        term_colors = true,
        integrations = {
          lualine = true,
          nvimtree = true,
          treesitter = true,
          nvim_dap = true,
          nvim_dap_ui = true,
          bufferline = true,
          trouble = true,
        },
      })
      vim.cmd("colorscheme catppuccin-frappe")
    end,
  },

  -- TokyoNight colorscheme (optional alternative)
  "folke/tokyonight.nvim",

  -- Rose Pine colorscheme (optional alternative)
  { "rose-pine/neovim", name = "rose-pine" },

  -- OneDark colorscheme (optional alternative)
  "joshdick/onedark.vim",

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.telescope")
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("config.lsp")
    end,
  },

  -- Undotree
  "mbbill/undotree",

  -- Git signs (inline git blame)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("config.cmp")
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  -- Auto-pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("config.autopairs")
    end,
  },

  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("config.indent-blankline")
    end,
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("config.notify")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.lualine")
    end,
  },

  -- Code formatter (Prettier support)
  {
    "stevearc/conform.nvim",
    config = function()
      require("config.conform")
    end,
  },

  -- File outline (symbols sidebar)
  {
    "stevearc/aerial.nvim",
    config = function()
      require("config.aerial")
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- Git integration
  "tpope/vim-fugitive",

  -- LLM autocompletion
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("config.supermaven")
    end,
  },

  -- Keybinding popup helper
  {
    "folke/which-key.nvim",
    config = function()
      require("config.which-key")
    end,
  },

  -- DAP (Debugger)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("config.dap")
    end,
  },

  -- Linter
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("config.lint")
    end,
  },

  -- Fast navigation
  {
    "folke/flash.nvim",
    config = function()
      require("config.flash")
    end,
  },

  -- Floating terminal + lazygit
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("config.toggleterm")
    end,
  },

  -- Buffer tab bar
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.bufferline")
    end,
  },

  -- Diagnostics panel
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.trouble")
    end,
  },

  -- Session persistence (restore buffers between nvim restarts)
  {
    "folke/persistence.nvim",
    config = function()
      require("config.persistence")
    end,
  },
})
