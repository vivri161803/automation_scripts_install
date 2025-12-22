#!/bin/bash
# setup.sh
set -e

# Rendi eseguibili gli script nella sottocartella
chmod +x scripts_bin/*.sh

echo "🚀 AVVIO AUTOMAZIONE..."
sudo -v

# Loop per mantenere sudo attivo
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Esecuzione sequenziale
./scripts_bin/01-system.sh
./scripts_bin/02-nvim.sh
./scripts_bin/03-gnome.sh
./scripts_bin/04-docker.sh
./scripts_bin/05-fonts.sh
./scripts_bin/06-starship.sh
./scripts_bin/07-sway-install.sh
./scripts_bin/08-sway-config.sh

echo "✅ FINITO! Riavvia il computer."
