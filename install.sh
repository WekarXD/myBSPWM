#!/bin/bash

# Funcion instalar paquetes necesarios
install_packages() {

    PAKAGE_MANAGER="apt-get"


    #Actualiazar paquetes
    if [ "$PAKAGE_MANAGER" == "apt-get" ]; then
        sudo $PAKAGE_MANAGER update
    fi

    sleep 3

    # Comando para instalar los paquetes necesarios

    echo "Buscando Paquetes necesarios..."

    PAKAGE_COMMON="libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev g++ clang git cmake pkg-config python3 python3-sphinx python3-packaging"

    for package in $PAKAGE_COMMON; do
        if [ "$PAKAGE_MANAGER" == "apt" ] && ! dkpg -l | grep -q " $package "; then
            echo "Instalando $package..."
            sudo $PAKAGE_MANAGER install -y $package
            echo "Se ha instalado $package"
            sleep 2
        else
            echo "$package ya está instalado."
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
#instalando bspwm
echo "Instalando bspwm..."
sleep 1.5
cd ~/github/bspwm
make -j$(nproc)
sudo make install
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
# echo "Instalando picom..."
# sleep 1.5
# cd ~/github/picom
# git submodule update --init --recursive
# meson --buildtype=release . build
# ninja -C build
# sudo ninja -C build install