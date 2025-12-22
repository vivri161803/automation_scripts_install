#!/bin/bash
set -e

echo "--------------------------------------"
echo "🔤 [5/5] Installazione Nerd Fonts (Fix Cache)"
echo "--------------------------------------"

# Variabili
FONT_NAME="JetBrainsMono"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.tar.xz"
# Nota: I NerdFonts recenti usano spesso tar.xz invece di zip, ma controlliamo l'estensione.
# Se preferisci lo zip (più comune per compatibilità):
FONT_URL_ZIP="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"

FONT_DIR="$HOME/.local/share/fonts"
TEMP_DIR=$(mktemp -d)

# 1. Preparazione
echo "   📂 Creazione cartella font: $FONT_DIR"
mkdir -p "$FONT_DIR"

# 2. Scaricamento
echo "   ⬇️  Scaricamento $FONT_NAME..."
# Scarichiamo lo zip che è più sicuro da gestire
curl -L --fail -o "$TEMP_DIR/font.zip" "$FONT_URL_ZIP"

# 3. Estrazione e Installazione "Intelligente"
echo "   📦 Estrazione..."
unzip -q "$TEMP_DIR/font.zip" -d "$TEMP_DIR"

# Cerca TUTTI i file ttf/otf ricorsivamente e spostali nella font dir
# Questo risolve il problema se lo zip ha sottocartelle
echo "   🚚 Spostamento file..."
find "$TEMP_DIR" -name "*.[ot]tf" -exec mv {} "$FONT_DIR/" \;

# 4. Rigenerazione Cache (Il passaggio CRUCIALE)
echo "   🔄 Rigenerazione Cache Font (fc-cache)..."
fc-cache -f -v >/dev/null

# 5. Pulizia
rm -rf "$TEMP_DIR"

# 6. Verifica
echo "   ✅ Verifica installazione:"
if fc-list | grep -q "$FONT_NAME"; then
  echo "      SUCCESS: Il sistema vede correttamente $FONT_NAME"
else
  echo "      WARNING: Il font è installato ma fc-list non lo trova ancora."
  echo "      Prova a riavviare la sessione o lanciare 'fc-cache -fv' manualmente."
fi
