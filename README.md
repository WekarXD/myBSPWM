# myBSPWM
Custom sccript to instal bspwm aparence

### Probado
- Parrot OS (5.3)

## Prerequisitos

Primero asegurte de ten er actualizado el sistema.
Puedes actualizarlo con el siguiente comando
```
sudo apt update && sudo parrot-upgrade -y
```

> [!NOTE]
> Actualmtente en parrot os hay un error a la hora de hacer un upgrade nos da un error de kernel.
> Para solucionar este error hay que borrar un paquete antes de hacer el upgrade.
> Esta seria una manera de actualizar
> ´´´
> sudo apt update 
> sudo apt remove realtek-rtl8188eus-dkms
> sudo apt autoclean && sudo apt autoremove
> parrot-upgrade
> sudo parrot-upgrade
> sudo apt autoremove 
> reboot
> ´´´

## 1.- Instalación

```
git clone https://github.com/WekarXD/myBSPWM.git
cd myBSPWM
chmod +x install.sh
./install.sh
```