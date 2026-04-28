# Neovim Configuration

A modern Neovim v0.11+ configuration with LSP, fuzzy finding, git integration, and a Zed-inspired UI.

## Plugins and licenses

**Package manager**
- `folke/lazy.nvim` — Apache-2.0

**Appearance**
- `catppuccin/nvim` — MIT
- `folke/tokyonight.nvim` — MIT *(alternative)*
- `rose-pine/neovim` — MIT *(alternative)*
- `joshdick/onedark.vim` — MIT *(alternative)*
- `nvim-lualine/lualine.nvim` — MIT
- `lukas-reineke/indent-blankline.nvim` — MIT
- `rcarriga/nvim-notify` — MIT
- `folke/noice.nvim` — Apache-2.0
- `MunifTanjim/nui.nvim` — MIT
- `SmiteshP/nvim-navic` — Apache-2.0
- `petertriho/nvim-scrollbar` — MIT
- `rachartier/tiny-inline-diagnostic.nvim` — MIT
- `NvChad/nvim-colorizer.lua` — MIT
- `RRethy/vim-illuminate` — MIT
- `folke/todo-comments.nvim` — Apache-2.0
- `karb94/neoscroll.nvim` — MIT

**File management**
- `nvim-neo-tree/neo-tree.nvim` — MIT
- `nvim-tree/nvim-web-devicons` — MIT
- `nvim-lua/plenary.nvim` — MIT

**Navigation**
- `nvim-telescope/telescope.nvim` — MIT
- `folke/flash.nvim` — Apache-2.0

**LSP & completion**
- `neovim/nvim-lspconfig` — Apache-2.0
- `hrsh7th/nvim-cmp` — MIT
- `hrsh7th/cmp-nvim-lsp` — MIT
- `hrsh7th/cmp-buffer` — MIT
- `hrsh7th/cmp-path` — MIT
- `hrsh7th/cmp-cmdline` — MIT
- `L3MON4D3/LuaSnip` — Apache-2.0
- `saadparwaiz1/cmp_luasnip` — MIT
- `j-hui/fidget.nvim` — MIT
- `stevearc/dressing.nvim` — MIT

**Code intelligence**
- `nvim-treesitter/nvim-treesitter` — Apache-2.0
- `kevinhwang91/nvim-ufo` — MIT
- `stevearc/aerial.nvim` — MIT
- `folke/trouble.nvim` — Apache-2.0
- `stevearc/conform.nvim` — MIT
- `mfussenegger/nvim-lint` — MIT
- `windwp/nvim-autopairs` — MIT
- `supermaven-inc/supermaven-nvim` — MIT *(AI completion)*

**Git**
- `tpope/vim-fugitive` — Vim *(same as Vim license)*
- `lewis6991/gitsigns.nvim` — MIT

**Debugging**
- `mfussenegger/nvim-dap` — MIT
- `rcarriga/nvim-dap-ui` — MIT
- `nvim-neotest/nvim-nio` — MIT
- `theHamsta/nvim-dap-virtual-text` — MIT

**Other**
- `folke/which-key.nvim` — Apache-2.0
- `akinsho/toggleterm.nvim` — GPL-3.0
- `mbbill/undotree` — GPL-2.0
- `Isrothy/neominimap.nvim` — MIT

## Prerequisites

### Required

- **Neovim v0.11+** — uses the native LSP API
- **Git** — required for plugin management
- **A Nerd Font** — required for icons in the file tree and statusline (e.g. `font-jetbrains-mono-nerd-font` via Homebrew)
- **Node.js / npm** — required for most language servers

### Language servers

Install the servers for the languages you use:

| Language | Install |
|----------|---------|
| TypeScript / JavaScript | `npm i -g typescript-language-server typescript` |
| Python | `npm i -g pyright` |
| HTML + CSS | `npm i -g vscode-langservers-extracted` |
| Svelte | `npm i -g svelte-language-server` |
| Go | `go install golang.org/x/tools/gopls@latest` |
| Java | `brew install jdtls` |
| Kotlin | `brew install kotlin-language-server` |
| XML | Download `lemminx` binary and place in `$PATH` |
| Spring Boot | `brew install spring-boot` *(optional)* |

## Installation

```bash
# Clone to Neovim config directory
git clone <repo> ~/.config/nvim

# Open Neovim — lazy.nvim bootstraps itself and installs all plugins
nvim

# Inside Neovim, if anything is missing:
:Lazy sync
```

## Features

### Appearance

- **Catppuccin Frappe** colorscheme
- **Lualine** global statusbar with git, diagnostics, filetype
- **Winbar breadcrumbs** showing current symbol path (`Class > method`)
- **Neo-tree** file explorer with git status icons
- **Indent guides** (thin `▏` character, scope-aware)
- **Smooth scrolling** with quadratic easing
- **Scrollbar** with git hunk and diagnostic markers
- **Inline color preview** for CSS/hex/HSL/Tailwind values
- **Noice** floating command palette and LSP doc borders
- **Tiny inline diagnostics** shown as styled blocks below error lines
- **TODO highlights** — `TODO`, `FIXME`, `HACK`, `NOTE`, `PERF` get colored badges
- **Word occurrence highlighting** — all instances of symbol under cursor highlighted
- **Minimap** in the top-right corner

### Navigation

- **Telescope** fuzzy finder for files, text, buffers, LSP symbols
- **Flash** for jump-to-anywhere motion
- **Aerial** symbols outline panel

### Code Intelligence

- **LSP** for TypeScript, JavaScript, Python, Go, Java, Kotlin, Svelte, HTML, CSS, XML, Spring Boot
- **nvim-cmp** autocompletion with LSP, buffer, path, and snippet sources
- **nvim-ufo** code folding with virtual text showing line count
- **Treesitter** syntax highlighting and text objects
- **Conform** formatter (Prettier and others)
- **Trouble** diagnostics panel
- **DAP** debugger with UI

### Git

- **Fugitive** for full git operations
- **Gitsigns** for inline blame and gutter indicators
- **Lazygit** floating terminal integration

## Keymaps

Leader key: `<Space>`

### Buffers

| Key | Action |
|-----|--------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Close buffer |
| `<leader>bb` | Switch buffers (Telescope) |

### Windows

| Key | Action |
|-----|--------|
| `<leader><Left>` | Move to left window |
| `<leader><Right>` | Move to right window |
| `<leader><Up>` | Move to upper window |
| `<leader><Down>` | Move to lower window |

### File Explorer & Navigation

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle Neo-tree file explorer |
| `<leader>pv` | Open netrw (built-in) |
| `<leader>o` | Toggle Aerial symbols outline |

### Search (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Live grep (text in files) |
| `<leader>pf` | Find files (from git root) |
| `<leader>pg` | Git files |
| `<leader>pws` / `<leader>sw` | Search word under cursor |
| `<leader>pWs` | Search WORD under cursor |
| `<leader>ps` | Interactive grep |
| `<leader>vh` | Help tags |
| `<leader>ft` | Search TODOs |

### LSP

| Key | Action |
|-----|--------|
| `<leader>gd` | Go to definition |
| `<leader>gD` | Go to declaration |
| `<leader>gi` | Go to implementation |
| `<leader>D` | Go to type definition |
| `<leader>cc` | Go to definition (tag-jump style) |
| `grr` | Find references |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>,` | Code action (normal & visual) |

**Telescope LSP pickers:**

| Key | Action |
|-----|--------|
| `<leader>lr` / `<leader>ll` | References |
| `<leader>ld` | Definitions |
| `<leader>li` | Implementations |
| `<leader>lt` | Type definitions |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |

### Diagnostics & Trouble

| Key | Action |
|-----|--------|
| `<leader>.` | Show diagnostic float at cursor |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>dq` | Open diagnostics list |

### Code Folding

| Key | Action |
|-----|--------|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zr` | Open folds except kinds |
| `zm` | Close folds with level |

### Formatting & Linting

| Key | Action |
|-----|--------|
| `<leader>f` | Format (normal & visual, via conform) |
| `<leader>cl` | Run linter manually |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Toggle Lazygit |

Fugitive via `:Git <subcommand>` (`:Git commit`, `:Git push`, etc.)

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>dc` | Continue / start |
| `<leader>di` | Step into |
| `<leader>dn` | Step over |
| `<leader>dO` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dt` | Terminate session |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle DAP UI |

### Terminal

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle floating terminal |
| `<Esc>` *(terminal)* | Exit terminal mode |
| `<C-h/j/k/l>` *(terminal)* | Navigate to adjacent window |

### Flash (Motion)

| Key | Mode | Action |
|-----|------|--------|
| `s` | n/x/o | Jump to any location |
| `S` | n/x/o | Treesitter node select |
| `r` | o | Remote action |
| `R` | o/x | Treesitter search |
| `<C-s>` | c | Toggle flash in `/` search |

### Editing

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undotree |
| `<leader>p` *(visual)* | Paste without overwriting register |

### Completion (insert mode)

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / previous item or snippet jump |
| `<CR>` | Confirm completion |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort completion |
| `<C-b>` / `<C-f>` | Scroll docs up / down |

## Configuration Structure

```
nvim/
├── init.lua                          # Entry point
├── lua/
│   ├── plugins.lua                   # Plugin definitions (lazy.nvim)
│   └── config/
│       ├── keymaps.lua               # Key mappings
│       ├── set.lua                   # Neovim options
│       ├── lsp.lua                   # LSP servers and keymaps
│       ├── telescope.lua             # Fuzzy finder
│       ├── treesitter.lua            # Syntax highlighting
│       ├── cmp.lua                   # Autocompletion
│       ├── neo-tree.lua              # File explorer
│       ├── lualine.lua               # Statusbar
│       ├── navic.lua                 # Breadcrumbs
│       ├── noice.lua                 # Modern cmdline/messages UI
│       ├── notify.lua                # Notifications
│       ├── indent-blankline.lua      # Indent guides
│       ├── ufo.lua                   # Code folding
│       ├── neoscroll.lua             # Smooth scrolling
│       ├── scrollbar.lua             # Scrollbar with markers
│       ├── illuminate.lua            # Word occurrence highlighting
│       ├── colorizer.lua             # Inline color preview
│       ├── todo-comments.lua         # TODO/FIXME highlights
│       ├── fidget.lua                # LSP progress spinner
│       ├── tiny-inline-diagnostic.lua # Inline diagnostics
│       ├── dressing.lua              # Better input/select UI
│       ├── aerial.lua                # Symbols outline
│       ├── gitsigns.lua              # Git gutter signs
│       ├── autopairs.lua             # Auto-pairs
│       ├── conform.lua               # Formatter
│       ├── lint.lua                  # Linter
│       ├── dap.lua                   # Debugger
│       ├── toggleterm.lua            # Floating terminal
│       ├── trouble.lua               # Diagnostics panel
│       ├── flash.lua                 # Motion navigation
│       ├── supermaven.lua            # AI completion
│       └── which-key.lua             # Keymap hints
└── README.md
```

## Troubleshooting

### Icons not showing
Install a Nerd Font and set it in your terminal: `brew install --cask font-jetbrains-mono-nerd-font`

### LSP not working
- Check server is installed and in `$PATH`
- Run `:LspInfo` inside a file to see attached servers
- Verify project has the expected config file (e.g. `tsconfig.json`)

### Plugin errors
- Run `:Lazy sync` to install/update all plugins
- Run `:checkhealth` for a full environment report
