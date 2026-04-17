#!/usr/bin/env bash
# install.sh — installs LSP servers, formatters, linters, and ensures
# the correct Neovim data directories exist for treesitter parsers.
#
# Usage:
#   chmod +x install.sh && ./install.sh

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'
info()  { echo -e "${BLUE}[info]${RESET}  $*"; }
ok()    { echo -e "${GREEN}[ok]${RESET}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${RESET}  $*"; }
err()   { echo -e "${RED}[err]${RESET}   $*"; }
title() { echo -e "\n${BOLD}━━━ $* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"; }

# ── Helpers ───────────────────────────────────────────────────────────────────
has() { command -v "$1" &>/dev/null; }

# Install pacman packages only if not already on PATH
PACMAN_PKGS=()
AUR_PKGS=()

queue_pacman() { PACMAN_PKGS+=("$@"); }
queue_aur()    { AUR_PKGS+=("$@"); }

# ── Treesitter directories ────────────────────────────────────────────────────
title "Treesitter"

NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"

# Parser cache written by nvim-treesitter
mkdir -p "$NVIM_DATA/parser"
ok "Parser cache:  $NVIM_DATA/parser"

# Lazy plugin directory (created on first nvim launch, but ensure it's there)
mkdir -p "$NVIM_DATA/lazy"
ok "Lazy data dir: $NVIM_DATA/lazy"

# ── npm — LSP servers, formatters, linters ───────────────────────────────────
title "npm packages"

if ! has npm; then
  err "npm not found. Install Node.js (https://nodejs.org) then re-run."
  echo "  Skipping: typescript-language-server, svelte-language-server,"
  echo "            vscode-langservers-extracted, pyright, prettier, eslint"
else
  npm_global() {
    info "npm install -g $*"
    npm install -g "$@"
  }
  npm_global typescript typescript-language-server   # ts_ls  (TS/JS/React)
  npm_global svelte-language-server                  # svelte
  npm_global vscode-langservers-extracted            # html + cssls
  npm_global pyright                                 # python
  npm_global prettier                                # formatter (conform.nvim)
  npm_global eslint                                  # linter   (nvim-lint)
  npm_global tree-sitter-cli                         # treesitter parser builder
fi

# ── Go — gopls ────────────────────────────────────────────────────────────────
title "Go packages"

if ! has go; then
  err "go not found. Install Go (https://go.dev/doc/install) then re-run."
  echo "  Skipping: gopls"
else
  info "go install gopls@latest"
  go install golang.org/x/tools/gopls@latest
  ok "gopls"
fi

# ── System packages (pacman / AUR) ───────────────────────────────────────────
title "System packages"

# jdtls — Java LSP (pacman: extra/jdtls)
if has jdtls; then ok "jdtls already in PATH"; else queue_pacman jdtls; fi

# stylua — Lua formatter used by conform.nvim (pacman: extra/stylua)
if has stylua; then ok "stylua already in PATH"; else queue_pacman stylua; fi

# python-pylint — Python linter used by nvim-lint (pacman: extra/python-pylint)
if has pylint; then ok "pylint already in PATH"; else queue_pacman python-pylint; fi

# lazygit — used by the <leader>gg toggleterm integration (pacman: extra/lazygit)
if has lazygit; then ok "lazygit already in PATH"; else queue_pacman lazygit; fi

# kotlin-language-server — Kotlin LSP (AUR)
if has kotlin-language-server; then
  ok "kotlin-language-server already in PATH"
else
  queue_aur kotlin-language-server
fi

# lemminx — XML LSP (AUR)
if has lemminx; then ok "lemminx already in PATH"; else queue_aur lemminx; fi

# ktlint — Kotlin linter used by nvim-lint (AUR)
if has ktlint; then ok "ktlint already in PATH"; else queue_aur ktlint; fi

# Install queued pacman packages
if [ ${#PACMAN_PKGS[@]} -gt 0 ]; then
  if has pacman; then
    info "pacman -S --needed ${PACMAN_PKGS[*]}"
    sudo pacman -S --needed "${PACMAN_PKGS[@]}"
  else
    warn "pacman not available. Install manually: ${PACMAN_PKGS[*]}"
  fi
fi

# Install queued AUR packages
if [ ${#AUR_PKGS[@]} -gt 0 ]; then
  if has yay; then
    info "yay -S --needed ${AUR_PKGS[*]}"
    yay -S --needed "${AUR_PKGS[@]}"
  elif has paru; then
    info "paru -S --needed ${AUR_PKGS[*]}"
    paru -S --needed "${AUR_PKGS[@]}"
  else
    warn "No AUR helper found (yay/paru). Install manually from AUR: ${AUR_PKGS[*]}"
  fi
fi

# ── Java / Kotlin — Spring Boot + Lombok ─────────────────────────────────────
title "Java/Kotlin — Spring Boot + Lombok"

JDTLS_DATA="$HOME/.local/share/jdtls"
mkdir -p "$JDTLS_DATA"

# lombok.jar — enables Lombok annotation processing in jdtls
LOMBOK_JAR="$JDTLS_DATA/lombok.jar"
if [[ -f "$LOMBOK_JAR" ]]; then
  ok "lombok.jar already present: $LOMBOK_JAR"
else
  if has curl; then
    info "Downloading lombok.jar…"
    curl -fsSL "https://projectlombok.org/downloads/lombok.jar" -o "$LOMBOK_JAR"
    ok "lombok.jar → $LOMBOK_JAR"
  else
    warn "curl not found — skipping lombok.jar download."
    warn "Download manually: https://projectlombok.org/downloads/lombok.jar → $LOMBOK_JAR"
  fi
fi

# spring-boot-language-server — Spring Boot LSP (from STS4 GitHub releases)
SPRING_BOOT_DIR="$HOME/.local/share/spring-boot-language-server"
SPRING_BOOT_BIN="/usr/local/bin/spring-boot-language-server"
if has spring-boot-language-server; then
  ok "spring-boot-language-server already in PATH"
elif [[ -d "$SPRING_BOOT_DIR" ]]; then
  ok "spring-boot-language-server already installed at $SPRING_BOOT_DIR"
else
  if has curl; then
    info "Downloading spring-boot-language-server (latest STS4 release)…"
    STS4_VERSION=$(curl -fsSL "https://api.github.com/repos/spring-projects/sts4/releases/latest" \
      | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')
    STS4_VERSION_NUM="${STS4_VERSION#v}"
    STS4_URL="https://github.com/spring-projects/sts4/releases/download/${STS4_VERSION}/spring-boot-language-server-${STS4_VERSION_NUM}.tar.gz"
    TMP_STS=$(mktemp -d)
    curl -fsSL "$STS4_URL" -o "$TMP_STS/spring-boot-ls.tar.gz"
    tar -xzf "$TMP_STS/spring-boot-ls.tar.gz" -C "$TMP_STS"
    mv "$TMP_STS/spring-boot-language-server" "$SPRING_BOOT_DIR"
    chmod +x "$SPRING_BOOT_DIR/bin/spring-boot-language-server"
    ln -sf "$SPRING_BOOT_DIR/bin/spring-boot-language-server" "$SPRING_BOOT_BIN"
    rm -rf "$TMP_STS"
    ok "spring-boot-language-server → $SPRING_BOOT_BIN"
  else
    warn "curl not found — skipping spring-boot-language-server download."
    warn "Download manually from: https://github.com/spring-projects/sts4/releases"
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
title "Done"
echo "  1. Open Neovim — lazy.nvim will sync plugins on first launch."
echo "  2. Treesitter parsers install async on startup (or :TSInstall <lang>)."
echo "  3. Check LSP status inside a file with :LspInfo."
echo "  4. Check overall health with :checkhealth."
echo
