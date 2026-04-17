#!/usr/bin/env bash
# install-macos.sh — installs LSP servers, formatters, linters, and ensures
# the correct Neovim data directories exist for treesitter parsers.
# Target OS: macOS (requires Homebrew)
#
# Usage:
#   chmod +x install-macos.sh && ./install-macos.sh

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

# ── Homebrew packages ─────────────────────────────────────────────────────────
title "Homebrew packages"

brew_install() {
  local pkg="$1"
  local bin="${2:-$1}"
  if has "$bin"; then
    ok "$bin already in PATH"
  else
    info "brew install $pkg"
    brew install "$pkg"
    ok "$pkg"
  fi
}

brew_install jdtls jdtls          # Java LSP
brew_install stylua stylua        # Lua formatter (conform.nvim)
brew_install lazygit lazygit      # used by <leader>gg toggleterm integration
brew_install ktlint ktlint        # Kotlin linter (nvim-lint)

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
    "$PIP" install --user pylint --break-system-packages
    ok "pylint"
  fi
fi

# ── GitHub binary downloads ───────────────────────────────────────────────────
title "GitHub binary downloads"

if ! has curl; then
  warn "curl not found — skipping binary downloads (kotlin-language-server, lemminx)."
  warn "Install curl, then re-run, or download manually:"
  warn "  kotlin-language-server: https://github.com/fwcd/kotlin-language-server/releases"
  warn "  lemminx:                https://github.com/eclipse/lemminx/releases"
else
  mkdir -p "$LOCAL_BIN"

  # ── kotlin-language-server ────────────────────────────────────────────────
  if has kotlin-language-server; then
    ok "kotlin-language-server already in PATH"
  else
    info "Downloading kotlin-language-server (latest release)…"
    KLS_VERSION=$(curl -fsSL "https://api.github.com/repos/fwcd/kotlin-language-server/releases/latest" \
      | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')
    KLS_URL="https://github.com/fwcd/kotlin-language-server/releases/download/${KLS_VERSION}/server.zip"
    TMP_KLS=$(mktemp -d)
    curl -fsSL "$KLS_URL" -o "$TMP_KLS/server.zip"
    unzip -q "$TMP_KLS/server.zip" -d "$TMP_KLS/kls"
    # The zip contains a bin/ directory with the launcher script
    chmod +x "$TMP_KLS/kls/server/bin/kotlin-language-server"
    # Install the whole server dir and symlink the launcher
    KLS_DEST="$HOME/.local/share/kotlin-language-server"
    rm -rf "$KLS_DEST"
    mv "$TMP_KLS/kls/server" "$KLS_DEST"
    ln -sf "$KLS_DEST/bin/kotlin-language-server" "$LOCAL_BIN/kotlin-language-server"
    rm -rf "$TMP_KLS"
    ok "kotlin-language-server → $LOCAL_BIN/kotlin-language-server"
  fi

  # ── lemminx (XML LSP) ─────────────────────────────────────────────────────
  if has lemminx; then
    ok "lemminx already in PATH"
  else
    info "Downloading lemminx (latest release)…"
    LEMMINX_VERSION=$(curl -fsSL "https://api.github.com/repos/redhat-developer/vscode-xml/releases/latest" \
      | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')
    LEMMINX_URL="https://github.com/redhat-developer/vscode-xml/releases/download/${LEMMINX_VERSION}/lemminx-osx-x86_64.zip"
    # Apple Silicon fallback
    if [[ "$(uname -m)" == "arm64" ]]; then
      LEMMINX_URL="https://github.com/redhat-developer/vscode-xml/releases/download/${LEMMINX_VERSION}/lemminx-osx-aarch_64.zip"
    fi
    TMP_LX=$(mktemp -d)
    curl -fsSL "$LEMMINX_URL" -o "$TMP_LX/lemminx.zip"
    unzip -q "$TMP_LX/lemminx.zip" -d "$TMP_LX/lemminx"
    LEMMINX_BIN=$(find "$TMP_LX/lemminx" -type f -name "lemminx*" | head -1)
    chmod +x "$LEMMINX_BIN"
    mv "$LEMMINX_BIN" "$LOCAL_BIN/lemminx"
    rm -rf "$TMP_LX"
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
    | sed 's/.*"browser_download_url": *"\([^"]*\)".*/\1/')
  TMP_STS=$(mktemp -d)
  curl -fsSL "$VSIX_URL" -o "$TMP_STS/spring-boot.vsix"
  unzip -q "$TMP_STS/spring-boot.vsix" -d "$TMP_STS/vsix"
  SB_JAR=$(find "$TMP_STS/vsix" -name "spring-boot-language-server.jar" | head -1)
  if [[ -z "$SB_JAR" ]]; then
    err "Could not locate spring-boot-language-server.jar inside the vsix."
    rm -rf "$TMP_STS"
  else
    mkdir -p "$SPRING_BOOT_DIR"
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

# ── PATH reminder ─────────────────────────────────────────────────────────────
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
  warn "$LOCAL_BIN is not in your PATH."
  warn "Add the following to your ~/.zshrc or ~/.bash_profile:"
  warn "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# ── Done ──────────────────────────────────────────────────────────────────────
title "Done"
echo "  1. Open Neovim — lazy.nvim will sync plugins on first launch."
echo "  2. Treesitter parsers install async on startup (or :TSInstall <lang>)."
echo "  3. Check LSP status inside a file with :LspInfo."
echo "  4. Check overall health with :checkhealth."
echo
