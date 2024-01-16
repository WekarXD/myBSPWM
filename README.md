# myBSPWM
Script que instala Un tema de BSWPM inspirado en el entornod de s4vitar

Script que realiza una instalacion de un entorno con BSPWM basado en el entorno de [s4vitar](https://github.com/s4vitar).
Inspirado en el Script de [PatxaSec](https://github.com/PatxaSec/myBSPWM)

### Probado
- Parrot OS
- Kali Linux

## Instalación

```
Primero asegurte de ten er actualizado el sistema.
# PARROT OS
sudo apt update && sudo parrot-upgrade -y
# Kali Linux
sudo apt update && sudo apt upgrade -y
```

> [!CAUTION]
> Actualmtente en parrot os hay un error a la hora de hacer un upgrade nos da un error de kernel.
> Para solucionar este error hay que borrar un paquete antes de hacer el upgrade.
> Esta seria una manera de actualizar:
>```
>sudo apt update 
>sudo apt remove realtek-rtl8188eus-dkms
>sudo apt autoclean && sudo apt autoremove
>parrot-upgrade
>sudo parrot-upgrade
>sudo apt autoremove 
>reboot
>```

## Instalación

```
git clone https://github.com/WekarXD/myBSPWM.git
cd myBSPWM
chmod +x install.sh
./install.sh
```

## Atajos de teclas

<kbd>Windows</kbd> + <kbd>Enter</kbd> : Abrir la terminal (kitty).  

<kbd>Windows</kbd> + <kbd>W</kbd> : Cerrar la ventana actual.  

<kbd>Windows</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd> : Recargar la configuración del bspwm.  

<kbd>Windows</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd> : Cerrar sesión.  

<kbd>Windows</kbd> + <kbd>(⬆⬅⬇➡)</kbd> : Moverse por las ventanas en la workspace actual.

<kbd>Windows</kbd> + <kbd>Alt</kbd> + <kbd>(⬆⬅⬇➡)</kbd> : cambiar tamaño de la ventana seleccionada en la workspace actual.

<kbd>Windows</kbd> + <kbd>D</kbd> : Abrir el Rofi para la busqueda de herramientas. <kbd>Esc</kbd> para salir.  

<kbd>Windows</kbd> + <kbd>(1,2,3,4,5,6,7,8,9,0)</kbd> : Cambiar el workspace. 

<kbd>Windows</kbd> + <kbd>Shift</kbd> + <kbd>(1,2,3,4,5,6,7,8,9,0)</kbd> : Mover ventana actual a otro workspace.

<kbd>Windows</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd> : Abrir Firefox.

<kbd>Windows</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd> : Abrir Burpsuite.

<kbd>print</kbd> : screenshot seleccionable.

<kbd>print</kbd> + <kbd>ctrl</kbd>: screenshot.

<kbd>print</kbd> + <kbd>alt</kbd> : screenshot pantalla.

