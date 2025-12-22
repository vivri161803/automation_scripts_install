#!/bin/bash
# scripts_bin/05-fonts.sh

echo "--------------------------------------"
echo "🔤 [5/5] Installazione Nerd Fonts"
echo "--------------------------------------"

# Definisci quale font vuoi (JetBrainsMono è il preferito per LazyVim)
FONT_NAME="JetBrainsMono"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
FONT_DIR="$HOME/.local/share/fonts"

echo "   ⬇️  Scaricamento $FONT_NAME Nerd Font..."

# Crea la cartella se non esiste
mkdir -p "$FONT_DIR"

# Scarica lo zip in una cartella temporanea
TEMP_DIR=$(mktemp -d)
curl -L --fail -o "$TEMP_DIR/font.zip" "$FONT_URL"

# Estrae solo i file .ttf/.otf nella cartella font dell'utente
unzip -o -q "$TEMP_DIR/font.zip" -d "$TEMP_DIR"
mv "$TEMP_DIR"/*.ttf "$FONT_DIR/" 2>/dev/null || true
mv "$TEMP_DIR"/*.otf "$FONT_DIR/" 2>/dev/null || true

# Pulisce
rm -rf "$TEMP_DIR"

echo "   🔄 Aggiornamento cache font..."
fc-cache -fv >/dev/null

echo "   ✅ $FONT_NAME installato correttamente!"
