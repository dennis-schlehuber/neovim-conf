#!/usr/bin/env bash
# install.sh — installs runtime prerequisites and tools not managed by Mason.
# LSP servers (ts_ls, pyright, svelte, html, cssls, gopls, jdtls,
# kotlin-language-server, lemminx), formatters (prettier, stylua), and linters
# (ktlint) are auto-installed by Mason on first Neovim launch.
# This script only handles what Mason cannot: eslint, pylint, lazygit, JDK,
# spring-boot-language-server, and lombok.jar.
# Target OS: Arch Linux (pacman / AUR)
#
# Usage:
#   chmod +x install.sh && ./install.sh

set -uo pipefail

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

PACMAN_PKGS=()
queue_pacman() { PACMAN_PKGS+=("$@"); }

# ── Treesitter directories ────────────────────────────────────────────────────
title "Treesitter"

NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
mkdir -p "$NVIM_DATA/parser"
ok "Parser cache:  $NVIM_DATA/parser"
mkdir -p "$NVIM_DATA/lazy"
ok "Lazy data dir: $NVIM_DATA/lazy"

# ── npm — linters and tree-sitter CLI ────────────────────────────────────────
title "npm packages"
# Note: ts_ls, pyright, svelte-language-server, html, cssls, prettier are
# auto-installed by Mason on first Neovim launch.

if ! has npm; then
  err "npm not found. Install Node.js (https://nodejs.org) then re-run."
  echo "  Skipping: eslint, tree-sitter-cli"
  echo "  Note: Mason also requires npm to install JS/TS-based language servers."
else
  npm_global() {
    info "npm install -g $*"
    npm install -g "$@" || warn "npm install -g $* failed — continuing"
  }
  npm_global eslint                                  # linter   (nvim-lint)
  npm_global tree-sitter-cli                         # treesitter parser builder
fi

# ── System packages (pacman) ──────────────────────────────────────────────────
title "System packages"
# Note: jdtls, kotlin-language-server, lemminx, stylua, ktlint are
# auto-installed by Mason on first Neovim launch.

# python-pylint — Python linter used by nvim-lint
if has pylint; then ok "pylint already in PATH"; else queue_pacman python-pylint; fi

# lazygit — used by the <leader>gg toggleterm integration
if has lazygit; then ok "lazygit already in PATH"; else queue_pacman lazygit; fi

# jdk-openjdk — required to run Mason-managed tools: jdtls, kotlin-language-server, ktlint
if has java; then ok "java already in PATH"; else queue_pacman jdk-openjdk; fi

# Install queued pacman packages
if [ ${#PACMAN_PKGS[@]} -gt 0 ]; then
  if has pacman; then
    info "pacman -S --needed ${PACMAN_PKGS[*]}"
    sudo pacman -S --needed "${PACMAN_PKGS[@]}" \
      || warn "pacman install failed for some packages — continuing"
  else
    warn "pacman not available. Install manually: ${PACMAN_PKGS[*]}"
  fi
fi

# ── Java / Kotlin — Spring Boot + Lombok ─────────────────────────────────────
title "Java/Kotlin — Spring Boot + Lombok"

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
JDTLS_DATA="$HOME/.local/share/jdtls"
mkdir -p "$JDTLS_DATA"

# lombok.jar — enables Lombok annotation processing in jdtls
LOMBOK_JAR="$JDTLS_DATA/lombok.jar"
if [[ -f "$LOMBOK_JAR" ]]; then
  ok "lombok.jar already present: $LOMBOK_JAR"
else
  if has curl; then
    info "Downloading lombok.jar…"
    curl -fsSL "https://projectlombok.org/downloads/lombok.jar" -o "$LOMBOK_JAR" \
      || warn "lombok.jar download failed — continuing"
    [[ -f "$LOMBOK_JAR" ]] && ok "lombok.jar → $LOMBOK_JAR"
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
      | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/') \
      || { warn "Failed to fetch STS4 release info — skipping spring-boot-language-server"; STS4_VERSION=""; }
    if [[ -n "${STS4_VERSION:-}" ]]; then
      STS4_VERSION_NUM="${STS4_VERSION#v}"
      STS4_URL="https://github.com/spring-projects/sts4/releases/download/${STS4_VERSION}/spring-boot-language-server-${STS4_VERSION_NUM}.tar.gz"
      TMP_STS=$(mktemp -d)
      curl -fsSL "$STS4_URL" -o "$TMP_STS/spring-boot-ls.tar.gz" \
        && tar -xzf "$TMP_STS/spring-boot-ls.tar.gz" -C "$TMP_STS" \
        && mv "$TMP_STS/spring-boot-language-server" "$SPRING_BOOT_DIR" \
        && chmod +x "$SPRING_BOOT_DIR/bin/spring-boot-language-server" \
        && ln -sf "$SPRING_BOOT_DIR/bin/spring-boot-language-server" "$SPRING_BOOT_BIN" \
        && ok "spring-boot-language-server → $SPRING_BOOT_BIN" \
        || warn "spring-boot-language-server install failed — continuing"
      rm -rf "$TMP_STS"
    fi
  else
    warn "curl not found — skipping spring-boot-language-server download."
    warn "Download manually from: https://github.com/spring-projects/sts4/releases"
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
title "Done"
echo "  1. Open Neovim — lazy.nvim syncs plugins, then Mason auto-installs all"
echo "     LSP servers (ts_ls, pyright, svelte, html, cssls, gopls, jdtls,"
echo "     kotlin-language-server, lemminx), prettier, stylua, and ktlint."
echo "  2. Treesitter parsers install async on startup (or :TSInstall <lang>)."
echo "  3. Check LSP status inside a file with :LspInfo."
echo "  4. Check Mason status with :Mason."
echo "  5. Check overall health with :checkhealth."
echo
