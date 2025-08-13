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


# --- Criação do Arquivo .zshrc ---
log "5. Configurando o arquivo .zshrc..."

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

log "--- Configuração Concluída! ---"
echo "Passos finais importantes:"
echo "1. FAÇA LOGOUT E LOGIN na sua sessão Ubuntu para que a mudança de shell seja aplicada."
echo "2. ABRA AS CONFIGURAÇÕES DO SEU TERMINAL e mude a fonte para 'JetBrainsMono Nerd Font'."
Echo "Aproveite seu novo terminal!"
