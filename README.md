# myBSPWM

**myBSPWM** es un script que instala un tema personalizado para el gestor de ventanas [BSPWM](https://github.com/baskerville/bspwm), inspirado en el entorno de [s4vitar](https://github.com/s4vitar) y en el script de [PatxaSec](https://github.com/PatxaSec/myBSPWM). Este tema incluye configuraciones predefinidas para facilitar la navegación entre ventanas, el manejo de espacios de trabajo (workspaces), y la apertura rápida de aplicaciones esenciales.

Actualmente, este tema ha sido probado y funciona correctamente en sistemas basados en Debian que utilizan el gestor de paquetes `apt`. Otros sistemas que usen diferentes gestores de paquetes podrían experimentar fallos durante la instalación.

### Distribuciones Probadas

Este script ha sido comprobado en las siguientes distribuciones:

- **Parrot OS**
- **Kali Linux**
- **Ubuntu**

## Instalación

Para instalar el tema, sigue estos pasos:

```
git clone https://github.com/WekarXD/myBSPWM.git
cd myBSPWM
chmod +x install.sh
./install.sh
```

Este script instalará y configurará automáticamente todos los archivos necesarios para personalizar tu entorno de BSPWM.

## Atajos de teclas

A continuación, se muestra una lista de atajos de teclado preconfigurados para navegar y gestionar ventanas en tu entorno BSPWM. Estos atajos utilizan la tecla Windows como modificador principal.

| Combianción de teclas                                     | Acción                                                     |
| --------------------------------------------------------- | ---------------------------------------------------------- |
| <kbd>Windows</kbd> + <kbd>Enter</kbd>                     | Abrir la terminal **Kitty**                                |
| <kbd>Windows</kbd> + <kbd>W</kbd>                         | Cerrar la ventana activa                                   |
| <kbd>Windows</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd>        | Recargar la configuración de BSPWM                         |
| <kbd>Windows</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd>        | Cerrar sesión                                              |
| <kbd>Windows</kbd> + <kbd>⬆⬅⬇➡</kbd>                      | Moverse entre las ventanas abiertas en la workspace actual |
| <kbd>Windows</kbd> + <kbd>Alt</kbd> + <kbd>⬆⬅⬇➡</kbd>     | Redimensionar la ventana seleccionada                      |
| <kbd>Windows</kbd> + <kbd>D</kbd>                         | Abrir el lanzador **Rofi** para búsqueda de aplicaciones   |
| <kbd>Windows</kbd> + <kbd>1-9, 0</kbd>                    | Cambiar entre workspaces (espacios de trabajo)             |
| <kbd>Windows</kbd> + <kbd>Shift</kbd> + <kbd>1-9, 0</kbd> | Mover ventana actual a otro workspace                      |
| <kbd>Windows</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd>      | Abrir **Firefox**                                          |
| <kbd>Windows</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd>      | Abrir **Burpsuite**                                        |

## Personalización

Este entorno ha sido diseñado para ser fácilmente modificable. Si deseas ajustar los atajos de teclado, puedes hacerlo editando el archivo ~/.config/sxhkd/sxhkdrc, que define las combinaciones de teclas.

Para modificar la apariencia de BSPWM o Polybar, revisa los archivos de configuración en ~/.config/bspwm/ y ~/.config/polybar/, respectivamente.

## Notas adicionales

- Gestión de Pantallas: Si utilizas múltiples monitores, asegúrate de configurar adecuadamente tu archivo de configuración de xrandr o arandr para manejar la disposición de las pantallas.
- Polybar: Si decides usar Polybar como barra de estado, puedes personalizarla ajustando el archivo de configuración ubicado en ~/.config/polybar/config.

# Contribuciones

Si deseas contribuir a este proyecto o reportar algún error, por favor abre un issue en GitHub.

# Licencia

Este proyecto está bajo la licencia MIT. Para más detalles, consulta el archivo LICENSE.
