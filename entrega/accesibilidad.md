# Artefacto de accesibilidad — 3 barreras

**App:** Control de mantenimiento vehicular  
**Fecha:** 20 de septiembre 2026  
**URL:** `http://127.0.0.1:8090/` (Flutter web + API `127.0.0.1:8001`)  
**Pantallas:** Inicio (Flujo 1) y **Registrar servicio** (Flujo 2, Cambio de aceite)  
**Figma:** `yI6CH5oYwBPGb6MhpEP4jv` (el error de km ya tenía texto + icono; esto cubre el código)  
**Fórmula:** observación → impacto → corrección → prueba posterior  

El scan es evidencia de una revisión, no una nota ni un certificado.

---

## Cómo se auditó

| Herramienta | Qué salió |
|---|---|
| Árbol de accesibilidad del navegador | Inicio y Registrar servicio, antes y después |
| **axe-core 4.10.2** (Deque, el motor de WAVE) | `entrega/axe-registrar.json` — 0 violaciones en Registrar servicio |
| Contraste (WCAG 1.4.3) | Pares medidos a mano sobre tokens de `tema.dart` |
| Teclado | Foco visible en el campo km (borde teal 2 px). Las tarjetas de Inicio son botones con nombre. |
| Lighthouse 13.4.1 (Chrome visible, 20 sep 18:30) | **Accessibility 100** (evidencia IHC). Performance 25 era debug + 4G. |
| Lighthouse 13.5 (HTML Flujo 5, 20 sep 19:25) | **100 en las 4.** Login HTML (`/?go=login`) 22 KiB, TBT 0. Flutter solo arranca tras un login valido. |

WAVE extensión no se puede automatizar aquí. axe-core es el mismo motor Deque; los hallazgos se interpretan abajo, no se entrega el puntaje como nota.

---

## Color (1.4.1 / 1.4.3 / 1.4.11)

El color orienta; el significado no depende solo de él. En Inicio cada tarjeta dice **VENCIDO / PROXIMO / AL DIA** en texto. En Registrar, **VENCIDO** va en la pill con texto. Quitar el color: el estado sigue leyéndose.

Pares medidos (texto normal, umbral AA 4.5:1):

| Par | Ratio | Resultado |
|---|---|---|
| `#5A6663` (muted) sobre blanco | **5.97:1** | Pasa AA |
| `#C93D3D` (VENCIDO / error) sobre blanco | **4.98:1** | Pasa AA |
| `#C93D3D` sobre `#FEF6F6` (fondo de error) | **4.68:1** | Pasa AA |
| `#8A4F00` (PROXIMO) sobre blanco | **6.56:1** | Pasa AA |
| `#00695C` (teal) sobre blanco | **6.61:1** | Pasa AA |
| `#34403D` (texto) sobre blanco | **10.79:1** | Pasa AAA |

El placeholder `#B0B8B5` (2.03:1) no carga el significado: cada campo tiene etiqueta visible encima.

---

## Barrera 1 — el HTML estaba en inglés

**Criterio:** WCAG 3.1.1 Language of Page  

**Observación:** `document.documentElement.lang` era `en-US` aunque `web/index.html` decía `lang="es"`. Flutter web pisa el idioma con el locale por defecto (inglés). El título de la pestaña era el genérico `Mantenimiento`. axe/Lighthouse marcan `html-has-lang` como “hay un lang”, pero el lang **equivocado** no se defiende en oral: la app está en español.

**Impacto:** el lector de pantalla pronunciaba kilometraje, vencido y bolivianos con reglas de inglés. El manifiesto se llamaba `mobile`.

**Corrección:** `MaterialApp` con `locale: Locale('es')`, `supportedLocales` y `flutter_localizations`. Título `Control de mantenimiento vehicular`. `manifest.json` y `apple-mobile-web-app-title` dejan de decir `mobile`.

**Prueba posterior:** `lang="es"`. Título de documento correcto. axe: `html-has-lang` y `html-lang-valid` pasan. El nav dice “Pestaña” (español), no “Tab”.

---

## Barrera 2 — Registrar servicio: campos y acciones sin nombre de verdad

**Criterio:** 1.3.1 Info and Relationships · 4.1.2 Name, Role, Value · 3.3.1 Error Identification  

**Observación (antes):**
- El km era un `TextField` sin `Semantics`; el lector no oía “Kilometraje del servicio”, solo el valor o el placeholder.
- El costo inválido salía en un **SnackBar** suelto, no junto al campo.
- La fecha era un `InkWell` (div con estilo), sin rol botón ni nombre.
- “Guardar mantenimiento” era otro `InkWell` sin `Semantics`.

**Impacto:** sin estilos, no se sabía qué campo llenar, qué corregir ni qué era un botón. El SnackBar desaparece y no queda asociado al costo. Eso es exactamente lo que el docente pidió no hacer.

**Corrección:**
- Km y costo envueltos en `MergeSemantics` con la etiqueta visible + ayuda/error.
- Error de costo **en el campo** (texto + icono + borde rojo), no SnackBar.
- Fecha: `Semantics(button: true, label: 'Fecha del servicio, …')`.
- Guardar: `FilledButton` real (nombre único “Guardar mantenimiento”).

**Prueba posterior (árbol, 20 sep 2026, Registrar servicio):**

| Control | Rol | Nombre |
|---|---|---|
| Km | textbox | Kilometraje del servicio … |
| Fecha | button | Fecha del servicio, 20 sep 2026 |
| Costo | textbox | Costo del servicio … |
| Guardar | button | Guardar mantenimiento |
| Título | heading 2 | Registrar servicio |

axe-core: **0 violaciones**. Foco visible en km (borde teal 2 px).

---

## Barrera 3 — Inicio: las tarjetas no existían para teclado ni AT

**Criterio:** 2.1.1 Keyboard · 2.4.3 Focus Order · 4.1.2 · 1.4.1  

**Observación (antes):** el árbol de Inicio solo tenía las pestañas “Inicio” y “Mi vehiculo”. Historial, Gastos y “Cambio de aceite” **no estaban**. Un overlay semántico “Cargando” (36×36, `pointer-events: auto`) quedaba en el centro después de cargar y tapaba clics. El estado VENCIDO se veía en color, pero AT no leía la tarjeta.

**Impacto:** no se podía abrir Registrar servicio con teclado ni con lector. El Flujo 2 de venta era invisible para AT. El color rojo de VENCIDO no alcanzaba si el control no existía en el árbol.

**Corrección:**
- `ListView` → `SingleChildScrollView` + `Column` (el viewport no traga a los hijos).
- Tarjetas de mantenimiento y gastos como `TextButton` (botón real, un solo nombre, incluye VENCIDO / PROXIMO / AL DIA).
- Iconos y barra de progreso con `ExcludeSemantics` (el texto ya carga el estado).
- Se quitó `semanticsLabel: 'Cargando'` del spinner que se filtraba al árbol.

**Prueba posterior:** Inicio expone botones `Historial de mantenimientos`, `Gastos este año Bs 0`, `Cambio de aceite … VENCIDO`, `Filtro de aire … PROXIMO`. Activar la tarjeta abre Registrar servicio. Si se quita el color, el texto VENCIDO sigue.

---

## Interacción (teclado / zoom / lectura)

| Acción | Qué se vio |
|---|---|
| Tab / foco | El campo km toma foco y el borde pasa a teal 2 px. No se oculta el foco. |
| Enter / activar | La tarjeta “Cambio de aceite” (botón) abre Registrar servicio. Atrás vuelve. |
| Escape | Cierra el date picker nativo de Material (helpText: “Fecha del servicio”). |
| Lectura | lang=es; headings; botones y textboxes con nombre. |
| Zoom | Layout en columna; etiquetas encima del campo, no solo placeholder. |

En Figma el foco ya está dibujado como intención (Clase 9). Acá se verificó en el navegador, no en el lienzo.

---

## Qué no se vende

No se vende Performance del canvas Flutter. Lighthouse IHC se corre sobre el shell HTML.

---

## WAVE (20 sep 20:30)

| Pantalla | Antes | Corrección |
|---|---|---|
| Bienvenida HTML | 4 alertas “Possible heading” (`p.top` en negrita) | Esos títulos pasan a `h2` |
| Inicio (Flutter) | 1 alerta “No page regions” | `SemanticsRole.main` / `navigation` + `<main>`/`<nav>` al cargar Flutter |

Errores y contraste: 0.

---

## Para el impreso (lunes)

1. Abrir Chrome **visible** en `http://127.0.0.1:8090/`, Inicio → Cambio de aceite.
2. DevTools → Lighthouse → **Accessibility** (el 100 de esta corrida sí es evidencia IHC).
3. WAVE (extensión) sobre bienvenida e Inicio; anotar regiones y encabezados.
4. Recorrer Lighthouse en Chrome visible sobre `http://127.0.0.1:8090/` **sin tocar Iniciar sesion** (servidor `node mobile/tool/serve_web.mjs`). Performance, A11y, Best Practices y SEO deben salir **100**.
