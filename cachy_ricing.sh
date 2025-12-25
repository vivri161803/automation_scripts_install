# ricing 
sudo pacman -S --needed \
  autotiling \
  swayfx \
  swaylock-effects-git \
  waybar \
  rofi-wayland \
  kitty \
  thunar \
  swayidle \
  swaybg \
  network-manager-applet \
  polkit-gnome \
  grim slurp wl-clipboard \
  ttf-jetbrains-mono-nerd ttf-font-awesome papirus-icon-theme \
  swaync \
  wlogout \
  nwg-look

sudo pacman -S --needed \
  neovim \
  tmux \
  fzf \
  ripgrep \
  stow \
  git \
  zsh \
  starship \
  eza \
  bat \
  zoxide \

#!/bin/bash

# ==============================================================================
#  CACHYOS SWAY RICE & DEV SETUP - AUTOMATED INSTALLER
# ==============================================================================

# Colori per l'output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Inizio Setup Automatizzato per CachyOS ===${NC}"

# --- 1. Aggiornamento e Installazione Pacchetti ---

echo -e "${GREEN}[1/7] Aggiornamento sistema e installazione pacchetti...${NC}"
sudo pacman -Syu --noconfirm

# Lista pacchetti dai repository ufficiali (CachyOS ha molti pacchetti che su Arch sono in AUR)
PACKAGES=(
    # --- Ricing & GUI ---
    "swayfx"                # Sway con effetti (CachyOS di solito lo ha nei repo)
    "waybar"
    "rofi-wayland"
    "swayidle"
    "swaybg"
    "swaync"                # Notifiche
    "wlogout"               # Menu spegnimento
    "nwg-look"              # Temi GTK
    "polkit-gnome"          # Auth Agent
    "network-manager-applet"
    "thunar"
    "alacritty"
    "grim" "slurp" "wl-clipboard" # Screenshot & Clipboard
    "ttf-jetbrains-mono-nerd" "ttf-font-awesome" # Font
    "papirus-icon-theme"

    # --- Produttività CLI ---
    "neovim"
    "tmux"
    "fzf"
    "ripgrep"
    "eza"                   # ls moderno
    "bat"                   # cat moderno
    "zoxide"                # cd intelligente
    "fd"
    "git"
    "stow"
    "zsh"
    "starship"

    # --- Docker & Container ---
    "docker"
    "docker-compose"
    "lazydocker"            # TUI per Docker
)

# Installazione pacchetti pacman
if sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"; then
    echo -e "${GREEN}Pacchetti base installati correttamente.${NC}"
else
    echo -e "${RED}Errore durante l'installazione dei pacchetti base.${NC}"
    exit 1
fi

# Installazione Swaylock-effects (spesso in AUR o repo cachyos-extra)
echo -e "${BLUE}Installazione swaylock-effects-git...${NC}"
if pacman -Qi swaylock-effects-git &> /dev/null; then
    echo "swaylock-effects-git è già installato."
else
    # Prova con paru (gestore AUR di default su CachyOS)
    if command -v paru &> /dev/null; then
        paru -S --needed --noconfirm swaylock-effects-git
    else
        # Fallback su yay se paru non c'è, o installazione manuale necessaria
        echo -e "${RED}Paru non trovato. Assicurati di installare 'swaylock-effects-git' manualmente.${NC}"
    fi
fi

# --- 2. Configurazione Docker ---

echo -e "${GREEN}[2/7] Configurazione Docker...${NC}"
sudo systemctl enable --now docker.service
# Aggiunge l'utente corrente al gruppo docker per usarlo senza sudo
sudo usermod -aG docker "$USER"
echo "Utente $USER aggiunto al gruppo docker."

# --- 3. Backup e Creazione Cartelle Dotfiles ---

echo -e "${GREEN}[3/7] Preparazione cartelle Dotfiles...${NC}"

# Backup di sicurezza
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
echo "Backup delle configurazioni esistenti in: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Lista config da backuppare
for conf in sway waybar nvim tmux alacritty swaylock rofi; do
    if [ -d "$HOME/.config/$conf" ] || [ -f "$HOME/.config/$conf" ]; then
        mv "$HOME/.config/$conf" "$BACKUP_DIR/" 2>/dev/null
    fi
done
# Backup zshrc
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$BACKUP_DIR/"

# Creazione struttura Stow
DOTFILES_DIR="$HOME/dotfiles"
mkdir -p "$DOTFILES_DIR"/{sway/.config/sway,waybar/.config/waybar,nvim/.config/nvim,tmux,alacritty/.config/alacritty,swaylock/.config/swaylock,zsh}

# --- 4. Scrittura File di Configurazione ---

echo -e "${GREEN}[4/7] Generazione file di configurazione...${NC}"

# A. SWAY CONFIG
cat << 'EOF' > "$DOTFILES_DIR/sway/.config/sway/config"
# --- SWAY CONFIG - CACHYOS EDITION ---
set $mod Mod4
set $term alacritty
set $menu rofi -show drun
set $lock_script ~/.config/sway/lock.sh

output * bg #1e1e2e solid_color
output eDP-1 scale 1

# Bordi e Gaps
default_border pixel 2
gaps inner 5
gaps outer 5

# Colori (Catppuccin Mocha)
client.focused          #89b4fa #1e1e2e #cdd6f4 #89b4fa   #89b4fa
client.focused_inactive #6c7086 #1e1e2e #cdd6f4 #6c7086   #6c7086
client.unfocused        #6c7086 #1e1e2e #cdd6f4 #6c7086   #6c7086
client.urgent           #f38ba8 #1e1e2e #f38ba8 #f38ba8   #f38ba8

# Input
input type:touchpad {
    dwt enabled
    tap enabled
    natural_scroll enabled
    middle_emulation enabled
}
input type:keyboard {
    xkb_layout it
    xkb_options caps:escape
}

# Avvio
exec_always waybar
exec swaync
exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec nm-applet --indicator
exec spice-vdagent
exec swayidle -w \
    timeout 300 $lock_script \
    timeout 600 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' \
    before-sleep $lock_script

# Keybindings
bindsym $mod+Return exec $term
bindsym $mod+d exec $menu
bindsym $mod+n exec swaync-client -t -sw
bindsym Print exec grim ~/Immagini/Screenshot_$(date +'%Y-%m-%d_%H%M%S.png')
bindsym $mod+Print exec grim -g "$(slurp)" - | wl-copy
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec wlogout
bindsym $mod+q kill

# Workspace navigation
bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+5 workspace number 5
bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5

# Vim Motion
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

bindsym $mod+b splith
bindsym $mod+v splitv
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split
bindsym $mod+f fullscreen
bindsym $mod+r mode "resize"

mode "resize" {
    bindsym h resize shrink width 10px
    bindsym j resize grow height 10px
    bindsym k resize shrink height 10px
    bindsym l resize grow width 10px
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

# SwayFX Settings
corner_radius 10
shadows enable
shadow_blur_radius 20
default_dim_inactive 0.1
blur enable
blur_passes 2
blur_radius 5
layer_effects "waybar" blur enable; shadows enable
layer_effects "rofi" blur enable
EOF

# B. SWAY LOCK SCRIPT
cat << 'EOF' > "$DOTFILES_DIR/sway/.config/sway/lockfd
