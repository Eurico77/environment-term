#!/bin/bash

# Script para configurar o ambiente Zsh no Ubuntu com Oh My Zsh,
# tema Spaceship, plugins e a fonte JetBrains Mono.

# Função para imprimir mensagens
log() {
  echo -e "\n\033[1;32m$1\033[0m"
}

# --- Instalação de Pacotes Essenciais ---
log "1. Atualizando pacotes e instalando dependências (zsh, git, curl, unzip)..."
sudo apt update
sudo apt install -y zsh git curl wget unzip

# --- Instalação do Oh My Zsh ---
if [ -d "$HOME/.oh-my-zsh" ]; then
  log "Oh My Zsh já está instalado. Pulando."
else
  log "2. Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Instalação de Plugins e Tema ---
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

log "3. Instalando plugins e tema..."

# Clonar zsh-autosuggestions
if [ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
  log "Plugin zsh-autosuggestions já existe. Pulando."
else
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

# Clonar zsh-syntax-highlighting
if [ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
  log "Plugin zsh-syntax-highlighting já existe. Pulando."
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

# Clonar tema Spaceship
if [ -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
  log "Tema Spaceship já existe. Pulando."
else
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt" --depth=1
  ln -s "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"
fi


# --- Instalação da Fonte JetBrains Mono ---
log "4. Instalando a fonte JetBrains Mono..."
FONT_DIR="$HOME/.local/share/fonts"
if [ -d "$FONT_DIR/JetBrainsMono" ]; then
    log "Fonte JetBrains Mono já parece estar instalada. Pulando."
else
    mkdir -p $FONT_DIR
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
    unzip /tmp/JetBrainsMono.zip -d $FONT_DIR/JetBrainsMono
    rm /tmp/JetBrainsMono.zip
    log "Atualizando o cache de fontes..."
    fc-cache -f -v
fi


# --- Instalação do Terminal Ghostty ---
log "5. Instalando o terminal Ghostty via Snap..."
if snap list | grep -q ghostty; then
    log "Ghostty já está instalado. Pulando."
else
    sudo snap install ghostty --classic
fi

log "6. Configurando o Ghostty..."
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
mkdir -p "$GHOSTTY_CONFIG_DIR"

cat << 'EOF' > "$GHOSTTY_CONFIG_DIR/config"
theme = "tokyonight_night"
font-family = "JetBrainsMono NFM Regular"
font-size = 19
alpha-blending = native

keybind = "cmd+r=reload_config"
keybind = "cmd+up=new_split:up"
keybind = "cmd+down=new_split:down"
keybind = "cmd+left=new_split:left"
keybind = "cmd+right=new_split:right"
keybind = "cmd+shift+w=close_all_windows"
keybind = "cmd+ctrl+up=resize_split:up,10"
keybind = "cmd+ctrl+down=resize_split:down,10"
keybind = "cmd+ctrl+left=resize_split:left,10"
keybind = "cmd+ctrl+right=resize_split:right,10"

cursor-style = "bar"
mouse-hide-while-typing = true

background-opacity = 0.85
background-blur = 20
window-colorspace = "srgb"
window-decoration = "auto"

window-width = 108
window-height = 25

clipboard-read = "allow"
clipboard-write = "allow"

confirm-close-surface = false
quit-after-last-window-closed = true

quick-terminal-position = "center"
shell-integration = "zsh"

# macos-icon
# official blueprint chalkboard microchip glass holographic paper retro xray
macos-icon = "xray"
auto-update = "check"
EOF

# --- Criação do Arquivo .zshrc ---
log "7. Configurando o arquivo .zshrc..."

# Backup do .zshrc existente, se houver
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak_$(date +%Y%m%d_%H%M%S)"

cat << 'EOF' > "$HOME/.zshrc"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# --- Configuração do Tema Spaceship ---
# Para uma lista completa de opções: https://spaceship-prompt.sh/config/
ZSH_THEME="spaceship"

SPACESHIP_PROMPT_ORDER=(
  user          # Username
  dir           # Current directory
  host          # Hostname
  git           # Git section (branch + status)
  docker        # Docker section
  node          # Node.js section
  exec_time     # Execution time
  line_sep      # Line break
  exit_code     # Exit code
  char          # Prompt character
)

SPACESHIP_USER_SHOW=always
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_GIT_BRANCH_COLOR="red"

# --- Plugins ---
# Adicione plugins aqui. Cuidado, pois muitos plugins podem retardar o início do shell.
# Padrão: $ZSH/plugins/*
# Customizados: $ZSH_CUSTOM/plugins/*
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Carrega o Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# --- Aliases (Apelidos) ---
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"
alias dckimg="docker images"
alias pn=pnpm

# --- Configurações Adicionais ---
# Adicione aqui outras configurações, exports e etc.

EOF

# --- Mudar o Shell Padrão ---
if [ "$SHELL" != "/bin/zsh" ]; then
  log "6. Alterando o shell padrão para Zsh..."
  chsh -s $(which zsh)
  if [ $? -eq 0 ]; then
    log "Shell alterado com sucesso! Por favor, faça logout e login novamente para que as alterações entrem em vigor."
  else
    log "Não foi possível alterar o shell. Por favor, execute 'chsh -s $(which zsh)' manualmente."
  fi
else
  log "O shell padrão já é Zsh."
fi

# --- Instalação e Configuração do Tmux ---
log "8. Instalando o Tmux e o TPM (Tmux Plugin Manager)..."
sudo apt install -y tmux

if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  log "TPM já está instalado. Pulando."
else
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

log "9. Configurando o arquivo .tmux.conf..."

cat << 'EOF' > "$HOME/.tmux.conf"
### ---------- CONFIGURAÇÕES BÁSICAS ----------
# Prefixo trocado para Ctrl+a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Modo vi para copiar texto
setw -g mode-keys vi

# Melhor histórico de rolagem
set -g history-limit 10000

# Atualizar status bar a cada 5 segundos
set -g status-interval 5

# Melhor cores (256)
set -g default-terminal "screen-256color"

# Dividir janelas com | e -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Atalhos para mudar entre janelas
bind -n M-Left previous-window
bind -n M-Right next-window

# Atualizar config sem sair
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"


set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'christoomey/vim-tmux-navigator' # Este plugin cuidará da navegação C-h, C-j, C-k, C-l
set -g @plugin 'dracula/tmux'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @prefix_highlight_fg 'white' # default is 'colour231'
set -g @prefix_highlight_bg 'blue'  # default is 'colour04'

# Configuração do tmux-continuum para salvar/restaurar
set -g @continuum-restore 'on'

# Tema Dracula
set -g @dracula-show-powerline true
set -g @dracula-plugins "cpu-usage ram-usage date time"
set -g @dracula-refresh-rate 5

### ---------- INICIALIZA TPM ----------
run '~/.tmux/plugins/tpm/tpm'
EOF

log "--- Configuração Concluída! ---"
echo "Passos finais importantes:"
echo "1. FAÇA LOGOUT E LOGIN na sua sessão Ubuntu para que a mudança de shell seja aplicada."
echo "2. ABRA O GHOSTTY (ou seu terminal preferido) e mude a fonte para 'JetBrainsMono NFM Regular' nas configurações, se necessário."
echo "3. INICIE O TMUX e pressione 'Ctrl+a' e depois 'I' (maiúsculo) para que o TPM instale os plugins."
echo "Aproveite seu novo ambiente!"
