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

SILENT="2>/dev/null >/dev/null"

# Funcion instalar paquetes necesarios
install_packages() {

    local PAKAGE_MANAGER

    PAKAGE_MANAGER="apt-get"

    #Actualiazar paquetes
    if [ "$PAKAGE_MANAGER" == "apt-get" ]; then
        sudo $PAKAGE_MANAGER update
    fi

    sleep 3

    # Comando para instalar los paquetes necesarios

    echo -e "${BLUE}Buscando Paquetes necesarios...${ENDCOLOR}"

    PAKAGE_COMMON=" rofi zsh zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete npm flameshot ranger imagemagick feh locate libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev build-essential git cmake cmake-data pkg-config python3-packaging libcairo2-dev libxcb1-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev g++ clang python3 libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpcre3 libpcre3-dev libpixman-1-dev libx11-xcb-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-present-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev libjs-sphinxdoc=5.3.0-4 python3-sphinx"

    for package in $PAKAGE_COMMON; do
        if [ "$PAKAGE_MANAGER" == "apt-get" ] && ! dpkg -l | grep -q " $package "; then
            echo -e "${BLUE}[ ] Instalando ${MAGENTA}$package...${ENDCOLOR}"
            sudo $PAKAGE_MANAGER install -yqq --allow-downgrades $package 2>/dev/null >/dev/null
            echo -e "${GEERN}[+] Se ha instalado $package${ENDCOLOR}"
            sleep 1
        else
            echo -e "${RED}[!] $package ya está instalado.${ENDCOLOR}"
        fi
    done
}

ruta=$(pwd)

# Verificar e instalar paquetes
install_packages

mkdir ~/github
cd ~/github
echo -en "${BLUE}Descargando Repositorios... ${ENDCOLOR}"
sleep 1.5
git clone -q https://github.com/baskerville/bspwm.git
git clone -q https://github.com/baskerville/sxhkd.git
git clone -q --recursive https://github.com/polybar/polybar
git clone -q https://github.com/ibhagwan/picom.git
git clone -q https://github.com/Yucklys/polybar-nord-theme.git
# Optener la ultima version de bat
bat_last=$(curl -s -L https://github.com/sharkdp/bat/releases/latest/ | grep "<title>Release v" | awk '{ print $2 }' | sed 's/v//')
wget -q https://github.com/sharkdp/bat/releases/latest/download/bat_$bat_last\_amd64.deb
bat_bin=$(ls | grep "bat")
# Optener la ultima version de lsd
lsd_last=$(curl -s -L https://github.com/lsd-rs/lsd/releases/latest/ | grep "<title>Release v" | awk '{ print $2 }' | sed 's/v//')
wget -q https://github.com/lsd-rs/lsd/releases/latest/download/lsd_$lsd_last\_amd64.deb
lsd_bin=$(ls | grep "lsd")
# Optener la ultima version de kitty
kitty_last=$(curl -s -L https://github.com/kovidgoyal/kitty/releases/latest/ | grep "<title>Release version " | awk '{ print $3 }')
wget -q https://github.com/kovidgoyal/kitty/releases/latest/download/kitty-$kitty_last-x86_64.txz
kitty_bin=$(ls | grep "kitty")
echo -e "${GREEN}Listo.${ENDCOLOR}"
sleep 1.5

#instalando bspwm
echo -en "${BLUE}Instalando bspwm...${ENDCOLOR}"
sleep 1.5
cd ~/github/bspwm
make -s -j$(nproc)
sudo make install -s
sudo apt-get install bspwm -yqq 2>/dev/null >/dev/null
echo -e "${GREEN}Listo.${ENDCOLOR}"

# instalando sxhkd
echo -en "${BLUE}Instalando sxhkd...${ENDCOLOR}"
sleep 1.5
cd ~/github/sxhkd
make -s -j$(nproc)
sudo make install -s
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Instalando Polybar
echo -en "${BLUE}Instalando polybar...${ENDCOLOR}"
sleep 1.5
cd ~/github/polybar
mkdir build 
cd build
cmake --quiet ..
make -s -j$(nproc)
sudo make install -s
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Instalando Picom
echo -en "${BLUE}Instalando picom...${ENDCOLOR}"
sleep 1.5
cd ~/github/picom
git submodule update --init --recursive --quiet
meson --quiet --buildtype=release . build 
ninja -C build --quiet
sudo ninja -C build install --quiet
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Instalando la kitty
echo -en "${BLUE}Instalando kitty...${ENDCOLOR}"
sleep 1.5
cd ~/github
sudo mkdir /opt/kitty 
sudo mv $kitty_bin /opt/kitty
cd /opt/kitty/
sudo 7z x $kitty_bin &>/dev/null
sudo rm $kitty_bin
kitty_bin=$(ls | grep "kitty")
sudo tar -xf $kitty_bin 
sudo rm $kitty_bin
echo -e "${GREEN}Listo.${ENDCOLOR}"

#Instalando bat
echo -en "${BLUE}Instalando Batcat...${ENDCOLOR}"
cd ~/github
sudo dpkg -i $bat_bin &>/dev/null
echo -e "${GREEN}Listo.${ENDCOLOR}"

#Instalando lsd
echo -en "${BLUE}Instalando LSD...${ENDCOLOR}"
cd ~/github
sudo dpkg -i $lsd_bin &>/dev/null
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Instalando p10k
echo -en "${BLUE}Instalando P10K...    ${ENDCOLOR}"
sleep 1.5
git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
# Instalando p10k root
sudo git clone -q  --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Instalando las HackNerdFonts
echo -en "${BLUE}Instalando las Fuentes...    ${ENDCOLOR}"
sleep 1.5
sudo cp -v $ruta/fonts/HNF/* /usr/local/share/fonts/ &>/dev/null
# Instalando las fuentes en Polybar
sudo cp -v $ruta/Config/polybar/fonts/* /usr/share/fonts/truetype/ &>/dev/null
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Copiando Archivos de Configuración
echo -en "${BLUE}Copiando archivos de configuracion...    ${ENDCOLOR}"
sleep 1.5
cp -rv $ruta/Config/* ~/.config/ &>/dev/null
sudo cp -rv $ruta/Config/kitty ~/.config/ &>/dev/null
# Kitty Root
sudo cp -rv $ruta/Config/kitty /root/.config/ &>/dev/null
# Copia de configuracion de .p10k.zsh y .zshrc
rm -rf ~/.zshrc
cp -v $ruta/zshrc ~/.zshrc &>/dev/null
cp -v $ruta/p10k.zsh ~/.p10k.zsh &>/dev/null
sudo cp -v $ruta/p10k.zsh-root /root/.p10k.zsh &>/dev/null
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Plugins ZSH
echo -en "${BLUE}Instalando plugins ZSH...    ${ENDCOLOR}"
sudo mkdir /usr/share/zsh-sudo
cd /usr/share/zsh-sudo
sudo -q  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh 
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Cambiando de SHELL a ZSH
echo -en "${BLUE}Cambiando terminal a ZSH${ENDCOLOR}"
chsh -s /usr/bin/zsh
sudo usermod --shell /usr/bin/zsh root
sudo ln -s -fv ~/.zshrc /root/.zshrc &>/dev/null
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Asignando permisos
chmod u+x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bin/ethernet_status.sh
chmod +x ~/.config/bin/htb_status.sh
chmod +x ~/.config/bin/htb_target.sh

# Instalando Nvim + Nvchad
echo -en "${BLUE}Instalando Nvchad...${ENDCOLOR}"
sudo apt remove neovim -y 2>/dev/null >/dev/null
sudo rm -rf ~/.config/nvim
sudo rm -rf ~/.local/share/nvim
cd /opt/
sudo -q  wget -P /opt/ https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar xzvf nvim-linux64.tar.gz
rm -f nvim-linux64.tar.gz
git clone -q https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
sudo cp -r ~/.config/nvim /root/.config &>/dev/null
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Install fzf
echo -en "${BLUE}Instalando fzf...${ENDCOLOR}"
git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

sudo git clone -q --depth 1 https://github.com/junegunn/fzf.git /root/.fzf
sudo /root/.fzf/install --all
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Configuramos el tema Nord de Rofi:
echo -en "${BLUE}Instalando Rofi...${ENDCOLOR}"
sleep 1.5
mkdir -p ~/.config/rofi/themes
cp $ruta/rofi/nord.rasi ~/.config/rofi/themes/
rofi-theme-selector
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Instalando Wallpapers
sleep 1.5
mkdir ~/Wallpaper
cp -v $ruta/Wallpaper/* ~/Wallpaper &>/dev/null
echo "# WALLPAPER" >> ~/.config/bspwm/bspwmrc
echo "feh --bg-fill ~/Wallpaper/death.jpg &" >> ~/.config/bspwm/bspwmrc

# Eliminando restos
echo -en "${BLUE}Limpiando restos...    ${ENDCOLOR}"
rm -rf ~/github
rm -rf $ruta
echo -e "${GREEN}Listo.${ENDCOLOR}"

# Mensaje de instalado
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