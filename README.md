# Neovim Configuration

A modern Neovim v0.11+ configuration with LSP support, fuzzy finding, git integration, and more.

## Plugins and licenses

- `tpope/vim-fugitive` — MIT
- `wbthomason/packer.nvim` — MIT
- `Isrothy/neominimap.nvim` — MIT (per upstream)
- `rose-pine/neovim` — MIT
- `joshdick/onedark.vim` — MIT
- `nvim-telescope/telescope.nvim` — MIT
- `nvim-lua/plenary.nvim` — MIT
- `neovim/nvim-lspconfig` — Apache-2.0
- `mbbill/undotree` — MIT
- `lewis6991/gitsigns.nvim` — MIT
- `hrsh7th/nvim-cmp` — MIT
- `hrsh7th/cmp-nvim-lsp` — MIT
- `hrsh7th/cmp-buffer` — MIT
- `hrsh7th/cmp-path` — MIT
- `L3MON4D3/LuaSnip` — Apache-2.0
- `saadparwaiz1/cmp_luasnip` — MIT
- `nvim-tree/nvim-tree.lua` — MIT
- `nvim-tree/nvim-web-devicons` — MIT
- `windwp/nvim-autopairs` — MIT
- `lukas-reineke/indent-blankline.nvim` — MIT
- `rcarriga/nvim-notify` — MIT
- `nvim-lualine/lualine.nvim` — MIT
- `stevearc/conform.nvim` — MIT

## Prerequisites

### Required

- **Neovim v0.11+** - The configuration uses Neovim v0.11 native LSP API
- **Git** - Required for plugin management and git features
- **Node.js and npm** - Required for TypeScript/JavaScript language server
  ```bash
  npm install -g typescript-language-server typescript
  ```

### Optional (for full functionality)

- **Language Servers** - Install the language servers you need:

  - **TypeScript/JavaScript**: `typescript-language-server` (see above)
  - **Python**:
    ```bash
    npm install -g pyright
    ```
  - **HTML + CSS** (bundled together):
    ```bash
    npm install -g vscode-langservers-extracted
    ```
  - **Svelte**:
    ```bash
    npm install -g svelte-language-server
    ```
  - **Go**: `gopls` - `go install golang.org/x/tools/gopls@latest`
  - **Java**: `jdtls` - `brew install jdtls`
  - **Kotlin**: `kotlin-language-server` - Install via your package manager
  - **XML**: `lemminx` - Download binary from [GitHub releases](https://github.com/eclipse/lemminx/releases) and place it in your PATH

- **Tree-sitter CLI** (optional but recommended) - For better syntax highlighting

  ```bash
  # macOS
  brew install tree-sitter

  # Or install via npm
  npm install -g tree-sitter-cli
  ```

## Installation

1. Clone or copy this configuration to your Neovim config directory:

   ```bash
   # On macOS/Linux
   cp -r nvim ~/.config/

   # Or if you're already in the config directory
   # The structure should be: ~/.config/nvim/
   ```

2. Open Neovim:

   ```bash
   nvim
   ```

3. Install plugins:

   ```vim
   :PackerSync
   ```

4. Install language servers as needed (see Prerequisites above)

## Features

### 🎨 Appearance

- **Rose Pine** colorscheme with auto dark/light mode detection (default)
- **OneDark** colorscheme (optional alternative)
  - Switch to OneDark: `:colorscheme onedark`
  - Switch back to Rose Pine: `:colorscheme rose-pine`
- **Lualine** status bar showing:
  - Current mode
  - Git branch and diff status
  - LSP diagnostics
  - File information (encoding, format, type)
  - Cursor position
- **Indent guides** for better code structure visualization
- **File icons** in file explorer and status bar

### 🔍 File Navigation

- **Telescope** fuzzy finder with:
  - `<leader>ff` - Search text in files (live grep)
  - `<leader>pf` - Find files (searches from project directory)
  - `<leader>pg` - Git files
  - `<leader>pws` - Search word under cursor
  - `<leader>pWs` - Search WORD under cursor
  - `<leader>ps` - Interactive grep search
  - `<leader>vh` - Help tags
- **nvim-tree** file explorer:
  - `<leader>e` - Toggle file explorer
- **Netrw** file explorer:
  - `<leader>pv` - Open file explorer

### 💻 Code Intelligence

- **LSP (Language Server Protocol)** support for:
  - TypeScript/JavaScript/React (ts_ls)
  - Go (gopls)
  - Java (jdtls)
  - Kotlin (kotlin_language_server)
- **LSP Keymaps**:
  - `<leader>gd` - Go to definition
  - `<leader>gD` - Go to declaration
  - `K` - Hover documentation
  - `<leader>gi` - Go to implementation
  - `<C-k>` - Signature help
  - `<leader>D` - Type definition
  - `<leader>rn` - Rename symbol
  - `<leader>ca` - Code actions
  - `gr` - Find references
- **nvim-cmp** autocompletion with:
  - LSP completions
  - Buffer completions
  - Path completions
  - Snippet support (LuaSnip)
- **Tree-sitter** for enhanced syntax highlighting and code parsing

### 🔧 Code Editing

- **Auto-pairs** - Automatically pairs brackets, quotes, etc.
- **Undotree** - Visual undo history:
  - `<leader>u` - Toggle undotree

### 📝 Git Integration

- **Fugitive** - Full git integration:
  - `:Git` - Open interactive git status buffer
  - `:Git add %` - Stage current file
  - `:Git commit` - Commit (opens commit message editor)
  - `:Git push` - Push to remote
  - `:Git pull` - Pull from remote
  - `:Git checkout -b my-branch` - Create and switch to new branch
  - `:Git checkout branch-name` - Switch branch
  - `:Git log` - View commit log
  - `:Git diff` - View unstaged changes
  - `:Git blame` - Toggle inline blame for current file
  - Inside `:Git` status buffer:
    - `s` - Stage file/hunk under cursor
    - `u` - Unstage file/hunk
    - `cc` - Commit staged changes
    - `=` - Toggle inline diff for file
    - `Enter` - Open file

- **Gitsigns** - Inline git blame and signs:
  - Shows git blame information at the end of lines
  - Visual indicators in the gutter for changes
- **Git status** in status bar (branch name, diff status)

### 🗺️ Other Features

- **Minimap** - Code minimap for navigation (neominimap.nvim)
- **Better notifications** - Enhanced notification system (nvim-notify)

## Keymaps

### Leader Key

- Leader key is set to `<Space>` (spacebar)

### File Operations

- `<leader>pv` - Open file explorer (netrw)
- `<leader>e` - Toggle nvim-tree file explorer
- `<leader>pf` - Find files (Telescope)
- `<leader>pg` - Git files (Telescope)
- `<leader>ff` - Search text in files (Telescope live grep)

### Search

- `<leader>pws` - Search word under cursor
- `<leader>pWs` - Search WORD under cursor
- `<leader>ps` - Interactive grep search
- `<leader>vh` - Help tags
- `<leader>bb` - Switch buffers

### Git

- Git information is shown in the status bar (branch, diff status)
- Inline git blame appears at the end of lines

### LSP

- `gd` - Go to definition
- `gD` - Go to declaration
- `K` - Hover
- `gi` - Go to implementation
- `<C-k>` - Signature help
- `<leader>D` - Type definition
- `<leader>rn` - Rename
- `<leader>ca` - Code actions
- `gr` - References

### Other

- `<leader>u` - Toggle undotree
- `<leader>p` (in visual mode) - Paste without overwriting register

## Configuration Structure

```
nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── plugins.lua          # Plugin definitions (Packer)
│   └── config/
│       ├── keymaps.lua      # Key mappings
│       ├── set.lua          # Neovim settings
│       ├── lsp.lua          # LSP configuration
│       ├── telescope.lua   # Telescope (fuzzy finder) config
│       ├── treesitter.lua   # Tree-sitter config
│       ├── cmp.lua          # Autocompletion config
│       ├── nvim-tree.lua    # File explorer config
│       ├── autopairs.lua    # Auto-pairs config
│       ├── indent-blankline.lua  # Indent guides config
│       ├── gitsigns.lua     # Git signs config
│       ├── lualine.lua      # Status bar config
│       └── notify.lua       # Notifications config
└── README.md                # This file
```

## Troubleshooting

### LSP not working

- Ensure the language server is installed and in your PATH
- Check LSP status with `:LspInfo` in a file
- Verify your project has the necessary config files (e.g., `tsconfig.json` for TypeScript)

### Icons not showing

- Ensure `nvim-web-devicons` is installed (run `:PackerSync`)
- Use a Nerd Font in your terminal for best icon support

### Plugins not loading

- Run `:PackerSync` to install/update plugins
- Restart Neovim after installing new plugins
- Check for errors with `:checkhealth`

## License

This configuration is provided as-is for personal use.
