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
          neotree = true,
          treesitter = true,
          nvim_dap = true,
          nvim_dap_ui = true,
          trouble = true,
          noice = true,
          navic = { enabled = true },
          indent_blankline = { enabled = true },
          illuminate = true,
          todo_comments = true,
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

  -- Mason (LSP/formatter/linter installer)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", build = ":MasonUpdate" },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("config.mason")
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
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("config.neo-tree")
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
    dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
    config = function()
      require("config.lualine")
    end,
  },

  -- Breadcrumbs
  {
    "SmiteshP/nvim-navic",
    config = function()
      require("config.navic")
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("config.neoscroll")
    end,
  },

  -- TODO/FIXME/NOTE comment highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.todo-comments")
    end,
  },

  -- LSP progress spinner
  {
    "j-hui/fidget.nvim",
    config = function()
      require("config.fidget")
    end,
  },

  -- Scrollbar with git/diagnostic markers
  {
    "petertriho/nvim-scrollbar",
    dependencies = { "lewis6991/gitsigns.nvim" },
    config = function()
      require("config.scrollbar")
    end,
  },

  -- Better inline diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    priority = 1000,
    config = function()
      require("config.tiny-inline-diagnostic")
    end,
  },

  -- Modern UI (cmdline, messages, notifications)
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("config.noice")
    end,
  },

  -- Word occurrence highlighting
  {
    "RRethy/vim-illuminate",
    config = function()
      require("config.illuminate")
    end,
  },

  -- Better input/select UI
  {
    "stevearc/dressing.nvim",
    config = function()
      require("config.dressing")
    end,
  },

  -- Better code folding with virtual text
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      require("config.ufo")
    end,
  },

  -- Inline color preview
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("config.colorizer")
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


  -- Markdown inline rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    config = function()
      require("config.render-markdown")
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

})
