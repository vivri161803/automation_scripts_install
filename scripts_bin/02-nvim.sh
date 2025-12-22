#!/bin/bash
set -e

echo "📝 [2/4] Installazione Neovim (System-wide in /opt)..."

# URL e Nomi file basati sulla tua richiesta
NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
NVIM_FILENAME="nvim-linux-x86_64.tar.gz"
INSTALL_DIR="/opt/nvim-linux-x86_64"

# 1. Scarica il file
echo "   ⬇️  Scaricamento in corso..."
rm -f "$NVIM_FILENAME" # Rimuove residui
curl -LO --fail "$NVIM_URL"

# Verifica integrità download (evita errori gzip)
if ! file "$NVIM_FILENAME" | grep -q "gzip compressed data"; then
  echo "❌ ERRORE: Il file scaricato non è valido. Controlla la connessione."
  rm "$NVIM_FILENAME"
  exit 1
fi

# 2. Pulisce installazioni precedenti in /opt
echo "   🧹 Pulizia vecchia versione in /opt..."
if [ -d "$INSTALL_DIR" ]; then
  sudo rm -rf "$INSTALL_DIR"
fi

# 3. Estrae in /opt (Richiede sudo)
echo "   📦 Estrazione in /opt..."
sudo tar -C /opt -xzf "$NVIM_FILENAME"

# 4. Rende il comando disponibile globalmente (sostituisce l'export PATH)
# Creiamo un link simbolico in /usr/local/bin che è già nel PATH di tutti
echo "   🔗 Creazione link simbolico..."
sudo ln -sf "$INSTALL_DIR/bin/nvim" /usr/local/bin/nvim

# 5. Pulizia file temporaneo
rm "$NVIM_FILENAME"

# 6. Setup LazyVim (Opzionale, se vuoi mantenerlo)
echo "   💤 Configurazione LazyVim..."
if [ ! -d "$HOME/.config/nvim" ]; then
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
fi

echo "   ✅ Neovim installato: $(nvim --version | head -n 1)"
