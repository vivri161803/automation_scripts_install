#!/bin/bash
# scripts_bin/01-system.sh
source config/packages.conf # <-- Nota il percorso relativo

echo "🛠️  [1/4] Aggiornamento Sistema e Pacchetti APT..."
sudo apt update && sudo apt upgrade -y

all_packages=("${sys_packages[@]}" "${dev_packages[@]}" "${app_packages[@]}")

for package in "${all_packages[@]}"; do
  if dpkg -l | grep -q "^ii  $package "; then
    echo "   ✅ $package già installato"
  else
    echo "   ⬇️  Installazione $package..."
    sudo apt install -y "$package"
  fi
done
