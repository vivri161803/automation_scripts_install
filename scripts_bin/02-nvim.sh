#!/bin/bash
echo "📝 [2/4] Installazione Neovim (Latest Stable)..."

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Scarica
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz

# Pulisce vecchia versione ed estrae la nuova
rm -rf "$HOME/.local/share/nvim-linux64"
tar -xzf nvim-linux64.tar.gz -C "$HOME/.local/share/"
rm nvim-linux64.tar.gz

# Link simbolico
ln -sf "$HOME/.local/share/nvim-linux64/bin/nvim" "$INSTALL_DIR/nvim"

echo "   ✅ Neovim installato: $($INSTALL_DIR/nvim --version | head -n 1)"
