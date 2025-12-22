# 🚀 Ubuntu Auto-Setup Initiative

Uno script di automazione modulare per configurare rapidamente un ambiente di sviluppo Ubuntu fresco di installazione. Ispirato al workflow "Crucible", questo progetto automatizza l'installazione di pacchetti, Docker, l'ultima versione di Neovim e la configurazione dell'ambiente desktop GNOME.

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Ubuntu](https://img.shields.io/badge/OS-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Neovim](https://img.shields.io/badge/Editor-Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)

## 📋 Funzionalità

* **📦 Gestione Pacchetti APT**: Installazione massiva di utility di sistema e tool di sviluppo tramite liste configurabili.
* **🐳 Docker Setup**: Installazione automatica di Docker Engine dal repository ufficiale (non apt standard) e configurazione gruppo utente.
* **📝 Latest Neovim**: Scarica e installa l'ultima release stabile di Neovim direttamente da GitHub (bypassando la versione obsoleta di apt).
* **🎨 GNOME Customization**: Installa estensioni GNOME specifiche e ripristina le configurazioni del desktop (temi, shortcut, dock) tramite `dconf`.
* **🛡️ Modulare**: Ogni componente (System, Nvim, Gnome, Docker) è isolato nel proprio script.

## 📂 Struttura del Progetto

```text
my-setup/
├── setup.sh                 # 🚀 IL MASTER SWITCH (Esegui questo)
├── config/                  # ⚙️ File di configurazione modificabili
│   ├── packages.conf        # Array dei pacchetti APT (System, Dev, App)
│   ├── extensions.list      # Lista degli UUID delle estensioni GNOME
│   └── gnome.conf           # (Opzionale) Dump delle impostazioni dconf
└── scripts_bin/             # 🧠 Logica di automazione (Non toccare)
    ├── 01-system.sh         # Updates & APT install
    ├── 02-nvim.sh           # Neovim binary install
    ├── 03-gnome.sh          # Extensions & Settings restore
    └── 04-docker.sh         # Docker official repo setup

```

## 🛠️ Prerequisiti

* Una installazione fresca di **Ubuntu** (22.04 LTS o 24.04 LTS raccomandate).
* Connessione internet attiva.
* Diritti di `sudo`.
* `git` installato (per clonare questa repo).

## 🚀 Utilizzo

1. **Clona la repository** nella tua home:
```bash
git clone [https://github.com/TUO-USER/TUO-REPO.git](https://github.com/TUO-USER/TUO-REPO.git) my-setup
cd my-setup

```


2. **Rendi eseguibile lo script principale**:
```bash
chmod +x setup.sh

```


3. **Avvia l'automazione**:
```bash
./setup.sh

```


*Ti verrà chiesta la password di sudo una sola volta all'inizio.*
4. **Riavvia il sistema**:
Al termine, riavvia il computer per applicare le modifiche al gruppo Docker e alle estensioni GNOME.

---
