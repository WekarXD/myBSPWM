#!/bin/bash

# Funcion instalar paquetes necesarios
install_packages() {

    PAKAGE_MANAGER="apt"


    #Actualiazar paquetes
    if [ "$PAKAGE_MANAGER" == "apt" ]; then
        sudo $PAKAGE_MANAGER update
    fi

    sleep 3

    # Comando para instalar los paquetes necesarios

    echo "Buscando Paquetes necesarios..."

    PAKAGE_COMMON="kitty libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev g++ clang git cmake pkg-config python3 python3-sphinx python3-packaging cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev"

    for package in $PAKAGE_COMMON; do
        if [ "$PAKAGE_MANAGER" == "apt" ] && ! dkpg -l | grep -q " $package "; then
            echo "Instalando $package..."
            sudo $PAKAGE_MANAGER install -y $package
            echo -e "[+] Se ha instalado $package"
            sleep 2
        else
            echo "[!] $package ya está instalado."
            sleep 5
        fi
    done
    pip install -U sphinx
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
#instalando bspwm
echo "Instalando bspwm..."
sleep 1.5
cd ~/github/bspwm
make -j$(nproc)
sudo make install
sleep 10
# instalando sxhkd
echo "Instalando sxhkd..."
sleep 1.5
cd ~/github/sxhkd
make -j$(nproc)
sudo make install
sleep 10
# Instalando Polybar
echo "Instalando polybar..."
sleep 1.5
cd ~/github/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install
sleep 10
# Instalando Picom
# echo "Instalando picom..."
# sleep 1.5
# cd ~/github/picom
# git submodule update --init --recursive
# meson --buildtype=release . build
# ninja -C build
# sudo ninja -C build install

# Copiando Archivos de Configuración
echo "Configurando..."
sleep 1.5
cp -rv $ruta/Config/* ~/.config/
