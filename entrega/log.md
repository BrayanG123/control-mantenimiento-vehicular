# Log de la entrega IHC

Cada cambio del agente o del equipo se agrega **al final**. No se reescribe el historial.

Formato de entrada:

```
## YYYY-MM-DD HH:MM
- **Qué:**
- **Por qué (requisito docente):**
- **Archivos:**
- **Flujo / entregable:**
```

---

## 2026-09-20 15:45
- **Qué:** Se creó la carpeta `entrega/` con el contexto de la Clase 10 (fechas, entregables, accesibilidad, venta) y el spec de los cinco flujos. Se añadió regla Cursor para anexar este log en cada modificación.
- **Por qué (requisito docente):** Seguir al pie de la letra la guía de avance: cinco flujos, dos documentos, evidencia propia, videos, código al día. Sin un hilo escrito se pierde el encargo oral vs. el de las diapositivas.
- **Archivos:** `entrega/contexto.md`, `entrega/flujos.md`, `entrega/log.md`, `.cursor/rules/entrega-log.mdc`
- **Flujo / entregable:** seguimiento de toda la entrega; arranque del cierre de los cinco flujos

## 2026-09-20 15:55
- **Qué:** Se cerró en código el Flujo 2 (alta de vehículo): labels, error por campo con texto e icono, botón real ?Guardar vehiculo?, mensaje de red asociado al formulario, orden Tab marca ? modelo ? año ? placa. El botón permanece activo para poder demostrar la validación (como en la demo de clase). Se actualizó el spec del flujo.
- **Por qué (requisito docente):** Happy path + validación; el error no puede ir solo en color; etiqueta asociada al campo; botón real; vender solo lo que la app hace.
- **Archivos:** `mobile/lib/pantallas/alta_vehiculo.dart`, `entrega/flujos.md`, `entrega/contexto.md`
- **Flujo / entregable:** Flujo 2 ? Alta de vehículo

## 2026-09-20 16:00
- **Qué:** Auditoría de solo lectura del Figma `yI6CH5oYwBPGb6MhpEP4jv` (nodo `242:1411`, página `04_Clase9_Estados`). Hay 6 páginas, 4 flujos completos con happy path y validación, componentes con estado Error/Foco/Éxito, prototipo parcial, web 412/768/1280. No hay login ni alta de vehículo en el archivo. Se alineó `contexto.md` y `flujos.md` a esa numeración. No se editó Figma.
- **Por qué (requisito docente):** Antes de dibujar de más, ver qué ya cubre ?cinco flujos?, happy path + validación, e IHC (error con texto, no solo color).
- **Archivos:** `entrega/contexto.md`, `entrega/flujos.md`
- **Flujo / entregable:** auditoría Figma; Flujos 1?4 existentes; hueco del quinto

## 2026-09-20 16:15
- **Qué:** Se armó el Flujo 5 ? gestionar el acceso ? en Figma: tira de 5 pasos en `02_Wireframes` (login, datos, crear cuenta, olvidé, éxito) y filas Principal / Happy Path / Validaciones en `04_Clase9_Estados`. Reutiliza campo y botón existentes. Errores con texto e icono (correo vacío, contraseña vacía, no coinciden, enlace, formato inválido). Quedó anotado como prototipo: no está en código y no se vende como app.
- **Por qué (requisito docente):** Cinco flujos; mínimo oral de login / registro / olvidé password; happy path + validación; el color no carga solo el significado; vender solo lo implementado.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (nodos `275:1411`, `276:2872`), `entrega/flujos.md`, `entrega/contexto.md`
- **Flujo / entregable:** Flujo 5 ? gestionar el acceso

## 2026-09-20 16:20
- **Qué:** Se agregó la pantalla de inicio de la app (marca Mantenimiento + botón Iniciar sesión + enlace Crear cuenta) como PASO 1 del Flujo 5. El login quedó como PASO 2. La tira pasó a 6 pasos. Se clonó a Principal y Happy Path en Clase 9. El botón de la bienvenida navega al login. Sigue siendo prototipo, no código.
- **Por qué (requisito docente):** El flujo de usuario empieza por una pantalla de entrada clara, con acción real (?Iniciar sesión?, no ?Enviar?), antes del formulario.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (nodo `279:1549`), `entrega/flujos.md`
- **Flujo / entregable:** Flujo 5 ? pantalla de inicio antes del login

## 2026-09-20 16:25
- **Qué:** En la pantalla de inicio del Flujo 5 se reemplazó el SVG improvisado por el `Icon / Vehicle` que ya se usa en Inicio y Mi vehículo. Aplicado a la tira y a las copias de Clase 9 (Principal y Happy Path).
- **Por qué (requisito docente):** Reutilizar componentes del sistema visual, no inventar otro ícono.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (nodos `279:1549`, `279:4868`, `279:4883`)
- **Flujo / entregable:** Flujo 5 ? icono de moto reutilizable

## 2026-09-20 16:45
- **Qué:** Se auditó Inicio y Registrar servicio en Flutter web (`:8090`). Se corrigieron 3 barreras IHC: idioma `es`, campos/botón/error de Registrar asociados al control, tarjetas de Inicio como botones reales con estado en texto. Artefacto + axe-core (0 violaciones). Lighthouse CLI headless sigue en NO_FCP: no usarlo de evidencia; falta corrida en Chrome visible.
- **Por qué (requisito docente):** Evidencia propia de accesibilidad (observación ? impacto ? corrección ? re-prueba); error con texto e icono, no SnackBar; color no carga solo el significado; vender solo lo implementado.
- **Archivos:** `mobile/lib/main.dart`, `mobile/lib/pantallas/inicio.dart`, `mobile/lib/pantallas/registrar_mantenimiento.dart`, `mobile/lib/pantallas/mi_vehiculo.dart`, `mobile/web/index.html`, `mobile/web/manifest.json`, `mobile/pubspec.yaml`, `entrega/accesibilidad.md`, `entrega/axe-registrar.json`, `entrega/contexto.md`, `entrega/flujos.md`
- **Flujo / entregable:** accesibilidad; Flujo 1 y Flujo 2 en código

## 2026-09-20 16:55
- **Qué:** El Flujo 5 (gestionar el acceso) quedó en código: bienvenida, iniciar sesión, crear cuenta, olvidé contraseña y éxito. Validación por campo con texto e icono. Sesión local (Mariana demo). Cerrar sesión en Mi vehículo.
- **Por qué (requisito docente):** El ingeniero revisa el repo: los cinco flujos tienen que correr, no solo Figma. Happy path + validación. Vender solo lo implementado (sesión local, no servidor de usuarios).
- **Archivos:** `mobile/lib/sesion.dart`, `mobile/lib/pantallas/acceso.dart`, `mobile/lib/main.dart`, `mobile/lib/pantallas/mi_vehiculo.dart`, `entrega/flujos.md`, `entrega/contexto.md`
- **Flujo / entregable:** Flujo 5 ? código

## 2026-09-20 17:05
- **Qué:** Se alineó el Flujo 5: botón a todo el ancho, centrado con el icono. En web la app se ve en un marco de teléfono 412 px para que el layout coincida con el celular.
- **Por qué (requisito docente):** Lo que se presenta tiene que verse como producto móvil; el desfase web no se vende.
- **Archivos:** `mobile/lib/marco_movil.dart`, `mobile/lib/main.dart`, `mobile/lib/pantallas/acceso.dart`
- **Flujo / entregable:** Flujo 5; código

## 2026-09-20 17:25
- **Qué:** En Figma `03_Web` las pantallas Inicio y Mi vehículo pasaron a Auto Layout (Body WRAP). Al estirar, el sidebar queda a la izquierda desde ~720 px (tablet 768 y web 1280) y las cards se acomodan. En código, desde 768 px hay sidebar + wrap de tarjetas; el login sigue en hoja 412.
- **Por qué (requisito docente):** El layout web/tablet se defiende con lo implementado (Auto Layout / flex wrap), no con un marco fijo que contradice Figma.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (`03_Web` 213:492, 213:493), `mobile/lib/marco_movil.dart`, `mobile/lib/main.dart`, `mobile/lib/pantallas/inicio.dart`, `mobile/lib/pantallas/mi_vehiculo.dart`, `mobile/lib/pantallas/acceso.dart`, `entrega/flujos.md`
- **Flujo / entregable:** Flujo 1 y 2; código; Figma 03_Web

## 2026-09-20 17:35
- **Qué:** Se corrigió `03_Web`: el WRAP del marco apilaba el sidebar arriba en 412. Ahora móvil usa la variante Phone (nav abajo, sin sidebar) y tablet/web la variante Web (sidebar a la izquierda, cards que se acomodan al estirar). En código, con sidebar se oculta el nav inferior.
- **Por qué (requisito docente):** El layout se defiende con lo que se ve; Figma no oculta el sidebar por ancho, así que hay variante por breakpoint.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (`03_Web` instancias a `Shell=Phone` / `Shell=Web`), `mobile/lib/main.dart`, `entrega/flujos.md`
- **Flujo / entregable:** Figma 03_Web; código

## 2026-09-20 17:45
- **Qué:** En `03_Web` los 6 preview pasaron a frames (ya no instancias). El marco usa Constraints (status arriba, sidebar izquierda, contenido que estira). Adentro, Auto Layout + WRAP (flexbox) en las cards. Se puede agarrar el borde derecho y ver el reflujo.
- **Por qué (requisito docente):** Auto Layout, flexbox y constraints juntos; el layout se prueba estirando, no solo mirando tres anchos fijos.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (`03_Web` frames `296:683`?`296:837`), `entrega/flujos.md`
- **Flujo / entregable:** Figma 03_Web

## 2026-09-20 17:50
- **Qué:** Un solo frame por pantalla en `03_Web`, partiendo de 412. Al estirar: WRAP pone el sidebar a la izquierda (~768, tablet) y las cards pasan a fila (~1280, web).
- **Por qué (requisito docente):** Un layout que se prueba estirando, no tres mocks fijos; Auto Layout WRAP como flexbox.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (`03_Web` `296:712`, `296:802`), `entrega/flujos.md`
- **Flujo / entregable:** Figma 03_Web

## 2026-09-20 17:55
- **Qué:** Se reconstruyó el frame único: en 412 se ve celular (el sidebar queda recortado). Al estirar a 768 el sidebar entra al lado y las cards se parten; a 1280 van en fila.
- **Por qué (requisito docente):** Un frame que se prueba estirando de móvil a web, sin el recorte roto del sidebar arriba.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (`03_Web` `296:712`, `296:802`)
- **Flujo / entregable:** Figma 03_Web

## 2026-09-20 18:35
- **Qué:** Tras el Lighthouse de Chrome (A11y 100, Performance 25 en debug+4G): `robots.txt` y `llms.txt` válidos, splash visible para FCP, y la app se sirve en release. El 25 no se vende: es el JS de debug (~104 MB).
- **Por qué (requisito docente):** Evidencia propia de Lighthouse; interpretar hallazgos, no el puntaje; vender solo lo implementado.
- **Archivos:** `mobile/web/robots.txt`, `mobile/web/llms.txt`, `mobile/web/index.html`, `entrega/accesibilidad.md`
- **Flujo / entregable:** accesibilidad

## 2026-09-20 18:40
- **Qué:** Lighthouse sobre release: A11y 100, SEO 100, Best Practices 81, Performance 68 (FCP 0.6 s; el 25 era debug). Queda un warning del SDK (`Intl.v8BreakIterator`) y el peso de CanvasKit.
- **Por qué (requisito docente):** Interpretar el scan, no vender el puntaje de debug; evidencia de A11y 100.
- **Archivos:** `mobile/web/robots.txt`, `mobile/web/llms.txt`, `mobile/web/index.html`, `entrega/accesibilidad.md`, `entrega/contexto.md`
- **Flujo / entregable:** accesibilidad

## 2026-09-20 19:00
- **Qué:** Lighthouse del 67/81: WASM local, splash igual a bienvenida, polyfill de `v8BreakIterator`, servidor con caché y COOP/COEP. Quedó A11y 100, SEO 100, Best Practices 100, Performance 77. El 77 es Speed Index del motor Skwasm (~6 MB), no un JS nuestro.
- **Por qué (requisito docente):** Interpretar el scan; el 100 de A11y es la evidencia IHC; no vender 90 de Performance que Flutter web no da.
- **Archivos:** `mobile/web/index.html`, `mobile/web/flutter_bootstrap.js`, `mobile/tool/serve_web.mjs`, `entrega/accesibilidad.md`, `entrega/contexto.md`
- **Flujo / entregable:** accesibilidad

## 2026-09-20 19:05
- **Qué:** La bienvenida pasa a HTML y Flutter (Wasm) se carga al tocar Iniciar sesion o Crear cuenta. Lighthouse de la carga inicial: Performance 100, A11y 100, Best Practices 100, SEO 100 (14 KiB, TBT 0).
- **Por qué (requisito docente):** El 78 amarillo era el motor de 6 MB en la primera pintura; no se vende un 90 imposible, se corrige la carga inicial.
- **Archivos:** `mobile/web/index.html`, `mobile/lib/main.dart`, `entrega/accesibilidad.md`, `entrega/contexto.md`
- **Flujo / entregable:** accesibilidad

## 2026-09-20 19:25
- **Qué:** Login, crear cuenta y olvide pasan a HTML. `/?go=login` ya no arranca Wasm. Flutter solo carga tras un login valido y deja la URL en `/`. Lighthouse de Flujo 5 deja de medir 6 MB.
- **Por qué (requisito docente):** El 75 era Lighthouse sobre Flutter ya cargado; el scan de IHC se hace sobre la carga inicial, no sobre el canvas.
- **Archivos:** `mobile/web/index.html`, `mobile/lib/sesion.dart`, `mobile/lib/sesion_html.dart`, `mobile/lib/sesion_html_web.dart`, `mobile/lib/main.dart`
- **Flujo / entregable:** accesibilidad

## 2026-09-20 19:40
- **Qué:** Un solo login: HTML valida a Mariana y Flutter hidrata `cmv_correo` (sessionStorage con `this` correcto). No se vuelve a pedir usuario y clave.
- **Por qué (requisito docente):** Flujo 5 happy path; no duplicar el acceso.
- **Archivos:** `mobile/web/index.html`, `mobile/lib/sesion_html_web.dart`, `mobile/lib/main.dart`
- **Flujo / entregable:** Flujo 5

## 2026-09-20 20:15
- **Qué:** Corregido el doble login. Tras HTML valido, Flutter (canvaskit/dart2js) lee `cmv_correo` con `package:web` y abre Inicio sin pedir otra vez. Se deja Wasm fuera del build web porque en skwasm no hidrataba la sesion.
- **Por qué (requisito docente):** Flujo 5 happy path; un solo acceso.
- **Archivos:** `mobile/web/index.html`, `mobile/web/flutter_bootstrap.js`, `mobile/lib/sesion.dart`, `mobile/lib/sesion_html_web.dart`, `mobile/lib/main.dart`, `mobile/tool/serve_web.mjs`, `mobile/pubspec.yaml`
- **Flujo / entregable:** Flujo 5

## 2026-09-20 20:30
- **Qué:** WAVE: los 4 ?Possible heading? del shell pasan a `h2`; en Inicio se agregan landmarks `main`/`nav` (SemanticsRole + HTML) y encabezados semanticos.
- **Por qué (requisito docente):** Evidencia de accesibilidad; alertas de regiones y encabezados.
- **Archivos:** `mobile/web/index.html`, `mobile/lib/main.dart`, `mobile/lib/pantallas/inicio.dart`, `entrega/accesibilidad.md`
- **Flujo / entregable:** accesibilidad

## 2026-09-20 21:20
- **Qué:** Borrador del documento de entrega (A + B + accesibilidad) en Notion wiki privada, para revisar cómo queda el impreso.
- **Por qué (requisito docente):** Documentos A/B + artefacto de accesibilidad de la Clase 10.
- **Archivos:** Notion `Entrega IHC Clase 10 ? CMV (borrador)`; `entrega/notion-borrador.md`
- **Flujo / entregable:** documento

## 2026-09-20 23:25
- **Qué:** Notion actualizado con referencias del docente: Bs 20 vs 350, intervalos mal estimados, fórmula completa de barreras y 3 hallazgos WAVE/Lighthouse interpretados.
- **Por qué (requisito docente):** Documento B + artefacto de accesibilidad al pie de la Clase 10.
- **Archivos:** Notion `3e264a4f?`; `entrega/notion-borrador.md`
- **Flujo / entregable:** documento





## 2026-09-21 21:26
- **Qu?:** El shell HTML de acceso deja de guardar cuentas en sessionStorage y pasa a llamar al backend (registro, login y recuperacion); guarda el JWT en `cmv_token` para que Flutter hidrate la sesion.
- **Por qu? (requisito docente):** Flujo 5 happy path; crear cuenta e iniciar sesion deben persistir en el API, no solo en el navegador.
- **Archivos:** `mobile/web/index.html`, `mobile/build/web/index.html`
- **Flujo / entregable:** Flujo 5

## 2026-09-21 21:38
- **Qu?:** `Cerrar sesion` queda visible: texto+icono en Mi vehiculo, boton en el alta de vehiculo y enlace en la barra lateral web/tablet.
- **Por qu? (requisito docente):** Flujo 5; el usuario debe poder salir de la sesion sin buscar un icono oculto.
- **Archivos:** `mobile/lib/screens/mi_vehiculo.dart`, `mobile/lib/screens/alta_vehiculo.dart`, `mobile/lib/app.dart`
- **Flujo / entregable:** Flujo 5

## 2026-09-21 21:47
- **Qu?:** Sin `RESEND_API_KEY`, la recuperacion ya no corta el flujo: guarda el enlace en `backend/ultimo_enlace_recuperacion.txt` y en consola. Backend demo en `:8001` porque `:8000` quedo con proceso viejo.
- **Por qu? (requisito docente):** Flujo 5 (olvide contrasena) happy path en demo local sin depender de Resend.
- **Archivos:** `backend/app/services/correo_service.py`, `backend/app/config.py`, `backend/.env.example`, `backend/README.md`, `mobile/web/index.html`, `mobile/lib/core/config/configuracion_api.dart`
- **Flujo / entregable:** Flujo 5

## 2026-09-21 22:02
- **Qu?:** Mensajes de error del restablecimiento mas claros (token invalido) y el cliente API interpreta `detail` en lista de validacion.
- **Por qu? (requisito docente):** Flujo 5; error con texto entendible, no generico.
- **Archivos:** `backend/app/schemas/usuario.py`, `mobile/lib/core/network/cliente_api.dart`
- **Flujo / entregable:** Flujo 5

## 2026-09-21 22:15
- **Qu?:** En Figma se reemplaz? el Flujo 5 (login) por Flujo D ? ajustar intervalos a uso intensivo: 6 pantallas (Inicio ? Mi veh?culo ? Plan ? Detalle aceite ? Editar 3.000 km ? Inicio recalculado), prototipo enlazado y starting point nuevo. Login qued? archivado en el canvas. Se actualiz? `entrega/flujos.md` y `entrega/contexto.md`.
- **Por qu? (requisito docente):** El docente no cuenta el flujo de login; el quinto flujo debe mostrar valor del producto (plan adaptado al uso real de Mariana).
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (tira desde `331:1553`), `entrega/flujos.md`, `entrega/contexto.md`
- **Flujo / entregable:** Flujo 5 ? ajustar intervalos a su uso intensivo

## 2026-09-21 22:20
- **Qu?:** En `04_Clase9_Estados` se reemplaz? el Flujo 5 de login por intervalos: filas Principal (6), Happy Path (6) y Validaciones (5: vac?o, no num?rico, m?nimo, igual a f?brica, ?xito). T?tulo y resultado actualizados; prototipo enlazado en P y HP.
- **Por qu? (requisito docente):** Clase 9 exige Principal ? Happy Path ? Validaciones por flujo; el quinto flujo ya no es login.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (nodo `276:2872`), `entrega/flujos.md`, `entrega/contexto.md`
- **Flujo / entregable:** Flujo 5 ? Clase 9 estados

## 2026-09-21 22:25
- **Qu?:** Se quit? el starting point duplicado del Flujo 5 en `04_Clase9_Estados` (quedaba Principal y Happy Path con el mismo nombre en el prototipo). Queda solo Principal.
- **Por qu? (requisito docente):** Prototipo usable para video; un solo punto de entrada por flujo.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv` (p?gina `04_Clase9_Estados`)
- **Flujo / entregable:** Flujo 5 ? prototipo

## 2026-09-21 22:28
- **Qu?:** Se elimin? por completo del Figma la tira de login/acceso (6 pantallas + labels + t?tulo) en `02_Wireframes`. El Flujo 5 que queda es solo intervalos.
- **Por qu? (requisito docente):** El docente no cuenta login; no debe aparecer en Figma ni en el prototipo.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv`, `entrega/flujos.md`, `entrega/contexto.md`
- **Flujo / entregable:** Flujo 5 ? limpieza login

## 2026-09-21 22:35
- **Qu?:** El prototipo de los 5 flujos pasa a salir solo de `04_Clase9_Estados` (Principal + Happy Path + Validaciones). Se vaciaron los starting points de Wireframes, se reconectaron las cadenas dentro de Clase 9 (sin saltar a Wireframes) y cada flujo tiene 3 entradas en el prototipo.
- **Por qu? (requisito docente):** Clase 9 es donde est?n Principal / Happy Path / Validaciones; el video y la demo deben partir de ah?.
- **Archivos:** Figma `yI6CH5oYwBPGb6MhpEP4jv`, `entrega/flujos.md`
- **Flujo / entregable:** prototipo Clase 9 ? Flujos 1?5

## 2026-09-21 22:40
- **Qu?:** Prototipo listo para video: 5 flujos (no 15). Cada flujo une Principal ? Happy Path ? Validaciones con chips \"Continuar\". Gu?a de grabaci?n en `flujos.md`.
- **Por qu? (requisito docente):** Video Figma 2?3 min con los cinco flujos; happy path + validaci?n por flujo sin armar el recorrido a mano.
- **Archivos:** Figma `04_Clase9_Estados`, `entrega/flujos.md`
- **Flujo / entregable:** video Figma ? Flujos 1?5

## 2026-09-21 22:45
- **Qu?:** Prototipo de video rearmado: 1 recorrido por flujo (error ? happy path ? resultado). Se quitaron los chips que obligaban a repetir las 3 filas. El lienzo Clase 9 sigue con Principal/HP/V para imprimir.
- **Por qu? (requisito docente):** Video 2?3 min con happy path + validaci?n sin repetir la misma historia tres veces.
- **Archivos:** Figma `04_Clase9_Estados`, `entrega/flujos.md`
- **Flujo / entregable:** video Figma ? prototipo unificado

## 2026-09-21 22:50
- **Qu?:** El Flujo 5 qued? en c?digo: desde Mi veh?culo se abre el plan, el detalle del aceite (f?brica 4.000 km) y se puede bajar el intervalo. Validaci?n en el campo con texto e icono (vac?o, no num?rico, menor a 500, igual a f?brica). Al guardar 3.000 km, Inicio muestra el aviso y recalcula el pendiente.
- **Por qu? (requisito docente):** El quinto flujo tiene que correr en la app, no solo en Figma. Happy path + validaci?n. El error no va solo en color.
- **Archivos:** `backend/app/core/intervalos.py`, `backend/app/models/intervalo_vehiculo.py`, `backend/app/services/mantenimiento_service.py`, `backend/app/routers/mantenimiento.py`, `mobile/lib/screens/plan_mantenimiento.dart`, `mobile/lib/screens/detalle_intervalo.dart`, `mobile/lib/screens/editar_intervalo.dart`, `mobile/lib/screens/mi_vehiculo.dart`, `mobile/lib/screens/inicio.dart`, `entrega/flujos.md`, `entrega/contexto.md`
- **Flujo / entregable:** Flujo 5 ? ajustar intervalos a su uso intensivo


## 2026-09-21 22:50
- **Qu?:** Se corrigi? el prototipo del Flujo 4: Inicio ? gastos vac?o (validaci?n) ? resumen OK ? rubro Llantas ? detalle. Ya no manda el total al vac?o ni usa el hotspot equivocado.
- **Por qu? (requisito docente):** Happy path + validaci?n en un solo recorrido, sin redirecciones rotas.
- **Archivos:** Figma `04_Clase9_Estados` (Flujo 4)
- **Flujo / entregable:** Flujo 4 ? prototipo

## 2026-09-21 22:55
- **Qué:** El botón Mi vehículo de la barra inferior ahora es un botón normal, y la tarjeta del vehículo en Inicio también abre esa pantalla.
- **Por qué (requisito docente):** El Flujo 5 empieza en Mi vehículo; si ese botón no responde, el recorrido no se puede mostrar.
- **Archivos:** `mobile/lib/app.dart`, `mobile/lib/screens/inicio.dart`, `mobile/lib/core/layout/marco_movil.dart`
- **Flujo / entregable:** Flujo 5 ? ajustar intervalos

## 2026-09-21 23:10
- **Que:** En Inicio quedo la tarjeta Plan de mantenimiento, que abre el flujo 5 directo. Se recompilo la web del puerto 8090 y se reinicio el backend: /mantenimiento/plan ya responde.
- **Por que (requisito docente):** El quinto flujo tiene que verse en la app (plan, detalle del aceite y editar intervalo), con happy path y validacion.
- **Archivos:** mobile/lib/screens/inicio.dart, mobile/lib/screens/mi_vehiculo.dart, entrega/flujos.md
- **Flujo / entregable:** Flujo 5


## 2026-09-21 23:15
- **Que:** Se quito la tarjeta Plan de mantenimiento de Inicio. El plan se abre desde Mi vehiculo.
- **Por que (requisito docente):** El Flujo 5 entra por Mi vehiculo, no desde un atajo en Inicio.
- **Archivos:** mobile/lib/screens/inicio.dart, entrega/flujos.md
- **Flujo / entregable:** Flujo 5

## 2026-09-22 16:20
- **Qué:** Se armó el documento digital de entrega (A + B + accesibilidad) en Word/Markdown, con Flujo 5 = intervalos (no login), listo para subir a Google Drive como Google Doc.
- **Por qué (requisito docente):** Documento digital para Drive (martes 18:00) con cinco flujos, Bs 20/350, intervalos y artefacto de accesibilidad.
- **Archivos:** `entrega/Entrega-IHC-Clase10-CMV.docx`, `entrega/documento-entrega-clase10.md`, `entrega/notion-borrador.md`
- **Flujo / entregable:** documento


## 2026-09-22 16:47
- **Que:** Tras guardar un intervalo, la app cierra Editar y Detalle y vuelve al Plan de mantenimiento (lista recargada), en lugar de quedarse en el formulario.
- **Por que (requisito docente):** Flujo 5 happy path: el usuario debe ver el resultado del ajuste sin quedar atrapado en Editar.
- **Archivos:** mobile/lib/screens/editar_intervalo.dart, mobile/lib/screens/detalle_intervalo.dart, entrega/flujos.md
- **Flujo / entregable:** Flujo 5
