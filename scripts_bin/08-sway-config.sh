#!/bin/bash
set -e

echo "----------------------------------------------------"
echo "⚙️  HOST REAL METAL: Configurazione Master (Sway + Waybar + Wlogout)"
echo "----------------------------------------------------"

# 1. Pulizia vecchie config
# Rimuoviamo tutto per essere sicuri che non ci siano file vecchi o corrotti
rm -f "$HOME/.config/sway/config"
rm -f "$HOME/.config/waybar/config"
rm -f "$HOME/.config/waybar/style.css"
rm -f "$HOME/.config/wofi/config"
rm -f "$HOME/.config/wofi/style.css"
rm -f "$HOME/.config/mako/config"
rm -rf "$HOME/.config/wlogout" # Rimuove cartella wlogout

# Creiamo le cartelle necessarie
mkdir -p "$HOME/.config/sway"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/wofi"
mkdir -p "$HOME/.config/mako"
mkdir -p "$HOME/.config/wlogout"

# ==================== 1. SWAY CONFIG ====================
echo "   📝 Scrivendo Sway Config..."
cat <<EOF >"$HOME/.config/sway/config"
# --- VARIABILI ---
set \$mod Mod4
set \$term kitty
set \$menu wofi --show drun --allow-images --insensitive

# --- HARDWARE REALE ---
# Touchpad: tap to click e scroll naturale
input type:touchpad {
    dwt enabled
    tap enabled
    natural_scroll enabled
    middle_emulation enabled
}

# Tastiera Italiana
input type:keyboard {
    xkb_layout it
}

# --- VISUAL ---
seat seat0 xcursor_theme default 24
font pango:JetBrainsMono Nerd Font 10

# Spaziature e Bordi
gaps inner 12
gaps outer 5
default_border pixel 2
default_floating_border pixel 2
smart_borders on

# --- COLORI (Catppuccin Mocha) ---
client.focused          #cba6f7 #1e1e2e #cdd6f4 #cba6f7   #cba6f7
client.focused_inactive #6c7086 #1e1e2e #6c7086 #6c7086   #6c7086
client.unfocused        #313244 #1e1e2e #a6adc8 #313244   #313244
client.urgent           #f38ba8 #1e1e2e #f38ba8 #f38ba8   #f38ba8

# --- OUTPUT ---
output * bg $HOME/Pictures/Wallpapers/ultimate_purple.jpg fill

# --- SYSTEM INTEGRATION ---
exec --no-startup-id dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

# --- AUTOSTART ---
exec_always --no-startup-id mako
exec_always --no-startup-id waybar
exec --no-startup-id /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1

# --- TASTI ---
bindsym \$mod+Return exec \$term
bindsym \$mod+d exec \$menu
bindsym \$mod+q kill
bindsym \$mod+Shift+r reload
# Uscita rapida con wlogout anche da tastiera (Mod+Shift+E)
bindsym \$mod+Shift+e exec wlogout

# Screenshot
bindsym \$mod+Shift+s exec grim -g "\$(slurp)" - | wl-copy

# Tasti Multimediali
bindsym XF86AudioRaiseVolume exec pamixer -i 5
bindsym XF86AudioLowerVolume exec pamixer -d 5
bindsym XF86AudioMute exec pamixer -t
bindsym XF86MonBrightnessUp exec brightnessctl set +10%
bindsym XF86MonBrightnessDown exec brightnessctl set 10%-

# Navigazione
bindsym \$mod+h focus left
bindsym \$mod+j focus down
bindsym \$mod+k focus up
bindsym \$mod+l focus right
bindsym \$mod+Shift+h move left
bindsym \$mod+Shift+j move down
bindsym \$mod+Shift+k move up
bindsym \$mod+Shift+l move right

# Workspaces
bindsym \$mod+1 workspace 1
bindsym \$mod+2 workspace 2
bindsym \$mod+3 workspace 3
bindsym \$mod+4 workspace 4
bindsym \$mod+Shift+1 move container to workspace 1
bindsym \$mod+Shift+2 move container to workspace 2
bindsym \$mod+Shift+3 move container to workspace 3
bindsym \$mod+Shift+4 move container to workspace 4

# Resize Mode
mode "resize" {
    bindsym h resize shrink width 10px
    bindsym j resize grow height 10px
    bindsym k resize shrink height 10px
    bindsym l resize grow width 10px
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym \$mod+r mode "resize"
EOF

# ==================== 2. WAYBAR CONFIG ====================
echo "   📝 Scrivendo Waybar Config (con Wlogout)..."
cat <<EOF >"$HOME/.config/waybar/config"
{
    "layer": "top", "position": "top", "height": 40,
    "margin-top": 6, "margin-left": 10, "margin-right": 10, "spacing": 0,
    
    "modules-left": ["custom/launcher", "sway/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "backlight", "memory", "cpu", "battery", "tray", "custom/power"],

    "custom/launcher": { "format": "  ", "on-click": "wofi --show drun --allow-images --insensitive", "tooltip": false },
    "sway/workspaces": { "disable-scroll": true, "all-outputs": true, "format": "{name}" },
    
    "clock": { 
        "format": " {:%H:%M}", "format-alt": "📅 {:%d/%m/%Y}", 
        "tooltip-format": "<tt>{calendar}</tt>", 
        "on-click": "kitty --hold -e cal -y" 
    },

    "pulseaudio": {
        "format": "{icon} {volume}%", "format-muted": "🔇 Muto",
        "format-icons": { "default": ["", "", ""] },
        "on-click": "pavucontrol", "on-click-right": "pamixer -t",
        "scroll-step": 5
    },

    "backlight": {
        "device": "intel_backlight",
        "format": "{icon} {percent}%",
        "format-icons": ["", ""]
    },

    "battery": {
        "states": { "warning": 30, "critical": 15 },
        "format": "{icon} {capacity}%",
        "format-charging": " {capacity}%",
        "format-icons": ["", "", "", "", ""]
    },

    "memory": { "interval": 30, "format": " {}%", "on-click": "kitty -e btop" },
    "cpu": { "interval": 10, "format": " {usage}%", "on-click": "kitty -e btop" },
    "tray": { "icon-size": 18, "spacing": 10 },
    
    // QUI ABBIAMO CAMBIATO IL COMANDO IN WLOGOUT
    "custom/power": { 
        "format": "⏻", 
        "tooltip": false, 
        "on-click": "wlogout" 
    }
}
EOF

# ==================== 3. WAYBAR CSS ====================
echo "   🎨 Scrivendo Waybar CSS..."
cat <<EOF >"$HOME/.config/waybar/style.css"
* { border: none; border-radius: 0; font-family: "JetBrainsMono Nerd Font"; font-size: 14px; font-weight: bold; min-height: 0; }
window#waybar { background: transparent; color: #cdd6f4; }

#custom-launcher, #workspaces, #clock, #pulseaudio, #backlight, #memory, #cpu, #battery, #tray, #custom-power {
    background-color: #1e1e2e; color: #cdd6f4; padding: 0 15px; margin: 0 4px; border-radius: 15px; border: 2px solid #11111b; box-shadow: 2px 2px 2px 0px rgba(0,0,0,0.2);
}

#custom-launcher { color: #89b4fa; padding-right: 18px; font-size: 16px; }
#workspaces button { padding: 0 5px; background-color: transparent; color: #6c7086; border-radius: 15px; }
#workspaces button.focused { color: #cba6f7; background-color: #313244; }
#workspaces button.urgent { color: #f38ba8; }
#clock { color: #b4befe; background-color: #1e1e2e; }

#pulseaudio { color: #a6e3a1; }
#pulseaudio.muted { background-color: #f38ba8; color: #1e1e2e; }

#backlight { color: #f9e2af; }
#battery { color: #a6e3a1; }
#battery.warning { color: #fab387; }
#battery.critical { 
    color: #f38ba8; 
    animation-name: blink; 
    animation-duration: 0.5s; 
    animation-timing-function: linear; 
    animation-iteration-count: infinite; 
    animation-direction: alternate;
}

#memory { color: #f9e2af; }
#cpu { color: #fab387; }
#custom-power { background-color: #f38ba8; color: #1e1e2e; padding-left: 12px; padding-right: 14px; }

@keyframes blink { to { background-color: #ffffff; color: #000000; } }
EOF

# ==================== 4. WLOGOUT CONFIG ====================
echo "   🚪 Scrivendo config Wlogout..."
cat <<EOF >"$HOME/.config/wlogout/layout"
{
    "label" : "lock",
    "action" : "swaylock",
    "text" : "Blocca",
    "keybind" : "l"
}
{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Ibernazione",
    "keybind" : "h"
}
{
    "label" : "logout",
    "action" : "swaymsg exit",
    "text" : "Esci",
    "keybind" : "e"
}
{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Spegni",
    "keybind" : "s"
}
{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Sospendi",
    "keybind" : "u"
}
{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Riavvia",
    "keybind" : "r"
}
EOF

cat <<EOF >"$HOME/.config/wlogout/style.css"
* {
    background-image: none;
    font-family: "JetBrainsMono Nerd Font", monospace;
}
window { background-color: rgba(30, 30, 46, 0.85); }
button {
    color: #cdd6f4;
    background-color: #313244;
    border-style: solid;
    border-width: 2px;
    background-repeat: no-repeat;
    background-position: center;
    background-size: 25%;
    border-radius: 20px;
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
    margin: 10px;
    transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
}
button:hover { background-color: #45475a; color: #cba6f7; outline-style: none; }
button:focus { background-color: #cba6f7; color: #1e1e2e; }

#lock { background-image: image(url("/usr/share/wlogout/icons/lock.png")); border-color: #fab387; }
#logout { background-image: image(url("/usr/share/wlogout/icons/logout.png")); border-color: #f9e2af; }
#suspend { background-image: image(url("/usr/share/wlogout/icons/suspend.png")); border-color: #89b4fa; }
#hibernate { background-image: image(url("/usr/share/wlogout/icons/hibernate.png")); border-color: #a6e3a1; }
#shutdown { background-image: image(url("/usr/share/wlogout/icons/shutdown.png")); border-color: #f38ba8; }
#reboot { background-image: image(url("/usr/share/wlogout/icons/reboot.png")); border-color: #94e2d5; }
EOF

# ==================== 5. WOFI & MAKO ====================
echo "   🚀 Scrivendo config Wofi e Mako..."
cat <<EOF >"$HOME/.config/wofi/config"
mode=drun
show=drun
width=500
height=400
always_listen_input=true
no_actions=true
allow_images=true
image_size=24
EOF

cat <<EOF >"$HOME/.config/wofi/style.css"
* { font-family: 'JetBrainsMono Nerd Font', monospace; font-size: 14px; }
window { background-color: #1e1e2e; border: 2px solid #cba6f7; border-radius: 12px; }
#input { background-color: #313244; color: #cdd6f4; padding: 10px; margin: 10px; border-radius: 8px; border: none; }
#inner-box { margin: 10px; background-color: transparent; }
#outer-box { margin: 5px; background-color: transparent; }
#entry:selected { background-color: #cba6f7; border-radius: 8px; }
EOF

cat <<EOF >"$HOME/.config/mako/config"
font=JetBrainsMono Nerd Font 10
background-color=#1e1e2e
text-color=#cdd6f4
border-color=#cba6f7
border-size=2
border-radius=10
default-timeout=5000
EOF

echo "   ✅ Configurazione Master Completata!"
echo "      - Waybar fixato (Batteria + CSS)"
echo "      - Wlogout integrato (Icone Catppuccin)"
echo "      - Sway configurato per Hardware Reale"
echo "   👉 Riavvia Sway (Win+Shift+R) o fai Reboot."
