# Flujos — alineados al Figma real

Archivo: [Control Vehicular — Wireframe Mejorado](https://www.figma.com/design/yI6CH5oYwBPGb6MhpEP4jv/Control-Vehicular-%E2%80%94-Wireframe-Mejorado?node-id=242-1411) (`yI6CH5oYwBPGb6MhpEP4jv`).

Auditado el **20 sep 2026**. El **20 sep** se agregó el Flujo 5 (login) en Figma. La numeración es la del archivo.

Persona: **Mariana** (Honda CB 150, 2021). Investigación en `research/evidencias.md`.

## Auditoría (qué hay hoy)

**Páginas**

| Página | Qué es |
|---|---|
| `00_Foundations` | Color y dimension tokens |
| `01_Components` | Status bar, cards, nav, botón (Default/Pressed/Disabled/Loading/Done), campo (Rest/Focus/Error/Success), pills, historial, barra. Guía Clase 6. |
| `02_Wireframes` | Inventario + **4 tiras de flujo** de 5 pasos cada una + pantallas sueltas |
| `Mini Sistema Visual` | Poster 1100×2779 |
| `03_Web` | Un frame por pantalla, parte de 412. Al estirar: tablet (sidebar) → web (cards en fila). Auto Layout WRAP. |
| `04_Clase9_Estados` | Por cada flujo: fila Principal · Happy Path · Validaciones (pantallas conectables, no anotaciones) |

**Ya cubre IHC de error:** el campo de km tiene Reposo / Foco / Error (“Debe ser mayor al último registrado: 12.500 km”) / Éxito. El color no va solo. Las pills dicen VENCIDO / PRÓXIMO / AL DÍA / HECHO.

**Prototipo:** hay ~26 interacciones en Wireframes y ~26 en Clase 9 (varias son solo el tab Mi vehículo). Sirve para grabar video; conviene verificar que el happy path de cada tira esté enlazado de punta a punta.

**Huecos vs Clase 10**

- ~~El docente pidió cinco flujos. En Figma hay cuatro.~~ **Flujo 5 (login) agregado el 20 sep 2026** en `02_Wireframes` y `04_Clase9_Estados`.
- Gestión de usuario: **está en Figma y en código** (`acceso.dart`, `sesion.dart`). Sesión local; no hay API de usuarios.
- **No hay** pantalla de alta de vehículo en Figma (sí está en código).
- En Clase 9, los Flujos 1–4 siguen con muchos frames llamados `pantalla`. El Flujo 5 sí está nombrado.

## Los cinco flujos

### Flujo 1 — consultar qué mantenimiento toca

**Estado Figma:** cerrado (tira + Clase 9 con happy path y validación).  
**Código:** `inicio.dart`, `mi_vehiculo.dart`

Pasos en `02_Wireframes`: Abrir app → Ver mi vehículo → Actualizar km → Ver próximo → Consultar pendiente.

Validación ya diseñada: km menor al último (9.800 vs 12.500) con texto + icono.

### Flujo 2 — registrar mantenimiento realizado

**Estado Figma:** cerrado.  
**Código:** `registrar_mantenimiento.dart` — cerrado IHC el 20 sep: etiquetas asociadas, error de costo en el campo (texto + icono), fecha y guardar con rol botón, foco visible.

Pasos: Inicio con aceite vencido → Abrir registro → Completar datos → Guardar → Inicio al día.

Es el flujo de **venta** y el de **video**.

### Flujo 3 — consultar historial

**Estado Figma:** cerrado.  
**Código:** `historial.dart`, `detalle_mantenimiento.dart`

Pasos: Inicio → Historial → Lista → Detalle aceite → Fecha y km (y costo).

### Flujo 4 — revisar cuánto gastó en el año

**Estado Figma:** cerrado.  
**Código:** `gastos.dart`

Pasos: Inicio → Resumen Bs 980 → Confirmar año → Rubro llantas → Detalle.

El brief v0.2 lo dejaba fuera de alcance; **el Figma y la app lo tienen**. Si se imprime, se vende. No decir que no existe.

### Flujo 5 — gestionar el acceso

**Estado Figma:** cerrado (20 sep 2026) en `02_Wireframes` y `04_Clase9_Estados`.  
**Código:** `mobile/lib/pantallas/acceso.dart` + `mobile/lib/sesion.dart`. Happy path y validación. Sesión en memoria (cuenta demo `mariana@correo.com` / `123456`). No hay usuarios en FastAPI: si el ingeniero pregunta, eso se dice.

[Tira en Wireframes](https://www.figma.com/design/yI6CH5oYwBPGb6MhpEP4jv/Control-Vehicular-%E2%80%94-Wireframe-Mejorado?node-id=279-1549) · [Clase 9](https://www.figma.com/design/yI6CH5oYwBPGb6MhpEP4jv/Control-Vehicular-%E2%80%94-Wireframe-Mejorado?node-id=276-2872)

Pasos: **Abrir la app** (inicio + botón Iniciar sesión) → Iniciar sesión → Completar correo y contraseña → Crear cuenta → Olvidé contraseña → Revisa tu correo (éxito con texto e icono).

Validaciones (IHC, no solo color):
1. Correo vacío — “Ingresa un correo. Ejemplo: mariana@correo.com”
2. Contraseña vacía
3. Crear cuenta — “Las contrasenas no coinciden.”
4. Olvidé — “Ingresa el correo para enviarte el enlace.”
5. Formato inválido — “mariana.correo” + explicación
6. Correo o contraseña no coinciden (código; no estaba en Figma)

Reutiliza el mismo campo (etiqueta + error con icono) y botón real (`FilledButton`: Iniciar sesión / Crear cuenta / Enviar enlace).

Cerrar sesión: icono en Mi vehículo, para volver a entrar al flujo.

## Hueco que queda

**Alta de vehículo:** cerrada en código, cero pantallas en Figma. No es uno de los cinco. No hace falta dibujarla salvo que quieran mostrarla en el video de la app.

## Cómo imprimir y grabar

**Impreso:** `04_Clase9_Estados` de los Flujos 1–5 (el 5 ya tiene Principal · Happy Path · Validaciones con nombres legibles).

**Video Figma (2–3 min):** Flujo 2 (registrar aceite) + un corte de Flujo 5 (login + un error) o Flujo 1 (km).

**Video app:** Flujos 1–5. El 5 se muestra: bienvenida → login (un error vacío + happy path con Mariana).


