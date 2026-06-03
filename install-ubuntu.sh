#!/usr/bin/env bash
# install-ubuntu.sh — installs runtime prerequisites and tools not managed by Mason.
# LSP servers (ts_ls, pyright, svelte, html, cssls, gopls, jdtls,
# kotlin-language-server, lemminx), formatters (prettier, stylua), and linters
# (ktlint) are auto-installed by Mason on first Neovim launch.
# This script only handles what Mason cannot: eslint, pylint, lazygit, JDK,
# spring-boot-language-server, and lombok.jar.
# Target OS: Ubuntu 22.04+ / Debian-based
#
# Usage:
#   chmod +x install-ubuntu.sh && ./install-ubuntu.sh

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
sudo apt-get update -qq || warn "apt-get update failed — continuing with cached index"

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
    "$PIP" install --user pylint || warn "pylint install failed — continuing"
    ok "pylint"
  fi
fi

# ── Java runtime ──────────────────────────────────────────────────────────────
title "Java runtime"
# Required to run Mason-managed tools: jdtls, kotlin-language-server, ktlint

if has java; then
  ok "java already in PATH"
else
  info "apt-get install -y default-jdk"
  sudo apt-get install -y default-jdk \
    || warn "default-jdk install failed — Mason-managed Java tools may not work"
  has java && ok "default-jdk"
fi

# ── curl check (required for binary downloads) ────────────────────────────────
title "Binary downloads (GitHub releases)"

if ! has curl; then
  info "Installing curl…"
  sudo apt-get install -y curl || warn "curl install failed — binary downloads will be skipped"
fi

# ── lazygit ───────────────────────────────────────────────────────────────────
if has lazygit; then
  ok "lazygit already in PATH"
elif ! has curl; then
  warn "curl not available — skipping lazygit download"
else
  info "Downloading lazygit (latest release)…"
  LG_VERSION=$(gh_latest "jesseduffield/lazygit") \
    || { warn "Failed to fetch lazygit release info — skipping"; LG_VERSION=""; }
  if [[ -n "${LG_VERSION:-}" ]]; then
    LG_VERSION_NUM="${LG_VERSION#v}"
    ARCH=$(uname -m)
    case "$ARCH" in
      x86_64)  LG_ARCH="x86_64" ;;
      aarch64) LG_ARCH="arm64" ;;
      *)       err "Unsupported arch for lazygit: $ARCH"; LG_ARCH="" ;;
    esac
    if [[ -n "${LG_ARCH:-}" ]]; then
      LG_URL="https://github.com/jesseduffield/lazygit/releases/download/${LG_VERSION}/lazygit_${LG_VERSION_NUM}_Linux_${LG_ARCH}.tar.gz"
      TMP_DIR=$(mktemp -d)
      TMP=$(gh_download "$LG_URL") \
        && tar -xzf "$TMP" -C "$TMP_DIR" lazygit \
        && chmod +x "$TMP_DIR/lazygit" \
        && mv "$TMP_DIR/lazygit" "$LOCAL_BIN/lazygit" \
        && ok "lazygit → $LOCAL_BIN/lazygit" \
        || warn "lazygit download failed — continuing"
      rm -rf "${TMP:-}" "$TMP_DIR"
    fi
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
elif ! has curl; then
  warn "curl not available — skipping lombok.jar download"
else
  info "Downloading lombok.jar…"
  curl -fsSL "https://projectlombok.org/downloads/lombok.jar" -o "$LOMBOK_JAR" \
    || warn "lombok.jar download failed — continuing"
  [[ -f "$LOMBOK_JAR" ]] && ok "lombok.jar → $LOMBOK_JAR"
fi

# spring-boot-language-server — Spring Boot LSP (from STS4 GitHub releases)
SPRING_BOOT_DIR="$HOME/.local/share/spring-boot-language-server"
if has spring-boot-language-server; then
  ok "spring-boot-language-server already in PATH"
elif [[ -d "$SPRING_BOOT_DIR" ]]; then
  ok "spring-boot-language-server already installed at $SPRING_BOOT_DIR"
elif ! has curl; then
  warn "curl not available — skipping spring-boot-language-server download"
else
  info "Downloading spring-boot-language-server (latest STS4 release)…"
  STS4_VERSION=$(gh_latest "spring-projects/sts4") \
    || { warn "Failed to fetch STS4 release info — skipping spring-boot-language-server"; STS4_VERSION=""; }
  if [[ -n "${STS4_VERSION:-}" ]]; then
    STS4_VERSION_NUM="${STS4_VERSION#v}"
    STS4_URL="https://github.com/spring-projects/sts4/releases/download/${STS4_VERSION}/spring-boot-language-server-${STS4_VERSION_NUM}.tar.gz"
    TMP_STS=$(mktemp -d)
    TMP=$(gh_download "$STS4_URL") \
      && tar -xzf "$TMP" -C "$TMP_STS" \
      && mv "$TMP_STS/spring-boot-language-server" "$SPRING_BOOT_DIR" \
      && chmod +x "$SPRING_BOOT_DIR/bin/spring-boot-language-server" \
      && ln -sf "$SPRING_BOOT_DIR/bin/spring-boot-language-server" "$LOCAL_BIN/spring-boot-language-server" \
      && ok "spring-boot-language-server → $LOCAL_BIN/spring-boot-language-server" \
      || warn "spring-boot-language-server install failed — continuing"
    rm -rf "${TMP:-}" "$TMP_STS"
  fi
fi

# ── PATH reminder ─────────────────────────────────────────────────────────────
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
  warn "$LOCAL_BIN is not in your PATH."
  warn "Add the following to your ~/.bashrc or ~/.profile:"
  warn "  export PATH=\"\$HOME/.local/bin:\$PATH\""
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
