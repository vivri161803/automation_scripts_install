#!/bin/bash
set -e

echo "----------------------------------------------------"
echo "🚨 DISINSTALLAZIONE TOTALE SWAY & AMICI"
echo "----------------------------------------------------"
echo "⚠️  ATTENZIONE: Questo script rimuoverà Sway, Waybar,"
echo "    Wofi, Wlogout e tutte le configurazioni create."
echo ""
read -p "Sei sicuro di voler procedere? (scrivi 'si' per confermare): " CONFIRM

if [ "$CONFIRM" != "si" ]; then
  echo "❌ Operazione annullata."
  exit 1
fi

# 1. Rimozione Pacchetti (Purge rimuove anche le config di sistema)
echo "   🗑️  Rimozione pacchetti software..."

# Lista dei pacchetti installati dai nostri script
PACKAGES_TO_REMOVE=(
  sway swaybg swayidle swaylock
  waybar wofi mako-notifier wlogout
  grim slurp wl-clipboard
  pavucontrol pamixer brightnessctl
  xdg-desktop-portal-wlr
  # Non rimuoviamo xdg-desktop-portal-gtk o fonts-font-awesome
  # perché potrebbero servire ad altre app di GNOME.
)

sudo apt purge -y "${PACKAGES_TO_REMOVE[@]}"

# 2. Pulizia Dipendenze Inutilizzate
echo "   🧹 Pulizia dipendenze orfane (autoremove)..."
sudo apt autoremove -y

# 3. Rimozione Configurazioni Utente (Dotfiles)
echo "   🔥 Eliminazione cartelle di configurazione..."
rm -rf "$HOME/.config/sway"
rm -rf "$HOME/.config/waybar"
rm -rf "$HOME/.config/wofi"
rm -rf "$HOME/.config/mako"
rm -rf "$HOME/.config/wlogout"

# Rimuoviamo anche lo script del wallpaper se era fuori posto
rm -f "$HOME/.config/sway/scripts/change-wallpaper.sh"

# 4. Pulizia Wallpaper (Opzionale)
# Rimuoviamo solo quello scaricato da noi per non toccare i tuoi personali
WALLPAPER="$HOME/Pictures/Wallpapers/ultimate_purple.jpg"
if [ -f "$WALLPAPER" ]; then
  echo "   🖼️  Rimozione sfondo scaricato ($WALLPAPER)..."
  rm "$WALLPAPER"
fi

# 5. Pulizia Cache (Opzionale, ma consigliata)
rm -rf "$HOME/.cache/wofi"

echo "----------------------------------------------------"
echo "✅ Disinstallazione completata."
echo "   Il sistema è pulito. Puoi riavviare per sicurezza."
echo "----------------------------------------------------"
