#!/bin/bash

# Activar la salida al fallar cualquier comando
set -e

# COLORS
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[97m"
ENDCOLOR="\e[0m"

# Rutas

GITHUB_DIR=~/github
CONFIG_DIR=~/.config
WALLPAPER_DIR=~/Wallpaper
ROFI_THEME_DIR=~/.config/rofi/themes
MAIN_DIR=$(pwd)

# Obtener el sistema operativo
OS_NAME=$(grep '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')

# Obtener el Package manager
if grep -q "Ubuntu" /etc/os-release || grep -q "Debian" /etc/os-release || grep -q "Parrot" /etc/os-release; then
    PAKAGE_MANAGER="apt-get"
elif grep -q "Fedora" /etc/os-release; then
    PAKAGE_MANAGER="dnf"
elif grep -q "CentOS" /etc/os-release || grep -q "Red Hat" /etc/os-release; then
    PAKAGE_MANAGER="yum"
elif grep -q "Arch" /etc/os-release; then
    PAKAGE_MANAGER="pacman"
elif grep -q "openSUSE" /etc/os-release; then
    PAKAGE_MANAGER="zypper"
elif grep -q "Alpine" /etc/os-release; then
    PAKAGE_MANAGER="apk"
else
    PAKAGE_MANAGER="unknown"
fi

# Funcion comprobar la compatibilidad
if [ "$PAKAGE_MANAGER" != "apt-get" ]; then
    echo -e "${RED}[!] El sistema operativo no es compatible${ENDCOLOR}"
    exit 2
fi

# Funcion actualizar el sistema
update_system() {
    if [[ "$OS_NAME" == *"Parrot"* && "$PAKAGE_MANAGER" == "apt-get" ]]; then
        echo -e "${BLUE}[ ] Actualizando el sitema Parrot...${ENDCOLOR}"
        sudo apt update && sudo parrot-upgrade -y && sudo apt autoremove
    else
        echo -e "${BLUE}[ ] Actualizando el sitema...${ENDCOLOR}"
        sudo apt update && sudo apt upgrade -y && sudo apt autoremove
    fi
    sleep 3
}

# Función para verificar si un comando está instalado
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo -e "${RED}[!] El comando '$1' no está instalado. Instalando...${ENDCOLOR}"
        sudo $PAKAGE_MANAGER install -yqq "$1" || exit 1
    }
}

# Lista de paquetes comunes
PAKAGE_COMMON=" rofi zsh zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete npm flameshot ranger imagemagick feh locate libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev build-essential git cmake cmake-data pkg-config python3-packaging libcairo2-dev libxcb1-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev g++ clang python3 libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpcre3 libpcre3-dev libpixman-1-dev libx11-xcb-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-present-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev libjs-sphinxdoc=5.3.0-4 python3-sphinx"

# Funcion instalar paquetes necesarios
install_package() {
    echo -e "${BLUE}[ ] Instalando ${MAGENTA}$1...${ENDCOLOR}"
    if sudo $PAKAGE_MANAGER install -yqq --allow-downgrades "$1"; then
        echo -e "${GREEN}[+] Se ha instalado $1${ENDCOLOR}"
    else
        echo -e "${RED}[!] Fallo al instalar $1.${ENDCOLOR}" && exit 1
    fi
}

install_packages() {

    #Actualiazar paquetes
    echo -e "${BLUE}[ ] Actualizando la lista de paquetes...${ENDCOLOR}"
    if [ "$PAKAGE_MANAGER" == "apt-get" ]; then
        sudo $PAKAGE_MANAGER update -qq
        echo -e "${GREEN}Listo.${ENDCOLOR}"
    fi
    sleep 3

    # Comando para instalar los paquetes necesarios
    echo -e "${BLUE}Buscando Paquetes necesarios...${ENDCOLOR}"
    for package in $PAKAGE_COMMON; do
        if ! dpkg -l | grep -q " $package "; then
            install_package "$package"
        else
            echo -e "${RED}[!] $package ya está instalado.${ENDCOLOR}"
        fi
    done
}

# Función para descargar los repositorios
download_repositories() {
    mkdir -p $GITHUB_DIR
    cd $GITHUB_DIR
    echo -en "${BLUE}Descargando Repositorios... ${ENDCOLOR}"
    sleep 1.5
    git clone -q https://github.com/baskerville/bspwm.git
    git clone -q https://github.com/baskerville/sxhkd.git
    git clone -q --recursive https://github.com/polybar/polybar
    git clone -q https://github.com/ibhagwan/picom.git
    git clone -q https://github.com/Yucklys/polybar-nord-theme.git
    echo -e "${GREEN}Repositorios descargados.${ENDCOLOR}"
}

# Función para instalar Kitty, Bat, LSD y fzf
install_custom_bins() {
    # Obtener la última versión de bat
    bat_last=$(curl -s -L https://github.com/sharkdp/bat/releases/latest/ | grep "<title>Release v" | awk '{ print $2 }' | sed 's/v//')
    wget -q https://github.com/sharkdp/bat/releases/latest/download/bat_$bat_last\_amd64.deb
    sudo dpkg -i bat_$bat_last\_amd64.deb

    # Obtener la última versión de lsd
    lsd_last=$(curl -s -L https://github.com/lsd-rs/lsd/releases/latest/ | grep "<title>Release v" | awk '{ print $2 }' | sed 's/v//')
    wget -q https://github.com/lsd-rs/lsd/releases/latest/download/lsd_$lsd_last\_amd64.deb
    sudo dpkg -i lsd_$lsd_last\_amd64.deb

    # Obtener la última versión de kitty
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    # Install fzf
    git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all &>/dev/null
    sudo git clone -q --depth 1 https://github.com/junegunn/fzf.git /root/.fzf
    sudo /root/.fzf/install --all &>/dev/null

    echo -e "${GREEN}Kitty, Bat, LSD y fzf instalados.${ENDCOLOR}"
}

# Función para configurar Rofi
configure_rofi() {
    echo -en "${BLUE}Configurando Rofi...${ENDCOLOR}"
    sleep 1.5
    mkdir -p $ROFI_THEME_DIR
    cp $MAIN_DIR/rofi/themes/forest.rasi $ROFI_THEME_DIR/
    rofi-theme-selector &>/dev/null
    echo -e "${GREEN}Rofi configurado.${ENDCOLOR}"
}

# Función para instalar BSPWM, SXHKD, Polybar y Picom
install_window_manager() {
    # Install bspwm
    echo -en "${BLUE}Instalando bspwm...${ENDCOLOR}"
    sleep 1.5
    cd $GITHUB_DIR/bspwm
    make -s -j$(nproc)
    sudo make install
    #sudo apt-get install bspwm -yqq
    echo -e "${GREEN}Listo.${ENDCOLOR}"

    install_software "sxhkd"
    # Install sxhkd
    echo -en "${BLUE}Instalando sxhkd...${ENDCOLOR}"
    sleep 1.5
    cd $GITHUB_DIR/sxhkd
    make -s -j$(nproc)
    sudo make install
    echo -e "${GREEN}Listo.${ENDCOLOR}"

    # Install polybar
    echo -en "${BLUE}Instalando polybar...${ENDCOLOR}"
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    # Optional. This will install the polybar executable in /usr/bin
    sudo make install
    echo -e "${GREEN}Listo.${ENDCOLOR}"

    # Install picom
    echo -en "${BLUE}Instalando picom...${ENDCOLOR}"
    sleep 1.5
    cd $GITHUB_DIR/picom
    meson setup --buildtype=release build
    ninja -C build
    ninja -C build install
    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

install_fonts() {
    echo -en "${BLUE}Instalando las fuentes...${ENDCOLOR}"
    sleep 1.5
    sudo cp -v $MAIN_DIR/fonts/HNF/* /usr/local/share/fonts/ &>/dev/null
    sudo cp -v $MAIN_DIR/Config/polybar/fonts/* /usr/share/fonts/truetype/ &>/dev/null
    echo -e "${GREEN}Fuentes instaladas.${ENDCOLOR}"
}

# Función para copiar configuraciones
copy_config_files() {
    echo -en "${BLUE}Copiando archivos de configuración...${ENDCOLOR}"
    sleep 1.5
    cp -rv $MAIN_DIR/Config/* $CONFIG_DIR/ &>/dev/null
    sudo cp -rv $MAIN_DIR/Config/kitty $CONFIG_DIR/ &>/dev/null
    sudo cp -rv $MAIN_DIR/Config/kitty /root/.config/ &>/dev/null
    rm -rf ~/.zshrc
    cp -v $MAIN_DIR/zshrc ~/.zshrc
    cp -v $MAIN_DIR/p10k.zsh ~/.p10k.zsh
    sudo cp -v $MAIN_DIR/root-p10k.zsh /root/.p10k.zsh
    mkdir -p ~/.config/rofi/themes
    cp $ruta/rofi/themes/forest.rasi ~/.config/rofi/themes/
    rofi-theme-selector
    cp -v $ruta/Wallpaper/* ~/Wallpaper &>/dev/null
    echo "# WALLPAPER" >>~/.config/bspwm/bspwmrc
    echo "feh --bg-fill ~/Wallpaper/death.jpg &" >>~/.config/bspwm/bspwmrc

    echo -e "${GREEN}Archivos de configuración copiados.${ENDCOLOR}"
}

# Función para instalar P10K
install_p10k() {
    echo -en "${BLUE}Instalando P10K y plugins ZSH...${ENDCOLOR}"
    sleep 1.5
    git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
    echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    sudo git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k

    sudo mkdir /usr/share/zsh-sudo
    sudo wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -O /usr/share/zsh-sudo/sudo.plugin.zsh
    echo 'source /usr/share/zsh-sudo/sudo.plugin.zsh' >>~/.zshrc
    echo -e "${GREEN}P10K y plugins ZSH instalados.${ENDCOLOR}"
}

# Instalando ZSH plugins
install_zsh_plugins() {
    echo -en "${BLUE}Instalando plugins ZSH...${ENDCOLOR}"
    sudo mkdir /usr/share/zsh-sudo
    cd /usr/share/zsh-sudo
    sudo wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
    sudo mkdir /usr/share/zsh-autocomplete
    cd /usr/share
    sudo git clone -q --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

#Cambiar a Zsh y asignar permisos
permissions_shell() {
    echo -e "${BLUE}Cambiando terminal a ZSH${ENDCOLOR}"
    chsh -s /usr/bin/zsh
    sudo usermod --shell /usr/bin/zsh root
    sudo ln -s -fv ~/.zshrc /root/.zshrc &>/dev/null
    echo -e "${GREEN}Listo.${ENDCOLOR}"

    chmod u+x ~/.config/bspwm/bspwmrc
    chmod +x ~/.config/bin/ethernet_status.sh
    chmod +x ~/.config/bin/htb_status.sh
    chmod +x ~/.config/bin/htb_target.sh
    chmod +x ~/.config/polybar/launch.sh
    chmod +x ~/.config/polybar/scripts/*.sh
}

# Instalar Nvim + Nvchad
install_nvim() {
    echo -en "${BLUE}Instalando Nvchad...${ENDCOLOR}"
    sudo apt remove neovim -y 2>/dev/null >/dev/null
    sudo rm -rf ~/.config/nvim
    sudo rm -rf ~/.local/share/nvim
    cd /opt/
    sudo wget -q -P /opt/ https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo tar xzvf nvim-linux64.tar.gz &>/dev/null
    sudo rm -f nvim-linux64.tar.gz
    git clone -q https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    sudo cp -r ~/.config/nvim /root/.config &>/dev/null
    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

# Eliminando restos
clean() {
    echo -en "${BLUE}Limpiando restos...    ${ENDCOLOR}"
    rm -rf $GITHUB_DIR
    rm -rf $MAIN_DIR
    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

# Restart
restart() {
    notify-send -e "BSPWM Instalado
    Hay que reiniciar y cambiar el entorno a bspwm"

    while true; do
        echo -en "${PURPLE}[?] Es necesario reiniciar el sistema. ¿Deseas reiniciar ahora?${ENDCOLOR}"
        read -r
        REPLY=${REPLY:-"y"}
        if [[ $REPLY =~ ^[YySs]$ ]]; then
            echo -e "${GREEN}[+] Reiniciando el sistema...${ENDCOLOR}"
            sleep -1
            sudo reboot
        elif [[ $REPLY =~ ^[Nn]$ ]]; then
            exit 0
        else
            echo -e "${RED}[!] Respuesta invalida, responda otra vez.${ENDCOLOR}"
        fi
    done
}

# Función principal
main() {
    update_system
    check_command wget
    check_command curl
    check_command git
    install_packages
    download_repositories
    install_custom_bins
    configure_rofi
    install_window_manager
    install_fonts
    copy_config_files
    install_p10k
    install_zsh_plugins
    permissions_shell
    install_nvim
    clean
    restart
    echo -e "${GREEN}Instalación completada exitosamente.${ENDCOLOR}"
}

main "$@"
