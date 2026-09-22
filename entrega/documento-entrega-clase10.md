# Entrega IHC Clase 10 — Control de mantenimiento vehicular

**Materia:** Interacción Humano-Computador — Clase 10  
**Integrantes:** Gonzales Alba Jose Brayan · Saavedra Alberto Diego Joaquin  
**Producto:** Control de mantenimiento vehicular (móvil, sin IA)  
**Persona de venta:** Mariana (Honda CB 150, 2021)  
**Figma:** https://www.figma.com/design/yI6CH5oYwBPGb6MhpEP4jv/Control-Vehicular-—-Wireframe-Mejorado (`yI6CH5oYwBPGb6MhpEP4jv`)  
**App demo:** `http://127.0.0.1:8090/` · API `127.0.0.1:8001`  
**Código:** repo `control-mantenimiento-vehicular` · corte lunes 21 sep 2026 (noche)  
**Drive:** martes 22 sep 2026, 18:00 — 2 videos + este documento digital  
**Impreso:** carta + carátula + fastener/flip (no hojas sueltas)

**Límite ético:** vender solo lo que se ve en Figma, video e impreso.

---

# Documento A — Proceso y todos los flujos

## Antecedentes

Los dueños particulares enfrentan dos dolores: **olvidar** el mantenimiento que ya conocen (Carlos) y **desconocer** el que no sabían que existía (Mariana). Sin historial ni intervalos claros, actúan tarde: memoria, notas sueltas o el taller.

La oportunidad es una app que diga **qué toca**, permita **registrar**, consulte **historial** y **gastos**, y permita **ajustar intervalos** al uso real (happy path + validación IHC: texto + icono, no solo color).

## Los cinco flujos (numeración de Figma)

| # | Flujo | Figma | Código |
|---|---|---|---|
| 1 | Consultar qué mantenimiento toca | `02_Wireframes` + Clase 9 | `inicio.dart`, `mi_vehiculo.dart` |
| 2 | Registrar mantenimiento realizado | tira + Clase 9 | `registrar_mantenimiento.dart` |
| 3 | Consultar historial | tira + Clase 9 | `historial.dart`, `detalle_mantenimiento.dart` |
| 4 | Revisar cuánto gastó en el año | tira + Clase 9 | `gastos.dart`, `gastos_tipo.dart` |
| 5 | Ajustar intervalos a su uso intensivo | tira 6 pasos + Clase 9 | `plan_mantenimiento.dart`, `detalle_intervalo.dart`, `editar_intervalo.dart` |

> El login/acceso sigue en código como soporte de demo web, pero **no es el Flujo 5 de entrega**: en Figma ya no está. El Flujo 5 vendible es **intervalos / uso intensivo**.

## Flujo 1 — Consultar qué mantenimiento toca

**Pantallas en secuencia (Figma):** Abrir app → Ver mi vehículo → Actualizar km → Ver próximo → Consultar pendiente.

**Happy path:** Inicio muestra Honda CB 150, km actual y tarjetas con estado **VENCIDO / PROXIMO / AL DIA** (texto, no solo color). En Mi vehículo se actualiza el km y al volver se recalculan los próximos.

**Validación:** km vacío o menor/igual al último registrado (ej. 9.800 vs 12.500 en Figma) → mensaje “Debe ser mayor al ultimo registrado: …” + icono de error.

## Flujo 2 — Registrar mantenimiento realizado

**Pantallas:** Inicio con aceite vencido → Abrir registro → Completar datos → Guardar → Inicio al día.

**Happy path (venta / video):** tocar la tarjeta → km, fecha y costo → Guardar mantenimiento → Inicio actualizado.

**Validación:** km inválido y costo no numérico **en el campo** (texto + icono + borde). Fecha y Guardar son botones reales con nombre. Pill de estado con texto.

## Flujo 3 — Consultar historial

**Pantallas:** Inicio → Historial → Lista → Detalle (fecha, km, costo, próximo).

**Happy path:** lista de servicios hechos (pill HECHO) → detalle de un servicio.

**Validación / estado vacío:** mensaje + icono (flujo de consulta; no es formulario).

## Flujo 4 — Revisar cuánto gastó en el año

**Pantallas:** Inicio → Resumen Bs → Confirmar periodo/año → Rubro → Detalle.

**Happy path:** card “Gastos este año” → total → un rubro → detalle.

**Nota docente:** el brief v0.2 lo dejaba fuera; **Figma y código lo tienen**. Si se imprime, se puede vender.

## Flujo 5 — Ajustar intervalos a su uso intensivo

**Pantallas:** Inicio → Mi vehículo → Plan de mantenimiento → Detalle cambio de aceite (intervalo de fábrica) → Editar intervalo → Inicio con pendiente recalculado.

**Happy path:** bajar el aceite de fábrica (ej. 4.000 km) a **3.000 km** por uso intensivo → guardar → Inicio recalcula el pendiente.

**Validaciones (texto + icono, no solo color):**
1. Intervalo vacío  
2. No es un número (`abc`)  
3. Menor al mínimo (500 km)  
4. Igual al de fábrica cuando se pedía bajarlo  
5. Guardado con éxito (3.000 km)

---

# Documento B — Solución y sus razones

## Qué es

App móvil que registra el mantenimiento, calcula el **próximo por kilometraje**, muestra historial y gastos, y permite **ajustar intervalos** al uso real del vehículo.

## Para quién

**Mariana** (25, delivery, Honda CB 150): la moto es su ingreso; actúa cuando “suena feo”.  
**Carlos** (35, Corolla 2019): sabe que debe mantener, pero pierde km/fechas y desconfía del taller.

## Valor

Dejar de depender de memoria/notas. Anticipar el servicio. Historial como respaldo frente al taller. Ahorro: **prevenir vs reparar**. Intervalos alineados al uso intensivo, no a “creo que hace tres meses”.

## Decisiones defendidas con la investigación

### 1. Bs 20 vs Bs 350 (Mariana)

Mariana gastó ~**Bs 350** en cadena/piñón por no lubricar a tiempo. El lubricante preventivo cuesta ~**Bs 20** (≈ **17×** más cara la reparación). Por eso la app prioriza **qué toca ahora** (Flujo 1) y **registrar** lo hecho (Flujo 2), no solo un historial pasivo.

### 2. Intervalos mal estimados (Carlos)

Carlos creía aceite cada **10.000 km**; su Corolla lo necesita cada **~5.000 km**. Sobreestimar = el doble de km sin servicio. La app calcula próximos por **intervalos de km por tipo** y permite **ajustarlos** (Flujo 5).

### 3. Olvidar vs desconocer

Carlos = olvido informado. Mariana = desconocimiento reactivo. Por eso no basta “anotar”: hay que **mostrar estados** (VENCIDO / PROXIMO / AL DIA) y permitir registrar costo/historial.

### 4. Transparencia frente al taller (Carlos)

Sin comprobantes detallados, el historial en app es la evidencia de qué se hizo y a qué km.

## Qué no se vende

Autenticación contra servidor como flujo de entrega · push · multi-vehículo · IA · Play Store si no está publicado · “editar vehículo” · Performance del canvas Flutter como 100 (se vende el shell HTML si aplica).

---

# Artefacto pequeño de accesibilidad

**App:** Control de mantenimiento vehicular  
**Fecha:** 20 sep 2026  
**URL:** `http://127.0.0.1:8090/` (Flutter web + API `127.0.0.1:8001`)  
**Pantallas auditadas:** Inicio (Flujo 1), Registrar servicio (Flujo 2); bienvenida HTML si se usa shell  
**Figma:** `yI6CH5oYwBPGb6MhpEP4jv` (Clase 9 ya tenía error de km con texto+icono)  
**Fórmula por barrera:** observación → impacto → corrección → prueba posterior

> **Regla:** el scan es evidencia de una revisión, no una nota ni un certificado. La evidencia sale de **esta** app, no de la demo de clase.

## Color (WCAG 1.4.1 / 1.4.3)

El color orienta; el significado no depende solo de él. Prueba: **quitar el color** → VENCIDO / PROXIMO / AL DIA siguen legibles en texto.

| Par medido | Ratio | AA 4.5:1 |
|---|---|---|
| `#5A6663` muted / blanco | 5.97:1 | Pasa |
| `#C93D3D` error / blanco | 4.98:1 | Pasa |
| `#8A4F00` PROXIMO / blanco | 6.56:1 | Pasa |
| `#00695C` teal / blanco | 6.61:1 | Pasa |

## Barrera 1 — idioma de la página

**Criterio:** WCAG 3.1.1 Language of Page  
**Contexto:** Flujo 1–2 en Flutter web · `main.dart` + `web/index.html` · 20 sep 2026.

**Observación:** `lang` quedaba en inglés aunque el HTML decía `es` (Flutter pisaba el locale).

**Impacto:** el lector pronunciaba kilometraje, vencido y bolivianos con reglas de inglés.

**Corrección:** `MaterialApp` con `locale: Locale('es')` + `flutter_localizations`; título correcto.

**Prueba posterior:** `lang="es"`; nav en español (“Pestaña”, no “Tab”).

## Barrera 2 — Registrar servicio sin nombres reales

**Criterios:** 1.3.1 · 4.1.2 · 3.3.1  
**Contexto:** Flujo 2 · `registrar_mantenimiento.dart` · axe-core 4.10.2.

**Observación:** km/costo/fecha/guardar sin rol/nombre claro; error de costo en SnackBar suelto.

**Impacto:** sin estilos no se sabía qué campo llenar ni qué corregir (falla IHC del docente).

**Corrección:** `MergeSemantics`; error de costo **en el campo** (texto+icono); fecha y Guardar como botones reales.

**Prueba posterior:** axe **0 violaciones**; foco teal 2 px en km; árbol con textbox/button nombrados.

## Barrera 3 — tarjetas de Inicio invisibles para teclado/AT

**Criterios:** 2.1.1 · 2.4.3 · 4.1.2 · 1.4.1  
**Contexto:** Flujo 1–2 · `inicio.dart`.

**Observación:** el árbol solo exponía las pestañas; las tarjetas no existían para AT/teclado.

**Impacto:** no se podía abrir Registrar (Flujo 2 de venta) con teclado ni lector.

**Corrección:** tarjetas como `TextButton`; quitar overlay “Cargando” que tapaba.

**Prueba posterior:** botones con nombre incluyen VENCIDO/PROXIMO/AL DIA; Enter abre el registro.

## Reportes: tres hallazgos interpretados (no el puntaje)

1. **WAVE — Possible heading (bienvenida HTML):** textos en negrita parecían títulos sin serlo. **Interpretación:** mala estructura de headings. **Corrección:** pasaron a `h2`. **Re-prueba:** alertas eliminadas.
2. **WAVE — No page regions (Inicio Flutter):** no había landmarks. **Interpretación:** no se podía saltar a contenido/navegación. **Corrección:** `SemanticsRole.main` / `navigation`. **Re-prueba:** regiones presentes.
3. **Lighthouse / axe — error no asociado al campo (Registrar, antes):** costo inválido en SnackBar. **Interpretación:** falla 3.3.1. **Corrección:** error en el campo. **Re-prueba:** axe 0; Lighthouse Accessibility del shell HTML en 100 (evidencia de revisión IHC; el canvas Flutter no se vende como Performance 100).

## Interacción (navegador, no lienzo Figma)

| Acción | Qué se verificó |
|---|---|
| Tab / Shift+Tab | Recorre campos de Registrar; orden lógico |
| Enter | Activa tarjeta de mantenimiento → abre Registrar |
| Escape | Cierra el date picker de fecha del servicio |
| Foco visible | Campo km: borde teal 2 px (no se oculta) |
| Zoom | Etiquetas encima del campo; layout en columna |
| Lectura | `lang=es`; headings; botones/textboxes con nombre |

En Figma solo se dibuja la **intención** del foco (Clase 9); la prueba real es en el navegador.

---

# Cómo grabar, imprimir y exponer

1. **Video Figma (2–3 min):** al menos dos flujos (recomendado: Flujo 2 + Flujo 5 intervalos). No navegar Figma en vivo el día de la expo.
2. **Video app:** Flujos 1–5 corriendo; en Flujo 5 mostrar un error de intervalo + happy path a 3.000 km.
3. **Oral ≤ 5 min:** problema → oportunidad → solución → valor → investigación (Bs 20/350, intervalos 10.000 vs 5.000) → play videos. Un expositor.
4. **Code roulette:** validación km, error de costo en campo, cálculo de próximo, edición de intervalo.

---

*Documento digital para Drive · Clase 10 · Control de mantenimiento vehicular*
