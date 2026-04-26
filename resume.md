# Resumen del Proyecto: Silent-Kurisu

Este documento resume la estructura y el diseño del tema **Silent-Kurisu** para SDDM, optimizado y personalizado.

## 1. Descripción General
**Silent-Kurisu** es una versión personalizada y optimizada del tema "Silent" para SDDM. Está diseñado con un enfoque en la **estética minimalista**, alto rendimiento y la eliminación de componentes innecesarios como el teclado virtual.
- **Versión analizada:** 1.4.0

## 2. Arquitectura y Módulos

El proyecto está organizado de manera modular, separando la lógica de configuración, los componentes de la interfaz y los recursos estáticos.

### Núcleo (Core)
- **`Main.qml`**: El punto de entrada principal. Gestiona los estados globales del tema y la transición entre la pantalla de bloqueo y el inicio de sesión.
- **`Config.qml`**: Un Singleton que actúa como el motor de configuración. Mapea las opciones de los archivos `.conf` a propiedades de QML utilizables en todo el tema.
- **`metadata.desktop`**: Define los metadatos del tema y especifica qué archivo de configuración cargar por defecto (ej. `configs/rei.conf`).

### Componentes de Interfaz (`components/`)
La UI está dividida en submódulos lógicos:
- **`LoginScreen.qml`**: El núcleo del login, incluyendo el contenedor de usuario, campo de contraseña y botón de entrada.
- **`LockScreen.qml`**: Una capa de "bienvenida" o bloqueo que muestra el reloj y la fecha antes de transicionar al login.
- **`MenuArea.qml`**: Gestiona las herramientas del sistema:
    - **SessionSelector**: Cambio de escritorio (Hyprland, Plasma, etc).
    - **LayoutSelector**: Cambio de teclado.
    - **PowerMenu**: Botones de apagado, reinicio, etc.
    - **KeyboardToggle**: Activa el teclado virtual.
- **`Avatar.qml`**: Componente dedicado para mostrar la imagen de usuario con soporte para diferentes formas (círculo/cuadrado) y efectos.
- **`Input.qml`**: Una abstracción de `TextField` estilizada para mantener la consistencia visual.

### Recursos
- **`backgrounds/`**: Contiene imágenes y archivos de video para el fondo.
- **`icons/`**: SVGs personalizados para la interfaz.
- **`fonts/`**: Tipografías integradas (ej. RedHatDisplay).

## 3. Diseño y Composición
- **Estados Dinámicos**: El tema alterna entre `lockState` y `loginState`.
- **Efectos Visuales**: Utiliza `MultiEffect` (Qt 6) para aplicar desenfoque (blur), brillo y saturación dinámicos al fondo, lo que permite que el login destaque sobre el wallpaper.
- **Multimedia**: Soporte nativo para fondos de video (`.mp4`, `.webm`, etc.) mediante `VideoOutput`.
- **Responsividad**: Utiliza anclas (`anchors`) y cálculos basados en la geometría de la pantalla principal para adaptarse a diferentes resoluciones.

## 4. Notas para Replicación y Optimización

Para replicar este proyecto de forma optimizada en tu sistema:

### Optimizaciones de Rendimiento
1. **Vídeo como fondo:** El autor menciona que el uso de vídeos con bindings de propiedades puede ser lento. Para optimizar, se recomienda inicializar los recursos multimedia una sola vez al arranque y evitar re-evaluaciones innecesarias del motor de bindings.
2. **Uso de MultiEffect:** Aunque es más eficiente que los antiguos `GaussianBlur`, sigue consumiendo GPU. En sistemas con pocos recursos, podrías considerar pre-procesar versiones desenfocadas de los fondos si estos no cambian dinámicamente.
3. **GIFs:** Se advierte sobre *segfaults* en configuraciones de múltiples monitores con GIFs en versiones específicas de Qt/SDDM. Es mejor usar vídeos en bucle o imágenes estáticas.

### Personalización
Para crear tu propia versión:
1. Crea un nuevo archivo en `configs/tunombre.conf`.
2. Define tus colores y rutas de fondos allí.
3. Cambia la línea `ConfigFile` en `metadata.desktop` para que apunte a tu nuevo archivo.

### Dependencias Críticas
Asegúrate de tener instalados los módulos de Qt necesarios:
- `qt6-multimedia` (para vídeos)
- `qt6-declarative` (QML principal)
- `qt6-5compat` (si se usan componentes heredados)
