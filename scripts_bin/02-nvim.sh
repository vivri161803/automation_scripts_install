#!/bin/bash
set -e

echo "📝 [2/4] Installazione Neovim (Latest Stable)..."

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Rimuovi eventuali download parziali precedenti
rm -f nvim-linux64.tar.gz

echo "   ⬇️  Scaricamento in corso..."
# --fail: si ferma se il server dà errore (es. 404)
# --location: segue i redirect
curl -L --fail -o nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz

# Verifica che il file sia davvero un archivio gzip
if ! file nvim-linux64.tar.gz | grep -q "gzip compressed data"; then
  echo "❌ ERRORE: Il file scaricato non è un archivio valido. Controlla la connessione internet."
  echo "Contenuto del file scaricato:"
  head -n 5 nvim-linux64.tar.gz
  exit 1
fi

echo "   📦 Estrazione..."
# Pulisce vecchia versione ed estrae la nuova
rm -rf "$HOME/.local/share/nvim-linux64"
tar -xzf nvim-linux64.tar.gz -C "$HOME/.local/share/"
rm nvim-linux64.tar.gz

# Link simbolico
ln -sf "$HOME/.local/share/nvim-linux64/bin/nvim" "$INSTALL_DIR/nvim"

echo "   ✅ Neovim installato: $($INSTALL_DIR/nvim --version | head -n 1)"

# installazione di LazyVim
echo "   💤 Clonazione LazyVim Starter..."

# Backup preventivo (se esiste già una config)
if [ -d "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%s)"
fi

# Clone della repo
git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"

# Rimuove il link a git dello starter kit
rm -rf "$HOME/.config/nvim/.git"

echo "   ✅ LazyVim configurato! (I plugin si installeranno al primo avvio)"
