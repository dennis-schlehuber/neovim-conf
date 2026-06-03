#!/usr/bin/env bash
# install-macos.sh — installs runtime prerequisites and tools not managed by Mason.
# LSP servers (ts_ls, pyright, svelte, html, cssls, gopls, jdtls,
# kotlin-language-server, lemminx), formatters (prettier, stylua), and linters
# (ktlint) are auto-installed by Mason on first Neovim launch.
# This script only handles what Mason cannot: eslint, pylint, lazygit, JDK,
# spring-boot-language-server, and lombok.jar.
# Target OS: macOS (requires Homebrew)
#
# Usage:
#   chmod +x install-macos.sh && ./install-macos.sh

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

# ── Homebrew check ────────────────────────────────────────────────────────────
title "Homebrew"

if ! has brew; then
  err "Homebrew not found. Install it from https://brew.sh then re-run."
  exit 1
fi
ok "brew $(brew --version | head -1)"

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
    "$PIP" install --user pylint --break-system-packages \
      || warn "pylint install failed — continuing"
    ok "pylint"
  fi
fi

# ── Homebrew packages ─────────────────────────────────────────────────────────
title "Homebrew packages"

brew_install() {
  local pkg="$1"
  local bin="${2:-$1}"
  if has "$bin"; then
    ok "$bin already in PATH"
  else
    info "brew install $pkg"
    brew install "$pkg" || warn "brew install $pkg failed — continuing"
    ok "$pkg"
  fi
}

brew_install lazygit lazygit      # used by <leader>gg toggleterm integration

# ── Java runtime ──────────────────────────────────────────────────────────────
title "Java runtime"
# Required to run Mason-managed tools: jdtls, kotlin-language-server, ktlint

if has java; then
  ok "java $(java -version 2>&1 | head -1)"
else
  warn "java not found. Mason-managed tools (jdtls, kotlin-language-server, ktlint) require a JDK."
  warn "Install with: brew install --cask temurin"
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
  curl -fsSL "https://projectlombok.org/downloads/lombok.jar" -o "$LOMBOK_JAR" \
    || warn "lombok.jar download failed — continuing"
  [[ -f "$LOMBOK_JAR" ]] && ok "lombok.jar → $LOMBOK_JAR"
fi

# spring-boot-language-server — Spring Boot LSP (extracted from STS4 .vsix)
# The standalone tarball was discontinued in v5.x; releases now ship as a VS Code
# extension (.vsix). We unzip it, copy out the JAR, and install a thin wrapper.
SPRING_BOOT_DIR="$HOME/.local/share/spring-boot-language-server"
SPRING_BOOT_WRAPPER="$LOCAL_BIN/spring-boot-language-server"

if has spring-boot-language-server || [[ -f "$SPRING_BOOT_WRAPPER" ]]; then
  ok "spring-boot-language-server already installed"
else
  info "Downloading spring-boot-language-server (from STS4 .vsix)…"
  VSIX_URL=$(curl -fsSL "https://api.github.com/repos/spring-projects/sts4/releases/latest" \
    | grep '"browser_download_url"' | grep '\.vsix' | head -1 \
    | sed 's/.*"browser_download_url": *"\([^"]*\)".*/\1/') \
    || { warn "Failed to fetch spring-boot-language-server release info — skipping"; VSIX_URL=""; }
  if [[ -n "${VSIX_URL:-}" ]]; then
    TMP_STS=$(mktemp -d)
    curl -fsSL "$VSIX_URL" -o "$TMP_STS/spring-boot.vsix" \
      && unzip -q "$TMP_STS/spring-boot.vsix" -d "$TMP_STS/vsix" \
      || { warn "spring-boot-language-server download/unzip failed — skipping"; rm -rf "$TMP_STS"; VSIX_URL=""; }
    if [[ -n "${VSIX_URL:-}" ]]; then
      SB_JAR=$(find "$TMP_STS/vsix" -name "spring-boot-language-server.jar" | head -1)
      if [[ -z "$SB_JAR" ]]; then
        err "Could not locate spring-boot-language-server.jar inside the vsix."
        rm -rf "$TMP_STS"
      else
        mkdir -p "$SPRING_BOOT_DIR" "$LOCAL_BIN"
        cp "$SB_JAR" "$SPRING_BOOT_DIR/spring-boot-language-server.jar"
        rm -rf "$TMP_STS"
        cat > "$SPRING_BOOT_WRAPPER" <<'WRAPPER'
#!/usr/bin/env bash
exec java -jar "$HOME/.local/share/spring-boot-language-server/spring-boot-language-server.jar" "$@"
WRAPPER
        chmod +x "$SPRING_BOOT_WRAPPER"
        ok "spring-boot-language-server → $SPRING_BOOT_WRAPPER"
      fi
    fi
  fi
fi

# ── PATH reminder ─────────────────────────────────────────────────────────────
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
  warn "$LOCAL_BIN is not in your PATH."
  warn "Add the following to your ~/.zshrc or ~/.bash_profile:"
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
