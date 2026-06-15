# Neovim Configuration

A modern Neovim v0.11+ configuration with LSP, fuzzy finding, git integration, and a Zed-inspired UI.

## Quick Start

### Requirements

- **Neovim v0.11+** — uses the native LSP API
- **Git** — required for plugin management
- **A Nerd Font** — required for icons (e.g. `brew install --cask font-jetbrains-mono-nerd-font`)
- **Node.js / npm** — required for Mason to bootstrap JS/TS-based language servers
- **JDK** — required for Mason-managed Java/Kotlin tools (`jdtls`, `kotlin-language-server`, `ktlint`)
- **lazygit** — for the `<leader>gg` floating git UI
- **tree** — for the `<leader>T` project tree view (`brew install tree`, or auto-installed via `:Lazy build system-deps`)

### Installation

```bash
git clone <repo> ~/.config/nvim
nvim
```

On first launch, `lazy.nvim` bootstraps itself and installs all plugins. **Mason then auto-installs all LSP servers, formatters, and linters** — no manual language server setup needed. Run `:Lazy sync` or `:Mason` if anything is missing.

**Run the bootstrap script** to install prerequisites that Mason cannot manage (Node.js must already be in `$PATH`):

| Platform | Script |
|----------|--------|
| macOS | `chmod +x install-macos.sh && ./install-macos.sh` |
| Arch Linux | `chmod +x install.sh && ./install.sh` |
| Ubuntu | `chmod +x install-ubuntu.sh && ./install-ubuntu.sh` |

The scripts install: `eslint`, `pylint`, `lazygit`, `spring-boot-language-server`, `lombok.jar`, and a JDK.

### What Mason auto-installs

| Category | Tools |
|----------|-------|
| LSP servers | `ts_ls`, `pyright`, `svelte`, `html`, `cssls`, `gopls`, `jdtls`, `kotlin_language_server`, `lemminx` |
| Formatters | `prettier`, `stylua` |
| Linters | `ktlint` |

---

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
- **Word occurrence highlighting** — all instances of the symbol under cursor
- **Minimap** in the top-right corner

### Navigation

- **Telescope** fuzzy finder for files, text, buffers, LSP symbols
- **Flash** for jump-to-anywhere motion
- **Aerial** symbols outline panel

### Code Intelligence

- **LSP** for TypeScript, JavaScript, Python, Go, Java, Kotlin, Svelte, HTML, CSS, XML, Spring Boot
- **nvim-cmp** autocompletion with LSP, buffer, path, and snippet sources
- **nvim-ufo** code folding with virtual text showing fold line count
- **Treesitter** syntax highlighting and text objects
- **Conform** formatter (Prettier and others), format-on-save
- **Trouble** diagnostics panel
- **DAP** debugger with UI

### Git

- **Fugitive** for full git operations (`:Git <subcommand>`)
- **Gitsigns** for inline blame and gutter indicators
- **Lazygit** floating terminal integration (`<leader>gg`)

---

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
| `<leader>pv` | Open netrw (built-in explorer) |
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
| `<leader>cl` | Run code lens |

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
| `<leader>dq` | Workspace diagnostics (Trouble) |
| `<leader>t` | Toggle Trouble panel |
| `<leader>df` | File diagnostics (Trouble) |
| `<leader>ds` | Document symbols (Trouble) |
| `<leader>dl` | Location list (Trouble) |
| `<leader>dx` | Quickfix list (Trouble) |
| `[q` / `]q` | Previous / next Trouble item |

### Code Folding

| Key | Action |
|-----|--------|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zr` | Open folds except kinds |
| `zm` | Close folds with level |

### Formatting

| Key | Action |
|-----|--------|
| `<leader>f` | Format buffer or selection (Conform) |

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
| `<leader>dl` | Log point |
| `<leader>dt` | Terminate session |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle DAP UI |

### Terminal

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle floating terminal |
| `<leader>gg` | Toggle Lazygit |
| `<leader>T` | Toggle project tree view (`tree`) |
| `<leader>rr` | Run current file with `uv` |
| `<Esc>` *(terminal mode)* | Exit terminal mode |
| `<C-h/j/k/l>` *(terminal mode)* | Navigate to adjacent window |

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
| `<leader>md` | Toggle markdown render |
| `<leader>p` *(visual)* | Paste without overwriting register |

### Completion (insert mode)

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / previous item or snippet jump |
| `<CR>` | Confirm completion |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort completion |
| `<C-b>` / `<C-f>` | Scroll docs up / down |

---

## Plugin List

**Package manager**
- `folke/lazy.nvim` — Apache-2.0

**LSP & Mason**
- `neovim/nvim-lspconfig` — Apache-2.0
- `williamboman/mason.nvim` — Apache-2.0
- `williamboman/mason-lspconfig.nvim` — Apache-2.0
- `WhoIsSethDaniel/mason-tool-installer.nvim` — MIT

**Completion**
- `hrsh7th/nvim-cmp` — MIT
- `hrsh7th/cmp-nvim-lsp` — MIT
- `hrsh7th/cmp-buffer` — MIT
- `hrsh7th/cmp-path` — MIT
- `hrsh7th/cmp-cmdline` — MIT
- `L3MON4D3/LuaSnip` — Apache-2.0
- `saadparwaiz1/cmp_luasnip` — MIT
- `supermaven-inc/supermaven-nvim` — MIT *(AI completion)*

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
- `Isrothy/neominimap.nvim` — MIT

**File management**
- `nvim-neo-tree/neo-tree.nvim` — MIT
- `nvim-tree/nvim-web-devicons` — MIT
- `nvim-lua/plenary.nvim` — MIT

**Navigation**
- `nvim-telescope/telescope.nvim` — MIT
- `folke/flash.nvim` — Apache-2.0

**Code intelligence**
- `nvim-treesitter/nvim-treesitter` — Apache-2.0
- `kevinhwang91/nvim-ufo` — MIT
- `stevearc/aerial.nvim` — MIT
- `folke/trouble.nvim` — Apache-2.0
- `stevearc/conform.nvim` — MIT
- `mfussenegger/nvim-lint` — MIT
- `windwp/nvim-autopairs` — MIT

**Git**
- `tpope/vim-fugitive` — Vim
- `lewis6991/gitsigns.nvim` — MIT

**Debugging**
- `mfussenegger/nvim-dap` — MIT
- `rcarriga/nvim-dap-ui` — MIT
- `nvim-neotest/nvim-nio` — MIT
- `theHamsta/nvim-dap-virtual-text` — MIT

**UI utilities**
- `j-hui/fidget.nvim` — MIT
- `stevearc/dressing.nvim` — MIT
- `folke/which-key.nvim` — Apache-2.0
- `akinsho/toggleterm.nvim` — GPL-3.0
- `mbbill/undotree` — GPL-2.0

---

## Configuration Structure

```
nvim/
├── init.lua                          # Entry point
├── install-macos.sh                  # Bootstrap script (macOS)
├── install.sh                        # Bootstrap script (Arch Linux)
├── install-ubuntu.sh                 # Bootstrap script (Ubuntu)
└── lua/
    ├── plugins.lua                   # Plugin definitions (lazy.nvim)
    └── config/
        ├── mason.lua                 # Mason: auto-install LSP servers + tools
        ├── keymaps.lua               # Key mappings
        ├── set.lua                   # Neovim options
        ├── lsp.lua                   # LSP attach callbacks and keymaps
        ├── telescope.lua             # Fuzzy finder
        ├── treesitter.lua            # Syntax highlighting
        ├── cmp.lua                   # Autocompletion
        ├── neo-tree.lua              # File explorer
        ├── lualine.lua               # Statusbar
        ├── navic.lua                 # Breadcrumbs
        ├── noice.lua                 # Modern cmdline/messages UI
        ├── notify.lua                # Notifications
        ├── indent-blankline.lua      # Indent guides
        ├── ufo.lua                   # Code folding
        ├── neoscroll.lua             # Smooth scrolling
        ├── scrollbar.lua             # Scrollbar with markers
        ├── illuminate.lua            # Word occurrence highlighting
        ├── colorizer.lua             # Inline color preview
        ├── todo-comments.lua         # TODO/FIXME highlights
        ├── fidget.lua                # LSP progress spinner
        ├── tiny-inline-diagnostic.lua # Inline diagnostics
        ├── dressing.lua              # Better input/select UI
        ├── aerial.lua                # Symbols outline
        ├── gitsigns.lua              # Git gutter signs
        ├── autopairs.lua             # Auto-pairs
        ├── conform.lua               # Formatter (format-on-save)
        ├── lint.lua                  # Linter (eslint, pylint, ktlint)
        ├── dap.lua                   # Debugger
        ├── toggleterm.lua            # Floating terminal + Lazygit
        ├── trouble.lua               # Diagnostics panel
        ├── flash.lua                 # Motion navigation
        ├── supermaven.lua            # AI completion
        └── which-key.lua             # Keymap hints
```

---

## Troubleshooting

### Icons not showing
Install a Nerd Font and set it in your terminal:
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### LSP not working
- Run `:Mason` to check if the server is installed (Mason auto-installs on first launch)
- Run `:LspInfo` inside a file to see attached servers
- Verify the project has the expected config file (e.g. `tsconfig.json`)

### Java/Kotlin LSP not working
Ensure a JDK is installed and `java` is in `$PATH`. Mason-managed tools (`jdtls`, `kotlin_language_server`, `ktlint`) require a JVM at runtime.

### Plugin errors
- Run `:Lazy sync` to install/update all plugins
- Run `:checkhealth` for a full environment report
