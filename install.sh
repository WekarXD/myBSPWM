#!bin/bash

# Instalar paquetes necesarios
install_packages() {

    PAKAGE_MANAGER="apt-get"


    #Actualiazar paquetes
    if [ "$PAKAGE_MANAGER" == "apt-get" ]; then
        sudo $PAKAGE_MANAGER update
    fi

    sleep 3

    # Comando para instalar los paquetes necesarios

    echo "Buscando Paquetes necesarios..."

    PAKAGE_COMMON=""

}