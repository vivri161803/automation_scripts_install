#!/bin/bash
set -e

echo "----------------------------------------------------"
echo "🚀 HOST REAL METAL: Installazione Sway & Network Tools"
echo "----------------------------------------------------"

# 1. Aggiorna i repository
sudo apt update

# 2. Installazione Pacchetti
# Aggiunti: network-manager-gnome (GUI Wifi), wtype (Simulazione tasti per ~ e |)
echo "   ⬇️  Installazione pacchetti..."
sudo apt install -y \
  sway swaybg swayidle swaylock \
  waybar wofi mako-notifier \
  grim slurp wl-clipboard \
  pavucontrol pamixer pulseaudio-utils \
  brightnessctl \
  network-manager-gnome \
  wtype \
  fonts-font-awesome papirus-icon-theme \
  xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
  libglib2.0-bin wlogout

# 3. Creazione Cartelle Config
echo "   📂 Preparazione cartelle..."
mkdir -p "$HOME/.config/sway"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/wofi"
mkdir -p "$HOME/.config/mako"
mkdir -p "$HOME/Pictures/Wallpapers"

# 4. Scaricamento Sfondo
WALLPAPER="$HOME/Pictures/Wallpapers/ultimate_purple.jpg"
if [ ! -f "$WALLPAPER" ]; then
  echo "   🖼️  Scaricamento wallpaper..."
  curl -L -o "$WALLPAPER" "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1964&auto=format&fit=crop"
fi

echo "   ✅ Installazione completata."
