#!/bin/bash
# Wipes all Neovim-generated data so the next launch reinstalls everything from scratch.
# Keeps: ~/.config/nvim (your config), lazy-lock.json (plugin version pins)

set -euo pipefail

NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
NVIM_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
JDTLS_WORKSPACES="$HOME/.local/share/jdtls/workspaces"
VIM_UNDO="$HOME/.vim/undodir"

confirm() {
  printf "%s [y/N] " "$1"
  read -r answer
  case "$answer" in [yY]*) return 0;; *) return 1;; esac
}

remove() {
  local path="$1" label="$2"
  if [ -e "$path" ]; then
    rm -rf "$path"
    echo "  removed  $label"
    echo "           $path"
  else
    echo "  skipped  $label (not found)"
  fi
}

echo ""
echo "This will remove:"
echo "  - Lazy plugin installations   ($NVIM_DATA/lazy)"
echo "  - Mason LSP/tool installations ($NVIM_DATA/mason)"
echo "  - Treesitter parsers          ($NVIM_DATA/site)"
echo "  - State files / shada         ($NVIM_STATE)"
echo "  - Cache                       ($NVIM_CACHE)"
echo "  - jdtls workspace data        ($JDTLS_WORKSPACES)"
echo "  - Undo history                ($VIM_UNDO)"
echo ""
echo "Your config at ~/.config/nvim is untouched."
echo ""

confirm "Proceed?" || { echo "Aborted."; exit 0; }
echo ""

remove "$NVIM_DATA/lazy"         "Lazy plugins"
remove "$NVIM_DATA/mason"        "Mason installations"
remove "$NVIM_DATA/site"         "Treesitter parsers"
remove "$NVIM_STATE"             "State / shada"
remove "$NVIM_CACHE"             "Cache"
remove "$JDTLS_WORKSPACES"       "jdtls workspaces"
remove "$VIM_UNDO"               "Undo history"

echo ""
echo "Done. Open nvim and Lazy will reinstall all plugins and Mason will reinstall all servers."
