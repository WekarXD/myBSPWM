#!/bin/bash

# Funcion instalar paquetes necesarios
install_packages() {

    local PAKAGE_MANAGER

    PAKAGE_MANAGER="apt"

    #Actualiazar paquetes
    if [ "$PAKAGE_MANAGER" == "apt-get" ]; then
        sudo $PAKAGE_MANAGER update
    fi

    sleep 3

    # Comando para instalar los paquetes necesarios

    echo "Buscando Paquetes necesarios..."

    PAKAGE_COMMON=" rofi zsh zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete imagemagick feh libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev build-essential git cmake cmake-data pkg-config python3-packaging libcairo2-dev libxcb1-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev g++ clang python3 libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpcre3 libpcre3-dev libpixman-1-dev libx11-xcb-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-present-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev libjs-sphinxdoc=5.3.0-4 python3-sphinx"

    for package in $PAKAGE_COMMON; do
        if [ "$PAKAGE_MANAGER" == "apt" ] && ! dpkg -l | grep -q " $package "; then
            echo "Instalando $package..."
            sudo $PAKAGE_MANAGER install -y --allow-downgrades $package
            echo -e "[+] Se ha instalado $package"
            sleep 1
        else
            echo "[!] $package ya está instalado."
        fi
    done
}

ruta=$(pwd)

# Verificar e instalar paquetes
install_packages

mkdir ~/github
cd ~/github
echo "Instalando REPOSITORIOS..."
sleep 1.5
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git
git clone --recursive https://github.com/polybar/polybar
git clone https://github.com/ibhagwan/picom.git
git clone https://github.com/Yucklys/polybar-nord-theme.git
# Optener la ultima version de kitty
kitty_last=$(curl -L https://github.com/kovidgoyal/kitty/releases/latest/ | grep "<title>Release version " | awk '{ print $3 }')
wget https://github.com/kovidgoyal/kitty/releases/latest/download/kitty-$kitty_last-x86_64.txz
kitty_bin=$(ls | grep "kitty")

#instalando bspwm
echo "Instalando bspwm..."
sleep 1.5
cd ~/github/bspwm
make -j$(nproc)
sudo make install
sudo apt-get install bspwm -y
# instalando sxhkd
echo "Instalando sxhkd..."
sleep 1.5
cd ~/github/sxhkd
make -j$(nproc)
sudo make install
# Instalando Polybar
echo "Instalando polybar..."
sleep 1.5
cd ~/github/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install
# Instalando Picom
echo "Instalando picom..."
sleep 1.5
cd ~/github/picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install
# Instalando la kitty
echo "Instalando kitty..."
sleep 1.5
cd ~/github
sudo mkdir /opt/kitty
sudo mv $kitty_bin /opt/kitty
cd /opt/kitty/
sudo 7z x $kitty_bin
sudo rm $kitty_bin
kitty_bin=$(ls | grep "kitty")
sudo tar -xf $kitty_bin
sudo rm $kitty_bin
# Instalando las HackNerdFonts
echo "Instalando las HNF"
sleep 1.5
sudo cp -v $ruta/fonts/HNF/* /usr/local/share/fonts/
# Instalando las fuentes en Polybar
sudo cp -v $ruta/Config/polybar/fonts/* /usr/share/fonts/truetype/
# Copiando Archivos de Configuración
echo "Configurando..."
sleep 1.5
cp -rv $ruta/Config/* ~/.config/
sudo cp -rv $ruta/Config/kitty ~/.config/
# Kitty Root
sudo cp -rv $ruta/Config/kitty /root/.config/
# Asignando permisos
chmod u+x ~/.config/bspwm/bspwmrc

# Instalando Wallpapers
sleep 1.5
mkdir ~/Wallpaper
cp -v $ruta/Wallpaper/* ~/Wallpaper
echo "# WALLPAPER" >> ~/.config/bspwm/bspwmrc
echo "feh --bg-fill ~/Wallpaper/death.jpg &" >> ~/.config/bspwm/bspwmrc