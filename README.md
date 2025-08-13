# Script de Instalação e Configuração do Zsh para Ubuntu

Este projeto fornece um script para automatizar a configuração de um ambiente de desenvolvimento Zsh no Ubuntu. Ele instala o Oh My Zsh, o tema Spaceship, plugins essenciais e a fonte JetBrains Mono.

## O que o script faz?

- ✅ Instala `zsh`, `git`, `curl`, `wget` e `unzip`.
- ✅ Instala o [Oh My Zsh](https://ohmyz.sh/).
- ✅ Instala os plugins [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) e [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting).
- ✅ Instala o tema [Spaceship Prompt](https://spaceship-prompt.sh/).
- ✅ Baixa e configura a fonte [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) para ícones e glyphs corretos no terminal.
- ✅ Cria um arquivo `.zshrc` pré-configurado.
- ✅ Define o Zsh como o shell padrão do usuário.

---

## Como Usar

1.  **Clone ou baixe este repositório**

    Se tiver o git, clone o repositório:
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO> # Substitua pela URL quando subir para o GitHub
    cd zsh_ubuntu_setup
    ```

    Se não, apenas baixe os arquivos e coloque-os em uma pasta `zsh_ubuntu_setup`.

2.  **Torne o script executável**

    No terminal, dentro da pasta, execute o comando:
    ```bash
    chmod +x install_zsh_ubuntu.sh
    ```

3.  **Execute o script de instalação**

    ```bash
    ./install_zsh_ubuntu.sh
    ```

    O script pedirá sua senha de administrador (`sudo`) para instalar os pacotes necessários.

---

## Pós-Instalação (Passos Manuais Obrigatórios)

Após a execução do script, você precisa fazer duas coisas para finalizar a configuração:

1.  **Reinicie sua Sessão**

    **Faça logout e login novamente** no seu usuário do Ubuntu. Isso é necessário para que a mudança do shell padrão para Zsh tenha efeito.

2.  **Configure a Fonte do Terminal**

    Abra as preferências ou configurações do seu aplicativo de terminal (Ex: `GNOME Terminal`, `Konsole`, `Tilix`) e mude a fonte do perfil para **`JetBrainsMono Nerd Font`**.

    ![Exemplo de configuração de fonte no terminal](https://i.imgur.com/N2sA22A.png) *(Esta imagem é apenas um exemplo)*

    Este passo é crucial para que os ícones do tema Spaceship apareçam corretamente.
