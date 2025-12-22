#!/bin/bash
echo "🎨 [3/4] Configurazione GNOME..."

# Installa gestore estensioni CLI
if ! command -v pipx &>/dev/null; then
  sudo apt install -y pipx
  pipx ensurepath
fi
pipx install gnome-extensions-cli --system-site-packages --force

# Installa estensioni dalla lista
while IFS= read -r ext_uuid; do
  [ -z "$ext_uuid" ] && continue
  echo "   🧩 Installazione estensione: $ext_uuid"
  ~/.local/bin/gext install "$ext_uuid"
  ~/.local/bin/gext enable "$ext_uuid"
done <config/extensions.list

# Ripristina settings (se hai salvato il file in precedenza con: dconf dump / > config/gnome.conf)
if [ -f "config/gnome.conf" ]; then
  echo "   ⚙️  Ripristino configurazione dconf..."
  dconf load / <config/gnome.conf
fi
