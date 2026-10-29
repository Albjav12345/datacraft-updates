# DataCraft 1.4.0 — Edita datos en tabla, deshaz cambios y compruébalos jugando

DataCraft 1.4.0 facilita la edición de catálogos grandes e incorpora un pequeño ejemplo jugable que conecta la creación de datos con su uso en el juego. También reúne las mejoras de modelos e Inspector preparadas durante el hito interno 1.3.

## Editar varias instancias

- Alterna entre Cards y una tabla adaptable con valores tipados, búsqueda, orden visual por nombre y ocho filas por página.
- Selecciona filas de distintas páginas y cambia un campo de hasta 1.024 instancias a la vez.
- Revisa el lote completo antes de guardar: valores anteriores/nuevos, páginas de revisión y bloqueos que aún impiden exportar. Una revisión desactualizada no se puede aplicar.
- Aplica todo como un único paso de Undo de Unity, conservando identidades, orden, otros campos y filas no seleccionadas.

## Undo nativo y límites más claros

Las ediciones confirmadas de instancias participan en Undo/Redo de Unity, incluidas las importaciones/actualizaciones de solo instancias, la revisión del esquema de borradores y los cambios en lote. El historial dura mientras permanece abierto el espacio de trabajo; los cambios incompatibles de esquema y las importaciones coordinadas lo invalidan o reinician de forma segura. Los conflictos con archivos externos y los fallos de escritura conservan los datos existentes y explican la recuperación.

Undo modifica borradores. Actualizar el catálogo generado del juego sigue siendo una acción explícita de Project Data. Este historial no sustituye una copia de seguridad ni migra partidas guardadas.

## El nuevo Catalog Starter

Abre Tools → DataCraft → Samples and Quick Start. El campo de tiro funciona sin conexión y viene preparado para jugar: Swift y Heavy obtienen su daño y tiempo entre disparos de un modelo tipado del catálogo.

La guía continúa con la importación de su biblioteca, el cambio de daño desde Table, la revisión, Undo/Redo, la publicación del catálogo y su asignación a una escena duplicada. Entonces basta un disparo para eliminar un objetivo. Dentro del juego se muestra el pequeño código de acceso a datos y se explica qué reglas de juego siguen siendo tuyas.

Catalog Starter utiliza UI Toolkit y la dependencia JSON del núcleo. No requiere pipeline de renderizado, paquete de entrada, cuenta de red ni archivo de guardado. Su catálogo incluido permanece separado de los borradores y de los datos generados de tu proyecto.

## También incluido desde 1.2.1

- Generación opcional de modelos parciales C# y Enums, con vista previa, protección de archivos y controles de actualización antes de compilar.
- Selectores de referencias con apariencia nativa de Unity, búsqueda, listas, edición múltiple y cambios de prefab; un pequeño icono cian identifica DataCraft.
- Avisos de conflicto más claros, resúmenes de importación parcial y controles compactos de Project Data.
- Historial de versiones con altura limitada y desplazamiento propio en Settings.
- Guías iniciales, ayuda integrada y capturas reales de Unity actualizadas.

Se mantienen los DTO manuales, los IDs estables y los formatos de guardado/catálogo existentes. Haz una copia del proyecto antes de actualizar. Genera los modelos de forma explícita, conserva tus miembros parciales en archivos separados y revisa tu código si cambias nombres de tipos generados.

La disponibilidad de itch.io y Unity Asset Store se gestiona por separado. Publicar este devlog no anuncia automáticamente la actualización dentro del editor: primero debe comprobarse la descarga exacta subida a la tienda.
