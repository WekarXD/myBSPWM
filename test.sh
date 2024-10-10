#!/bin/bash

# COLORS
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[97m"
ENDCOLOR="\e[0m"

PAKAGE_COMMON="libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev cmake polybar bspwm rofi zsh imagemagick feh locate"

PAKAGE_MANAGER="apt-get"
GITHUB_DIR=~/github
MAIN_DIR=~/myBSPWM
CONFIG_DIR=~/.config

install_package() {
    echo -e "${BLUE}[ ] Instalando ${MAGENTA}$1...${ENDCOLOR}"
    if sudo $PAKAGE_MANAGER install -y -qq "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}[+] Se ha instalado $1${ENDCOLOR}"
    else
        echo -e "${RED}[!] Fallo al instalar $1.${ENDCOLOR}" && exit 1
    fi
}

install_dependencies() {

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

download_repositories() {

    mkdir -p $GITHUB_DIR
    cd $GITHUB_DIR
    echo -e "${BLUE}Descargando Repositorios...${ENDCOLOR}"
    sleep 1.5
    git clone -q https://github.com/baskerville/bspwm.git
    git clone -q https://github.com/baskerville/sxhkd.git
    git clone -q https://github.com/yshui/picom.git
    git clone -q https://github.com/Yucklys/polybar-nord-theme.git
    git clone -q https://github.com/lr-tech/rofi-themes-collection.git
    echo -e "${GREEN}Repositorios descargados.${ENDCOLOR}"
}

install_bspwm+sxhkd() {
    echo -e "${BLUE}Instalando bspwm y sxhkd...${ENDCOLOR}"
    sleep 1.5
    cd $GITHUB_DIR/bspwm && make && sudo make install
    cd $GITHUB_DIR/sxhkd && make && sudo make install
    mkdir ~/.config/{bspwm,sxhkd}
    cp $MAIN_DIR/Config/bspwm/bspwmrc ~/.config/bspwm/bspwmrc
    cp $MAIN_DIR/Config/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
    chmod u+x ~/.config/bspwm/bspwmrc
    mkdir ~/.config/bspwm/scripts
    cp $MAIN_DIR/Config/bspwm/scripts/* ~/.config/bspwm/scripts/
    chmod +x ~/.config/bspwm/scripts/*.sh
    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

install_picom() {
    echo -e "${BLUE}instalando picom...${ENDCOLOR}"
    sleep 1.5
    cd $GITHUB_DIR/picom && meson setup --buildtype=release build && ninja -C build && ninja -c build install
    mkdir $CONFIG_DIR/picom
    cp $MAIN_DIR/Config/picom/* $CONFIG_DIR/picom
    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

install_fonts() {
    echo -e "${BLUE}Instalalndo las fuentes...${ENDCOLOR}"
    sleep 1.5
    sudo mkdir /usr/local/share/fonts/HNF && sudo cp $MAIN_DIR/fonts/HNF/* /usr/local/share/fonts/
    sudo mkdir /usr/share/fonts/truetype/Polybar && sudo cp $MAIN_DIR/fonts/Polybar/* /usr/share/fonts/truetype/Polybar
    fc-cache -v
}

install_kitty() {
    echo -e "${BLUE}Instalando kitty...${ENDCOLOR}"
    sleep 1.5
    sudo mkdir /opt/kitty && cd /opt/kitty
    kitty_last=$(curl -s -L https://github.com/kovidgoyal/kitty/releases/latest/ | grep "<title>Release v" | awk '{ print $3 }')
    sudo wget -q https://github.com/kovidgoyal/kitty/releases/download/v$kitty_last/kitty-$kitty_last-x86_64.txz
    sudo 7z x kitty-$kitty_last-x86_64.txz && sudo rm -f $kitty_last-x86_64.txz
    sudo tar -xf kitty-$kitty_last-x86_64.tar && sudo rm -f kitty-$kitty_last-x86_64.tar

    mkdir -p $CONFIG_DIR/kitty
    sudo mkdir -p /root/.config/kitty
    cp $MAIN_DIR/Config/kitty/kitty.conf $CONFIG_DIR/kitty/kitty.conf
    cp $MAIN_DIR/Config/kitty/color.ini $CONFIG_DIR/kitty/color.ini

    sudo cp $MAIN_DIR/Config/kitty/kitty.conf /root/.config/kitty/kitty.conf
    sudo cp $MAIN_DIR/Config/kitty/color.ini /root/.config/kitty/color.ini

    sudo ln -s -f $CONFIG_DIR/kitty/kitty.conf /root/.config/kitty/kitty.conf
    sudo ln -s -f $CONFIG_DIR/kitty/color.ini /root/.config/kitty/color.ini

    echo -e "${GREEN}LISTO.${ENDCOLOR}"
}

install_p10k() {
    echo -e "${BLUE}Instalando P10k...${ENDCOLOR}"
    sleep 1.5
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k

    cp -rf $MAIN_DIR/Config/p10k/.p10k.zsh ~/.p10k.zsh
    sudo cp -rf $MAIN_DIR/Config/p10k/.root-p10k.zsh /root/.p10k.zsh

    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

configure_zsh() {
    echo -e "${BLUE}Configurando ZSH...${ENDCOLOR}"
    sleep 1.5
    cp -v $MAIN_DIR/Config/zsh/.zshrc ~/.zshrc && sudo cp -v $MAIN_DIR/Config/zsh/.zshrc /root/.zshrc
    sudo ln -s -f ~/.zshrc /root/.zshrc

    sudo chown root:root /usr/local/share/zsh/site-functions/_bspc

    sudo mkdir /usr/share/zsh-sudo
    sudo wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -O /usr/share/zsh-sudo/sudo.plugin.zsh
    sudo usermod --shell /usr/bin/zsh root
    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

install_custom_bins() {
    echo -e "${BLUE}Instalando binarios...${ENDCOLOR}"
    sleep 1.5
    cd $MAIN_DIR

    # Obtener la última versión de bat
    bat_last=$(curl -s -L https://github.com/sharkdp/bat/releases/latest/ | grep "<title>Release v" | awk '{ print $2 }' | sed 's/v//')
    wget https://github.com/sharkdp/bat/releases/latest/download/bat_$bat_last\_amd64.deb
    sudo dpkg -i bat_$bat_last\_amd64.deb

    # Obtener la última versión de lsd
    lsd_last=$(curl -s -L https://github.com/lsd-rs/lsd/releases/latest/ | grep "<title>Release v" | awk '{ print $2 }' | sed 's/v//')
    wget -q https://github.com/lsd-rs/lsd/releases/latest/download/lsd_$lsd_last\_amd64.deb
    sudo dpkg -i lsd_$lsd_last\_amd64.deb

    # Install fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    sudo git clone -q --depth 1 https://github.com/junegunn/fzf.git /root/.fzf
    sudo /root/.fzf/install --all

    echo -e "${GREEN}Listo.${ENDCOLOR}"
}

copy_config_files() {
    echo -e "${BLUE}Copiando archivos de configuración...${ENDCOLOR}"
    sleep 1.5

    #Polybar
    cp -r -f $MAIN_DIR/Config/polybar/* $CONFIG_DIR/polybar/
    chmod +x $CONFIG_DIR/polybar/launch.sh

    # Wallpaper
    mkdir ~/Wallpapers
    cp $MAIN_DIR/Wallpapers/* ~/Wallpapers
    echo -e "\n" >>~/.config/bspwm/bspwmrc
    echo "# WALLPAPER" >>~/.config/bspwm/bspwmrc
    echo "feh --bg-fill ~/Wallpapers/death.jpg &" >>~/.config/bspwm/bspwmrc

    echo -e "${GREEN}Archivos de configuración copiados.${ENDCOLOR}"
}

main() {
    install_dependencies
    download_repositories
    install_bspwm+sxhkd
    install_picom
    install_fonts
    install_kitty
    install_p10k
    configure_zsh
    install_custom_bins
    copy_config_files
}

main "$@"
echo -e "${MAGENTA}Instaladas dependencias con exito${ENDCOLOR}"
