#!/bin/bash
set -e

echo "--------------------------------------"
echo "🚀 [7/7] Installazione Starship Prompt"
echo "--------------------------------------"

# 1. Installazione del Binario
if ! command -v starship &>/dev/null; then
  echo "   ⬇️  Scaricamento e installazione..."
  # Usa lo script ufficiale. sh -s -- -y serve per confermare automaticamente (yes)
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "   ✅ Starship è già installato."
fi

# 2. Hook in .bashrc (Attivazione)
# Controlla se abbiamo già inserito la riga di attivazione per evitare duplicati
if ! grep -q "starship init bash" "$HOME/.bashrc"; then
  echo "   📝 Aggiunta hook in .bashrc..."
  echo "" >>"$HOME/.bashrc"
  echo "# Inizializzazione Starship" >>"$HOME/.bashrc"
  echo 'eval "$(starship init bash)"' >>"$HOME/.bashrc"
else
  echo "   ✅ Hook già presente in .bashrc."
fi

echo "   ✅ Starship pronto! (Si attiverà al prossimo riavvio del terminale)"
