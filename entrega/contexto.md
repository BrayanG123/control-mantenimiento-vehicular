# Entrega final IHC — Control de Mantenimiento Vehicular

Fuente de verdad para seguir al pie de la letra lo que pidió el docente (Clase 10 · Guía de avance + indicaciones orales). Actualizar el estado aquí y registrar cada cambio en `log.md`.

**Integrantes:** Gonzales Alba Jose Brayan · Saavedra Alberto Diego Joaquin  
**App:** Control de Mantenimiento Vehicular (móvil, sin IA)  
**Hoy de referencia:** domingo 20 de septiembre 2026

---

## Fechas que no se mueven

| Cuándo | Qué | Si falla |
|---|---|---|
| **Lunes 21 sep, noche** | Código congelado. El docente revisa el repo y anota líneas para preguntar. | Preguntas sobre código que el grupo no puede explicar. |
| **Martes 22 sep, 18:00** | Cierra la carpeta de Google Drive: 2 videos + documento digital. | **Sin video = sin nota.** |
| **Martes 22 sep, clase** | Impreso físico + exposición ≤ 5 min (ruleta). Puede alargarse hasta tarde. | Hojas sueltas = mala impresión. Demo en vivo = riesgo de cuelgue. |

No hay tutoría extra hasta el martes. Lo que no esté cerrado, se cierra aquí.

---

## Qué está evaluando (cuatro capas)

La diapositiva 11 lo resume: *la entrega debe mostrar una solución que se pueda presentar y defender.*

1. **Producto** — problema → oportunidad → solución → valor. Vender, no “hoy presentamos un prototipo”.
2. **Diseño** — **cinco flujos** en Figma e impreso, legibles sin explicación oral. Happy path + validación.
3. **Implementación** — la app **corriendo** lo que se promete. Código al día el lunes noche. Plus si hay enlace publicado.
4. **Accesibilidad (IHC)** — evidencia **propia** (no la demo de clase): Lighthouse + WAVE + Figma + teclado/zoom/lectura.

**Límite ético (palabra del docente):** vender solo lo que se ve en Figma, video e impreso. Si no hay QR / login / IA en lo que muestran, no lo mencionen.

---

## Entregables

### Documento A — Proceso y todos los flujos

- Antecedentes breves.
- **Cinco flujos numerados** (ver `flujos.md`).
- En cada flujo: pantallas en secuencia, happy path y validación.
- Tamaño carta, **legible**. No 100 hojas.

### Documento B — Solución y sus razones

- Qué es la app, para quién, qué valor da.
- Decisiones defendidas con la investigación (Carlos, Mariana, Bs 20 vs Bs 350, intervalos mal estimados).

### Artefacto pequeño de accesibilidad (dentro del impreso)

Fórmula por barrera: **observación → impacto → corrección → prueba posterior**.

Debe cubrir:

- Flujo y contexto (Figma, código, URL o commit, fecha, situación).
- Color (pareja medida; el significado no depende solo del color).
- Reportes (Lighthouse + WAVE con **tres hallazgos interpretados**, no el puntaje).
- Interacción (Tab / Shift+Tab / Enter / Escape, foco visible, zoom, re-prueba).

**Regla:** el scan es evidencia de una revisión, no una nota ni un certificado.  
**Regla:** la demo de “Registrar movimiento” solo enseña a interpretar. La evidencia sale de **esta** app.

### Figma

- Los cinco flujos terminados.
- Video de Figma de **2–3 min** (mostrar al menos dos flujos; no navegar en vivo el día de la expo).

### Videos (Drive, martes 18:00)

1. Figma (flujos).
2. App **corriendo** (no tour del repositorio).

### Código

- Listo el lunes noche.
- Dos preguntas de código el martes. El compañero puede salvar al grupo.
- Plus: desplegado (web, servidor, Play Store).

### Impreso físico

- Carta + **carátula** + **fastener / flip**. **No hojas sueltas.**
- Primera impresión: solo se da una vez.

### Presentación (máx. 5 min)

1. Problema y oportunidad.
2. Solución y valor.
3. Defender decisiones con la investigación.
4. Play al video de Figma, luego al video de la app.
5. Un solo expositor practicado. Orden por ruleta.

---

## Accesibilidad — criterios de la clase 10

### Color (WCAG 1.4.1, 1.4.3, 1.4.11)

- El color orienta; **nunca carga solo el significado**.
- Texto normal ≥ **4.5:1**. Texto grande / bordes / iconos relevantes ≥ **3:1**.
- Prueba: medir la pareja real y **quitar el color**. Si el estado deja de entenderse, agregar texto, icono o estructura.

### Código web / tecnología asistiva

- El navegador debe saber qué es cada cosa: nombres, roles, estados, relaciones.
- Títulos, regiones, botones reales (no `div` con estilo de botón).
- Etiqueta visible asociada al campo.
- Ayuda y error **relacionados con el campo** que hay que corregir (no un SnackBar genérico suelto).
- Anunciar carga, éxito y error.
- Pregunta de defensa: *si quito los estilos, ¿sé qué es un botón, qué campo lleno y qué debo corregir?*

### Teclado (solo en el navegador, no en el lienzo de Figma)

- Tab, Shift+Tab, Enter, Escape recorren y activan el flujo real.
- El foco **se ve**. No ocultarlo “para que se vea más limpia”.
- En Figma solo se dibuja la **intención** del foco.

### Cómo auditar (ciclo)

1. **Ejecutar** — fecha, URL o commit, pantalla.
2. **Leer** — elemento, problema, criterio, impacto.
3. **Corregir** — causa en Figma y código.
4. **Repetir** — scan de nuevo + teclado + zoom + lectura.

Herramientas: **Lighthouse**, **WAVE**, **contraste en Figma**. Las tres.

**Estado actual del scan:** 20 sep 2026. Artefacto en `entrega/accesibilidad.md` (3 barreras). axe-core: `entrega/axe-registrar.json` (0 violaciones). Lighthouse: **100 en Performance, Accessibility, Best Practices y SEO** (bienvenida HTML; Flutter al clic).

---

## Los flujos (fuente: Figma, auditado 20 sep 2026)

Archivo: [Control Vehicular — Wireframe Mejorado](https://www.figma.com/design/yI6CH5oYwBPGb6MhpEP4jv/Control-Vehicular-%E2%80%94-Wireframe-Mejorado?node-id=242-1411). Detalle en `flujos.md`.

**No inventar otra numeración.** En Figma ya están así:

| # en Figma | Flujo | `02_Wireframes` | `04_Clase9_Estados` (Principal / Happy / Validación) | Código |
|---|---|---|---|---|
| 1 | Consultar qué mantenimiento toca | Sí, 5 pasos | Sí | `inicio.dart`, `mi_vehiculo.dart` |
| 2 | Registrar mantenimiento realizado | Sí, 5 pasos | Sí | `registrar_mantenimiento.dart` |
| 3 | Consultar historial | Sí, 5 pasos | Sí | `historial.dart`, `detalle_mantenimiento.dart` |
| 4 | Revisar cuánto gastó en el año | Sí, 5 pasos | Sí | `gastos.dart` |
| **5** | **Gestionar el acceso** (inicio → login, crear cuenta, olvidé) | **Sí, 6 pasos** | **Sí (P / HP / V)** | `acceso.dart`, `sesion.dart` |
| — | Alta de vehículo | No hay pantalla | No | `alta_vehiculo.dart` (cerrado IHC) |

El docente pidió **cinco flujos**. Los cinco están en Figma **y en código**. El 5 es sesión local (sin API de usuarios): se vende como pantallas de acceso, no como login de servidor.

Gastos **sí cuenta**: está diseñado, prototipado en tira y con validaciones en Clase 9. Si se imprime, se puede vender. El brief v0.2 lo dejaba fuera; el Figma lo metió. Defenderlo o no, pero no decir que no existe.

---

## Qué sí se puede vender (si se ve)

- Un lugar para el historial (aceite, llantas, frenos, filtros, cadena).
- Kilometraje y próximo servicio calculado.
- Dejar de depender de memoria / notas sueltas.
- Ahorro: prevenir vs reparar (Mariana).
- Transparencia frente al taller (Carlos).

## Qué no se vende

- Autenticación contra un servidor (la sesión del Flujo 5 es **local**, en memoria; no hay JWT ni usuarios en el backend).
- Notificaciones push, multi-vehículo, IA, integración con talleres.
- Play Store si no está publicado.

---

## Orden de trabajo (al pie de la letra)

1. **Cerrar los cinco flujos** (spec + Figma + código IHC: happy path y validación).
2. Artefacto de accesibilidad: 3 barreras, Lighthouse + WAVE reales, teclado/zoom.
3. Documento A + B listos para imprimir.
4. Videos 2–3 min.
5. Código congelado lunes noche; los dos pueden explicar cálculo, validación y semántica.
6. Ensayo de venta 5 min.

---

## Archivos de esta carpeta

| Archivo | Para qué |
|---|---|
| `contexto.md` | Requisitos del docente y estado de la entrega. |
| `flujos.md` | Los cinco flujos: pantallas, happy path, validación, brechas. |
| `log.md` | Historial de cada modificación. **No borrar entradas.** |
