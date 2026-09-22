# Flujos — alineados al Figma real

Archivo: [Control Vehicular — Wireframe Mejorado](https://www.figma.com/design/yI6CH5oYwBPGb6MhpEP4jv/Control-Vehicular-%E2%80%94-Wireframe-Mejorado?node-id=242-1411) (`yI6CH5oYwBPGb6MhpEP4jv`).

Auditado el **21 sep 2026**. El Flujo 5 en Figma pasó de login a **ajustar intervalos** (Flujo D). La numeración es la del archivo.

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

**Prototipo (para video):** arranca solo desde `04_Clase9_Estados`. Hay **5 flujos** en el menú. Cada uno es **un solo recorrido** (no se repite 3 veces): historia → **error de validación** → **corregir / happy path** → resultado. Las filas Principal · Happy Path · Validaciones siguen en el lienzo para el **impreso**; el prototipo toma pantallas de las tres y las encadena. Wireframes no tiene starting points.

**Huecos vs Clase 10**

- ~~El docente pidió cinco flujos. En Figma hay cuatro.~~ **Flujo 5 (intervalos / uso intensivo) en `02_Wireframes` y `04_Clase9_Estados`** (21 sep 2026). La tira de login se **eliminó** del Figma.
- Gestión de usuario: **sigue en código** (`acceso.dart`, `sesion.dart`) pero **no está en Figma** (el docente no lo cuenta).
- **No hay** pantalla de alta de vehículo en Figma (sí está en código).
- En Clase 9, los Flujos 1–4 siguen con muchos frames llamados `pantalla`. El Flujo 5 de intervalos ya tiene Principal · Happy Path · Validaciones.

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

### Flujo 5 — ajustar intervalos a su uso intensivo

**Estado Figma:** cerrado (21 sep 2026) en `02_Wireframes` (6 pantallas + prototipo) y `04_Clase9_Estados` (Principal · Happy Path · Validaciones).  
**Código:** el botón **Plan de mantenimiento** está arriba en `mi_vehiculo.dart`. Pantallas: `plan_mantenimiento.dart`, `detalle_intervalo.dart`, `editar_intervalo.dart`. El aceite de fábrica queda en 4.000 km; al guardarlo en 3.000, Inicio recalcula el pendiente.

[Tira en Wireframes](https://www.figma.com/design/yI6CH5oYwBPGb6MhpEP4jv/Control-Vehicular-%E2%80%94-Wireframe-Mejorado?node-id=331-1553) · [Clase 9](https://www.figma.com/design/yI6CH5oYwBPGb6MhpEP4jv/Control-Vehicular-%E2%80%94-Wireframe-Mejorado?node-id=276-2872)

Pasos: **Inicio** → **Mi vehículo** → **Plan de mantenimiento** → **Detalle cambio de aceite** (ver intervalo 4.000 km y por qué) → **Editar intervalo** (3.000 km + guardar) → **Plan** actualizado → **Inicio** con pendiente recalculado.

Validaciones (IHC, no solo color — campo Error/Success con texto + icono):
1. Intervalo vacío
2. No es un número (`abc`)
3. Menor al mínimo (el campo muestra 200; el texto dice que el mínimo es 500 km)
4. Igual al de fábrica (4.000) — pedí bajarlo para uso intensivo
5. Guardado con éxito (3.000 km)

Componentes reutilizados: Status bar, Maintenance card, Bottom nav, Primary button, Campo de texto.

*(Eliminado)* La tira de login/acceso ya no está en Figma.

## Hueco que queda

**Alta de vehículo:** cerrada en código, cero pantallas en Figma. No es uno de los cinco. No hace falta dibujarla salvo que quieran mostrarla en el video de la app.

## Cómo imprimir y grabar

**Impreso:** `04_Clase9_Estados` de los Flujos 1–5 (cada uno con Principal · Happy Path · Validaciones).

### Video Figma (2–3 min) — los 5 flujos

Abrí el prototipo desde **04_Clase9_Estados**. En el menú hay **5 flujos** (uno por historia).

**Patrón de cada flujo (ya cableado):**
1. Entrá al flujo y seguí los clics normales (nav, cards, botones).
2. Vas a chocar con **un error** (campo en estado Error: texto + icono).
3. El siguiente clic lleva al **happy path** (dato correcto / éxito).
4. Terminás en el **resultado** (Inicio al día, detalle, pendiente recalculado, etc.).
5. **R** = reiniciar → elegí el siguiente flujo.

No hace falta pasar Principal, luego Happy Path y luego Validaciones por separado: eso era repetir lo mismo 3 veces. Las 3 filas del lienzo son para **imprimir** Clase 9; el video usa una cadena única.

**Guión sugerido (~30–35 s por flujo ≈ 2:30–3:00):**
| Orden | Flujo | Qué mostrar |
|---|---|---|
| 1 | Consultar mantenimiento | Km inválido → km OK → ver pendiente |
| 2 | Registrar | Formulario con error → guardar bien → Inicio al día |
| 3 | Historial | Historial vacío/error → lista → detalle aceite |
| 4 | Gastos | Gastos vacío → total → llantas (rubro alto) |
| 5 | Intervalos | Editar → intervalo vacío → 3.000 OK → Inicio recalculado |

**Cómo grabar:** Present en Figma → grabar pestaña (OBS / Clipchamp / Game Bar). El día de la expo solo das play.

**Video app:** Flujos 1–5. El 5 se recorre en la app: Mi vehículo → Plan → detalle del aceite → editar a 3.000 → Inicio con el aviso de intervalo actualizado.


