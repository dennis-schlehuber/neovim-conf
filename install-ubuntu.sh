#!/usr/bin/env bash
# install-ubuntu.sh — installs LSP servers, formatters, linters, and ensures
# the correct Neovim data directories exist for treesitter parsers.
# Target OS: Ubuntu 22.04+ / Debian-based
#
# Usage:
#   chmod +x install-ubuntu.sh && ./install-ubuntu.sh

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

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Fetch the tag_name of the latest GitHub release for a given repo slug
gh_latest() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/'
}

# Download a URL to a temp file, print the temp path
gh_download() {
  local url="$1"
  local tmp
  tmp=$(mktemp)
  curl -fsSL "$url" -o "$tmp"
  echo "$tmp"
}

# ── apt check ─────────────────────────────────────────────────────────────────
title "apt"

if ! has apt-get; then
  err "apt-get not found. This script targets Ubuntu/Debian systems."
  exit 1
fi

info "apt-get update"
sudo apt-get update -qq

# ── Treesitter directories ────────────────────────────────────────────────────
title "Treesitter"

NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
mkdir -p "$NVIM_DATA/parser"
ok "Parser cache:  $NVIM_DATA/parser"
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

# ── Python — pylint ───────────────────────────────────────────────────────────
title "Python packages"

if ! has pip3 && ! has pip; then
  warn "pip3/pip not found. Install Python 3 then re-run."
  echo "  Skipping: pylint"
else
  PIP="${PIP:-pip3}"
  has pip3 && PIP=pip3 || PIP=pip
  if has pylint; then
    ok "pylint already in PATH"
  else
    info "$PIP install --user pylint"
    "$PIP" install --user pylint
    ok "pylint"
  fi
fi

# ── apt packages ──────────────────────────────────────────────────────────────
title "apt packages"

apt_install() {
  local pkg="$1"
  local bin="${2:-$1}"
  if has "$bin"; then
    ok "$bin already in PATH"
  else
    info "apt-get install -y $pkg"
    sudo apt-get install -y "$pkg"
    ok "$pkg"
  fi
}

# jdtls — Java LSP (available in Ubuntu 24.04 universe; may need `universe` repo)
if has jdtls; then
  ok "jdtls already in PATH"
else
  if apt-cache show jdtls &>/dev/null 2>&1; then
    info "apt-get install -y jdtls"
    sudo apt-get install -y jdtls
    ok "jdtls"
  else
    warn "jdtls not found in apt. Enable the 'universe' repo or install manually:"
    warn "  sudo add-apt-repository universe && sudo apt-get update && sudo apt-get install jdtls"
  fi
fi

# ── curl check (required for binary downloads) ────────────────────────────────
title "Binary downloads (GitHub releases)"

if ! has curl; then
  info "Installing curl…"
  sudo apt-get install -y curl
fi

# ── stylua — Lua formatter ────────────────────────────────────────────────────
if has stylua; then
  ok "stylua already in PATH"
else
  info "Downloading stylua (latest release)…"
  STYLUA_VERSION=$(gh_latest "JohnnyMorganz/StyLua")
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  STYLUA_ASSET="stylua-linux-x86_64.zip" ;;
    aarch64) STYLUA_ASSET="stylua-linux-aarch64.zip" ;;
    *)       err "Unsupported arch for stylua: $ARCH"; STYLUA_ASSET="" ;;
  esac
  if [[ -n "$STYLUA_ASSET" ]]; then
    TMP=$(gh_download "https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_VERSION}/${STYLUA_ASSET}")
    unzip -q "$TMP" -d "$LOCAL_BIN"
    chmod +x "$LOCAL_BIN/stylua"
    rm -f "$TMP"
    ok "stylua → $LOCAL_BIN/stylua"
  fi
fi

# ── lazygit ───────────────────────────────────────────────────────────────────
if has lazygit; then
  ok "lazygit already in PATH"
else
  info "Downloading lazygit (latest release)…"
  LG_VERSION=$(gh_latest "jesseduffield/lazygit")
  LG_VERSION_NUM="${LG_VERSION#v}"
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  LG_ARCH="x86_64" ;;
    aarch64) LG_ARCH="arm64" ;;
    *)       err "Unsupported arch for lazygit: $ARCH"; LG_ARCH="" ;;
  esac
  if [[ -n "$LG_ARCH" ]]; then
    LG_URL="https://github.com/jesseduffield/lazygit/releases/download/${LG_VERSION}/lazygit_${LG_VERSION_NUM}_Linux_${LG_ARCH}.tar.gz"
    TMP_DIR=$(mktemp -d)
    TMP=$(gh_download "$LG_URL")
    tar -xzf "$TMP" -C "$TMP_DIR" lazygit
    chmod +x "$TMP_DIR/lazygit"
    mv "$TMP_DIR/lazygit" "$LOCAL_BIN/lazygit"
    rm -rf "$TMP" "$TMP_DIR"
    ok "lazygit → $LOCAL_BIN/lazygit"
  fi
fi

# ── ktlint — Kotlin linter ────────────────────────────────────────────────────
if has ktlint; then
  ok "ktlint already in PATH"
else
  info "Downloading ktlint (latest release)…"
  KTLINT_VERSION=$(gh_latest "pinterest/ktlint")
  KTLINT_URL="https://github.com/pinterest/ktlint/releases/download/${KTLINT_VERSION}/ktlint"
  TMP=$(gh_download "$KTLINT_URL")
  chmod +x "$TMP"
  mv "$TMP" "$LOCAL_BIN/ktlint"
  ok "ktlint → $LOCAL_BIN/ktlint"
fi

# ── kotlin-language-server ────────────────────────────────────────────────────
if has kotlin-language-server; then
  ok "kotlin-language-server already in PATH"
else
  info "Downloading kotlin-language-server (latest release)…"
  KLS_VERSION=$(gh_latest "fwcd/kotlin-language-server")
  KLS_URL="https://github.com/fwcd/kotlin-language-server/releases/download/${KLS_VERSION}/server.zip"
  TMP_KLS=$(mktemp -d)
  TMP=$(gh_download "$KLS_URL")
  unzip -q "$TMP" -d "$TMP_KLS/kls"
  chmod +x "$TMP_KLS/kls/server/bin/kotlin-language-server"
  KLS_DEST="$HOME/.local/share/kotlin-language-server"
  rm -rf "$KLS_DEST"
  mv "$TMP_KLS/kls/server" "$KLS_DEST"
  ln -sf "$KLS_DEST/bin/kotlin-language-server" "$LOCAL_BIN/kotlin-language-server"
  rm -rf "$TMP" "$TMP_KLS"
  ok "kotlin-language-server → $LOCAL_BIN/kotlin-language-server"
fi

# ── lemminx — XML LSP ─────────────────────────────────────────────────────────
if has lemminx; then
  ok "lemminx already in PATH"
else
  info "Downloading lemminx (latest release)…"
  LEMMINX_VERSION=$(gh_latest "eclipse/lemminx")
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  LEMMINX_ASSET="lemminx-linux.zip" ;;
    aarch64) LEMMINX_ASSET="lemminx-linux-aarch_64.zip" ;;
    *)       err "Unsupported arch for lemminx: $ARCH"; LEMMINX_ASSET="" ;;
  esac
  if [[ -n "$LEMMINX_ASSET" ]]; then
    LEMMINX_URL="https://github.com/eclipse/lemminx/releases/download/${LEMMINX_VERSION}/${LEMMINX_ASSET}"
    TMP_DIR=$(mktemp -d)
    TMP=$(gh_download "$LEMMINX_URL")
    unzip -q "$TMP" -d "$TMP_DIR"
    LEMMINX_BIN=$(find "$TMP_DIR" -type f -name "lemminx*" | head -1)
    chmod +x "$LEMMINX_BIN"
    mv "$LEMMINX_BIN" "$LOCAL_BIN/lemminx"
    rm -rf "$TMP" "$TMP_DIR"
    ok "lemminx → $LOCAL_BIN/lemminx"
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
  info "Downloading lombok.jar…"
  curl -fsSL "https://projectlombok.org/downloads/lombok.jar" -o "$LOMBOK_JAR"
  ok "lombok.jar → $LOMBOK_JAR"
fi

# spring-boot-language-server — Spring Boot LSP (from STS4 GitHub releases)
SPRING_BOOT_DIR="$HOME/.local/share/spring-boot-language-server"
if has spring-boot-language-server; then
  ok "spring-boot-language-server already in PATH"
elif [[ -d "$SPRING_BOOT_DIR" ]]; then
  ok "spring-boot-language-server already installed at $SPRING_BOOT_DIR"
else
  info "Downloading spring-boot-language-server (latest STS4 release)…"
  STS4_VERSION=$(gh_latest "spring-projects/sts4")
  STS4_VERSION_NUM="${STS4_VERSION#v}"
  STS4_URL="https://github.com/spring-projects/sts4/releases/download/${STS4_VERSION}/spring-boot-language-server-${STS4_VERSION_NUM}.tar.gz"
  TMP_STS=$(mktemp -d)
  TMP=$(gh_download "$STS4_URL")
  tar -xzf "$TMP" -C "$TMP_STS"
  mv "$TMP_STS/spring-boot-language-server" "$SPRING_BOOT_DIR"
  chmod +x "$SPRING_BOOT_DIR/bin/spring-boot-language-server"
  ln -sf "$SPRING_BOOT_DIR/bin/spring-boot-language-server" "$LOCAL_BIN/spring-boot-language-server"
  rm -rf "$TMP" "$TMP_STS"
  ok "spring-boot-language-server → $LOCAL_BIN/spring-boot-language-server"
fi

# ── PATH reminder ─────────────────────────────────────────────────────────────
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
  warn "$LOCAL_BIN is not in your PATH."
  warn "Add the following to your ~/.bashrc or ~/.profile:"
  warn "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# ── Done ──────────────────────────────────────────────────────────────────────
title "Done"
echo "  1. Open Neovim — lazy.nvim will sync plugins on first launch."
echo "  2. Treesitter parsers install async on startup (or :TSInstall <lang>)."
echo "  3. Check LSP status inside a file with :LspInfo."
echo "  4. Check overall health with :checkhealth."
echo
