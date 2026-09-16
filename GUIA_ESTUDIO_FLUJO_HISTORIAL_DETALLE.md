# Guía de estudio: del historial al detalle de un servicio

## 1. Alcance de esta guía

Esta guía explica el recorrido de frontend que comienza cuando el usuario toca el icono de historial en la pantalla de inicio y termina cuando observa el detalle de un mantenimiento ya guardado.

El proyecto móvil está hecho con **Flutter/Dart**, usa widgets de **Material 3**, realiza peticiones HTTP con el paquete `http` y administra el estado con `StatefulWidget` + `setState`. No utiliza Provider, Riverpod, BLoC, Redux ni otro gestor de estado externo.

El recorrido principal es:

```text
InicioPantalla
  -> toque en IconButton(Icons.history)
  -> Navigator.push(HistorialPantalla)
  -> initState() llama a cargar()
  -> obtenerHistorial() hace GET /mantenimiento/historial
  -> JSON se convierte en List<Mantenimiento>
  -> setState actualiza la interfaz
  -> usuario toca una fila (InkWell)
  -> Navigator.push(DetalleMantenimientoPantalla)
  -> se pasa el objeto Mantenimiento completo
  -> el detalle formatea y presenta sus datos
```

> Hallazgo importante: en el frontend móvil revisado no existe una función para registrar un mantenimiento. La API backend sí tiene `POST /mantenimiento/`, pero `mobile/lib/api.dart` solo consulta el historial. Por eso este flujo muestra servicios ya existentes en el backend, pero no explica cómo se crearon desde la app.

---

## 2. Qué archivos estudiar y en qué orden

### Nivel 1: recorrido obligatorio

Estudia estos archivos completos en este orden:

1. `mobile/lib/pantallas/inicio.dart`
   - Líneas 3-5: dependencias del flujo.
   - Líneas 54-59: método `abrirHistorial()`.
   - Líneas 93-106: botón que inicia la interacción.
   - Objetivo: explicar cómo una acción del usuario abre una nueva ruta.

2. `mobile/lib/pantallas/historial.dart`
   - Estudiar el archivo completo.
   - Líneas 10-20: widget y variables de estado.
   - Líneas 22-48: ciclo de vida y carga asíncrona.
   - Líneas 50-57: navegación al detalle.
   - Líneas 59-123: selección de carga, error, vacío o contenido.
   - Líneas 125-161: estado vacío.
   - Líneas 163-218: fila interactiva de un servicio.
   - Objetivo: dominar la gestión del estado y la reacción visual.

3. `mobile/lib/api.dart`
   - Líneas 7-13: URL base y petición GET.
   - Líneas 90-98: `obtenerHistorial()`.
   - Objetivo: seguir los datos desde HTTP hasta los modelos de Dart.

4. `mobile/lib/modelos.dart`
   - Líneas 56-85: clase `Mantenimiento` y `fromJson`.
   - Objetivo: saber qué datos recibe la interfaz y cómo se convierten.

5. `mobile/lib/pantallas/detalle_mantenimiento.dart`
   - Estudiar el archivo completo.
   - Líneas 8-15: recepción del objeto seleccionado.
   - Líneas 17-69: estructura general de la pantalla.
   - Líneas 72-122: tarjeta resumen.
   - Líneas 124-147: componente local para cada dato.
   - Objetivo: explicar por qué esta pantalla no necesita estado propio.

### Nivel 2: presentación y reutilización

6. `mobile/lib/tema.dart`
   - Contiene los colores reutilizados y la sombra de las tarjetas.

7. `mobile/lib/componentes.dart`
   - Contiene `PillEstado`, la etiqueta redondeada que muestra `HECHO`.

8. `mobile/lib/formato.dart`
   - Convierte valores técnicos en textos legibles para el usuario.

### Nivel 3: contexto arquitectónico

9. `mobile/lib/main.dart`
   - Líneas 7-24: arranque, `MaterialApp` y tema Material 3.
   - Líneas 35-65: estado inicial de la aplicación.
   - Líneas 117-143: pantalla de inicio dentro de la navegación inferior.

10. `mobile/pubspec.yaml`
    - Líneas 30-37: dependencias principales (`flutter` y `http`).
    - Línea 59: habilitación de Material Icons.

11. `backend/app/routers/mantenimiento.py` —solo como apoyo—
    - Líneas 43-51: endpoint que entrega el historial ordenado por fecha descendente.

12. `backend/app/schemas/mantenimiento.py` y `backend/app/models/mantenimiento.py` —solo como apoyo—
    - Permiten explicar de dónde sale `proximo_kilometraje` y cuál es la forma del JSON.

---

## 3. Recorrido del usuario, paso por paso

### Paso 1: el usuario entra al historial

En `inicio.dart`, el encabezado muestra dos `IconButton`: historial y actualizar. El primero usa `Icons.history` y ejecuta `abrirHistorial` en su propiedad `onPressed`.

```dart
IconButton(
  onPressed: abrirHistorial,
  icon: const Icon(Icons.history),
)
```

`abrirHistorial()` usa navegación imperativa:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const HistorialPantalla()),
);
```

Conceptos que debes poder explicar:

- `Navigator` administra una pila de pantallas o rutas.
- `push` coloca `HistorialPantalla` encima de `InicioPantalla`.
- `MaterialPageRoute` proporciona la transición visual propia de Material.
- El botón de volver del `AppBar` aparece automáticamente porque existe una ruta anterior.
- Al hacer `pop`, el historial se destruye y se vuelve a ver el estado anterior de inicio.

### Paso 2: se crea la pantalla y comienza la carga

`HistorialPantalla` es `StatefulWidget` porque su contenido cambia después de una operación asíncrona.

Su estado local contiene:

```dart
List<Mantenimiento>? lista;
String? error;
bool cargando = true;
```

| Variable | Qué representa | Efecto visual |
|---|---|---|
| `cargando` | Hay una petición en curso | Muestra `CircularProgressIndicator` |
| `error` | La petición falló | Muestra mensaje y botón `Reintentar` |
| `lista` | Datos recibidos | Muestra vacío o lista de servicios |

Cuando Flutter inserta el widget en el árbol, ejecuta una sola vez `initState()` y este llama a `cargar()`.

```dart
@override
void initState() {
  super.initState();
  cargar();
}
```

### Paso 3: la petición modifica el estado

`cargar()` primero activa carga y limpia cualquier error anterior:

```dart
setState(() {
  cargando = true;
  error = null;
});
```

`setState` no dibuja manualmente la pantalla. Informa a Flutter que cambió el estado y que debe volver a ejecutar `build` para producir una nueva descripción visual.

Luego espera la respuesta:

```dart
final data = await obtenerHistorial();
```

Si la petición tiene éxito:

```dart
if (!mounted) return;
setState(() {
  lista = data;
  cargando = false;
});
```

`mounted` comprueba que la pantalla todavía esté en el árbol. Evita llamar a `setState` si el usuario salió antes de que terminara la red.

Si ocurre una excepción, se guarda un texto amigable en `error` y se termina la carga. El detalle técnico se imprime en consola con `print(e)`, pero no se expone al usuario.

### Paso 4: `api.dart` obtiene y transforma los datos

`obtenerHistorial()` realiza:

```http
GET http://127.0.0.1:8000/mantenimiento/historial
```

La petición tiene un tiempo máximo de 8 segundos. Si el código HTTP no es `200`, lanza una excepción. Si tiene éxito:

1. `jsonDecode(resp.body)` transforma el texto JSON en una lista dinámica.
2. `map` procesa cada elemento.
3. `Mantenimiento.fromJson(e)` crea objetos de dominio.
4. `toList()` produce `List<Mantenimiento>`.

Forma esperada de cada elemento:

```json
{
  "id": 1,
  "vehiculo_id": 1,
  "tipo": "aceite",
  "fecha": "2026-09-08",
  "kilometraje": 15000,
  "proximo_kilometraje": 20000,
  "costo": 180.0
}
```

En `Mantenimiento.fromJson` hay dos conversiones importantes:

- `DateTime.parse(json['fecha'])` convierte la fecha textual en `DateTime`.
- `(json['costo'] as num?)?.toDouble()` acepta costo entero, decimal o nulo y lo normaliza a `double?`.

El backend ordena el historial mediante `Mantenimiento.fecha.desc()`. El frontend conserva ese orden y no vuelve a ordenar la lista.

### Paso 5: la interfaz decide qué cuerpo mostrar

`_cuerpo()` funciona como una pequeña máquina de estados. Evalúa en este orden:

```text
¿cargando?
  sí -> spinner
  no -> ¿hay error?
          sí -> mensaje + Reintentar
          no -> ¿lista vacía?
                  sí -> estado vacío
                  no -> contador + filas
```

Estados observables:

| Situación | Widget principal | Respuesta ofrecida |
|---|---|---|
| Carga inicial o recarga | `CircularProgressIndicator` | Feedback de actividad |
| Error de red/API | `Text` + `ElevatedButton` | Permite reintentar |
| Sin servicios | icono + título + explicación | Informa por qué no hay contenido |
| Con servicios | `RefreshIndicator` + `ListView` | Permite leer, desplazar y recargar |

El texto del contador reacciona a la cantidad para mantener concordancia:

- `1 servicio registrado`.
- `N servicios registrados`.

El `RefreshIndicator` ejecuta de nuevo `cargar()` al deslizar hacia abajo. Durante esa recarga, el código pone `cargando = true`, así que la lista se reemplaza temporalmente por el indicador central.

### Paso 6: construcción de cada fila

Cada mantenimiento se presenta mediante `_fila(m)`:

```text
Material
  └─ InkWell (área táctil y efecto de pulsación)
      └─ Container (borde, radio y padding)
          └─ Row
              ├─ icono check dentro de círculo
              ├─ Expanded
              │   ├─ tipo de mantenimiento
              │   └─ fecha + kilometraje
              ├─ PillEstado("HECHO")
              └─ chevron_right
```

Decisiones de interacción importantes:

- Toda la tarjeta es tocable, no solo el chevrón.
- `InkWell` comunica el toque mediante un resaltado (`highlightColor`).
- `borderRadius` mantiene el feedback dentro de la forma redondeada.
- `chevron_right` funciona como significante visual: sugiere que hay un nivel de detalle.
- `Expanded` permite que la descripción ocupe el espacio flexible sin empujar inmediatamente los elementos de la derecha.
- El icono de verificación y la palabra `HECHO` comunican el estado sin depender únicamente del color.

### Paso 7: selección y navegación al detalle

La interacción se conecta así:

```dart
onTap: () => abrirDetalle(m)
```

`abrirDetalle(m)` abre otra ruta y pasa el objeto seleccionado completo:

```dart
DetalleMantenimientoPantalla(mantenimiento: m)
```

No se pasa solamente el `id` y no hay una segunda petición HTTP. Esto produce un detalle inmediato y consistente con la fila que el usuario acaba de tocar.

Consecuencia arquitectónica: si el registro cambia en el servidor mientras el detalle está abierto, esta pantalla no se actualiza por sí sola porque trabaja con la copia ya recibida.

### Paso 8: presentación del detalle

`DetalleMantenimientoPantalla` es `StatelessWidget` porque:

- recibe toda la información por el constructor;
- no realiza peticiones;
- no tiene controles que modifiquen datos;
- su interfaz es una función directa del objeto `mantenimiento`.

La propiedad es:

```dart
final Mantenimiento mantenimiento;
```

Su estructura es:

```text
Scaffold blanco
  ├─ AppBar blanco con botón atrás automático
  └─ ListView
      ├─ título del tipo
      ├─ tarjeta resumen
      ├─ caja: fecha
      ├─ caja: kilometraje del servicio
      ├─ caja: próximo servicio
      ├─ caja: costo (solo si no es null)
      └─ mensaje informativo
```

El costo usa renderizado condicional:

```dart
if (m.costo != null) ...[
  const SizedBox(height: 12),
  _datoCaja('Costo', 'Bs ${fmtMiles(m.costo!.round())}'),
]
```

Esto significa que la jerarquía de widgets cambia según los datos. `...[]` inserta varios widgets en la lista de `children`, y `!` es seguro en ese bloque porque la condición ya descartó `null`.

---

## 4. Componentes y widgets que debes reconocer

| Componente/widget | Archivo | Función en este flujo |
|---|---|---|
| `InicioPantalla` | `pantallas/inicio.dart` | Punto de entrada al historial |
| `HistorialPantalla` | `pantallas/historial.dart` | Carga, conserva y muestra los servicios |
| `DetalleMantenimientoPantalla` | `pantallas/detalle_mantenimiento.dart` | Presenta el registro seleccionado |
| `PillEstado` | `componentes.dart` | Etiqueta reutilizable de estado |
| `Mantenimiento` | `modelos.dart` | Modelo de datos consumido por la UI |
| `Scaffold` | Flutter Material | Estructura base de cada pantalla |
| `AppBar` | Flutter Material | Título, navegación atrás y jerarquía |
| `ListView` | Flutter Material | Contenido desplazable |
| `RefreshIndicator` | Flutter Material | Gesto y feedback de actualización |
| `CircularProgressIndicator` | Flutter Material | Feedback de carga |
| `Material` + `InkWell` | Flutter Material | Superficie y respuesta táctil de cada fila |
| `Container` | Flutter | Espaciado, fondo, borde y radio |
| `Row` / `Column` | Flutter | Distribución horizontal y vertical |
| `Expanded` | Flutter | Administración del espacio flexible |
| `SizedBox` | Flutter | Separación y dimensiones explícitas |
| `Text` / `Icon` | Flutter | Contenido verbal y visual |

### Componentes propios versus métodos auxiliares

- `PillEstado` es un componente público reutilizable (`StatelessWidget`).
- `_fila`, `_vacio`, `_resumen` y `_datoCaja` son métodos privados que devuelven widgets. El guion bajo indica privacidad dentro de la librería/archivo Dart.
- Extraer estos métodos reduce el tamaño de `build`, pero no crea estados independientes.

---

## 5. Gestión del estado y reacción de la interfaz

### Estrategia usada

El estado es **local y efímero**:

- vive dentro de `_HistorialPantallaState`;
- se pierde cuando esa ruta es eliminada;
- se vuelve a consultar al abrir de nuevo el historial;
- no se comparte globalmente;
- no hay caché ni persistencia en el dispositivo.

La secuencia fundamental es:

```text
evento del usuario/ciclo de vida
  -> método modifica variables dentro de setState
  -> Flutter vuelve a llamar build
  -> build selecciona widgets según los nuevos valores
  -> pantalla refleja el nuevo estado
```

### Por qué `HistorialPantalla` es stateful y el detalle stateless

| Pantalla | Tipo | Motivo |
|---|---|---|
| Historial | `StatefulWidget` | Cambia de carga a éxito/error y admite recarga |
| Detalle | `StatelessWidget` | Solo presenta el objeto recibido; no cambia estado |

### Navegación y conservación del estado

- Al abrir el detalle, el historial permanece debajo en la pila de navegación.
- Al volver desde el detalle, se recupera la misma instancia del historial y su lista sigue disponible.
- Al volver desde historial a inicio, la ruta del historial sale de la pila y su estado se elimina.
- Al abrirlo otra vez, `initState` vuelve a llamar a la API.

---

## 6. Colores y sistema visual

Los tokens usados por historial y detalle viven en `mobile/lib/tema.dart`:

| Token | Hexadecimal | Uso |
|---|---:|---|
| `teal` | `#00695C` | Icono de servicio completado y acento de marca |
| `muted` | `#98A3A0` | Texto secundario, iconos y chevrón |
| `texto` | `#34403D` | Texto principal y título |
| `borde` | `#CFD8D5` | Contorno sutil de tarjetas |
| `fondoSuave` | `#E8F5F2` | Fondo del círculo del icono |
| `grisCaja` | `#E7ECEA` | Etiqueta, cajas de datos y feedback táctil |
| `neutro` | `#4A5754` | Texto de la etiqueta `HECHO` |
| `sombraCard` | negro verdoso al 10 % | Profundidad leve en la tarjeta resumen |

### Lectura desde IHC

- **Jerarquía:** `texto` oscuro y pesos `bold/w600` destacan títulos; `muted` separa metadatos secundarios.
- **Consistencia:** historial y detalle repiten icono, tarjeta, etiqueta y colores. Esto conserva el modelo mental entre resumen y detalle.
- **Estado:** check + `HECHO` indican una acción finalizada; hay redundancia entre icono, palabra y color.
- **Agrupación:** borde, fondo y radio aplican proximidad y región común para asociar datos.
- **Profundidad:** la sombra solo aparece en el resumen del detalle, mientras las filas se delimitan principalmente con borde.
- **Espaciado:** se repiten 12 y 16 px para crear ritmo y separación predecible.
- **Forma:** radios de 12, 16 y 20 px producen superficies suaves y coherentes con Material 3.

### Contraste que conviene mencionar críticamente

Contrastes aproximados calculados con los colores actuales:

| Combinación | Relación aproximada | Lectura |
|---|---:|---|
| `texto` sobre blanco | 10.79:1 | Contraste fuerte |
| `teal` sobre blanco | 6.61:1 | Contraste fuerte |
| `neutro` sobre `grisCaja` | 6.32:1 | Adecuado para la etiqueta |
| `teal` sobre `fondoSuave` | 5.91:1 | Adecuado para el icono |
| `muted` sobre blanco | 2.60:1 | Bajo para texto normal pequeño |
| `muted` sobre `grisCaja` | 2.18:1 | Bajo para texto normal pequeño |

Según WCAG, el texto normal busca al menos 4.5:1. Por tanto, los textos secundarios de 11-12 px con `muted` son un punto débil de accesibilidad. El borde tenue no necesita cumplir contraste de texto, pero también puede ser difícil de percibir para algunos usuarios.

### Dos fuentes de tema

Existe una decisión técnica que debes distinguir:

- `main.dart` crea un `ThemeData` global con `ColorScheme.fromSeed(seedColor: Colors.teal)` y Material 3.
- `tema.dart` define colores manuales para historial y detalle.

Esto hace que controles como `CircularProgressIndicator` y `ElevatedButton` hereden el tema global, mientras textos, bordes y tarjetas del flujo usan constantes locales. Funciona, pero hay duplicación y podría generar inconsistencias si cambia solo una de las dos fuentes.

---

## 7. Formateo orientado al usuario

`mobile/lib/formato.dart` evita mostrar datos crudos:

- `tituloTipo('aceite')` produce `Cambio de aceite`.
- `fmtFecha(DateTime(...))` produce una fecha como `8 sep 2026`.
- `fmtMiles(15000)` produce `15.000`.

Esto es relevante en IHC porque la interfaz usa lenguaje reconocible y reduce la carga de interpretación. El backend puede trabajar con claves compactas (`aceite`, `llantas`), mientras el usuario recibe títulos descriptivos.

Ten presentes estas limitaciones:

- El formateo es manual y no usa localización (`intl`).
- Los textos están escritos directamente en español dentro de los widgets.
- No hay soporte de cambio de idioma.
- El costo se redondea antes de mostrarse, por lo que no presenta centavos.
- Algunas cadenas del código fuente omiten tildes (`Proximo`, `Todavia`, `Quedo`).

---

## 8. Principios de IHC presentes en el flujo

### Visibilidad del estado del sistema

- Spinner durante la petición.
- Contador de servicios al completar.
- Estado vacío si no existen registros.
- Etiqueta `HECHO` en cada servicio.

### Retroalimentación

- `InkWell` responde visualmente al toque.
- `RefreshIndicator` responde al gesto de recarga.
- La navegación animada confirma el cambio de contexto.

### Control y libertad del usuario

- El usuario puede volver con el botón implícito del `AppBar`.
- Puede reintentar una petición fallida.
- Puede actualizar el contenido con pull-to-refresh.

### Consistencia y estándares

- Usa componentes Material conocidos.
- Repite el lenguaje visual del historial en el detalle.
- Usa chevrón para indicar navegación a un nivel inferior.

### Reconocimiento antes que recuerdo

- Los tipos se traducen a nombres descriptivos.
- La fila ya muestra fecha y kilometraje antes de entrar.
- El detalle agrupa y etiqueta explícitamente cada valor.

### Prevención y recuperación de errores

- Tiempo límite de 8 segundos en la petición.
- Código no exitoso se convierte en excepción.
- `mounted` evita actualizar una pantalla destruida.
- El usuario recibe una acción concreta: `Reintentar`.

### Diseño minimalista

- La lista enseña solo tipo, fecha, kilometraje y estado.
- La información ampliada se reserva para la pantalla de detalle.
- Esta revelación progresiva reduce densidad en la vista de exploración.

---

## 9. Aspectos mejorables que pueden preguntarte

Estos puntos no impiden explicar el flujo, pero demuestran análisis crítico:

1. **No existe registro desde el frontend móvil.** El backend tiene el endpoint POST, pero el móvil no lo consume.
2. **Accesibilidad de color.** `muted` ofrece poco contraste en textos pequeños.
3. **Tamaño de texto.** La etiqueta usa 10 px y varios metadatos 11-12 px; pueden resultar pequeños.
4. **Botón de historial sin `tooltip`.** Un texto accesible ayudaría a explicar el icono a lectores de pantalla y usuarios nuevos.
5. **Estado vacío sin recarga gestual.** `_vacio()` no está dentro de una vista desplazable con `RefreshIndicator`; para obtener nuevos datos hay que salir y volver a entrar.
6. **La recarga sustituye toda la lista.** Al refrescar, `cargando = true` muestra el spinner central en lugar de conservar visualmente el contenido anterior.
7. **Errores poco específicos.** Todos los fallos terminan en `No se pudo cargar el historial`; no distingue sin conexión, timeout o error del servidor.
8. **Sin consulta individual en detalle.** Es rápido, pero puede mostrar datos desactualizados si el servidor cambió tras cargar la lista.
9. **Sin estado global ni caché.** Es simple para un prototipo, pero cada reapertura repite la consulta.
10. **Modelo mutable.** Los campos de `Mantenimiento` no son `final`, aunque en este recorrido se tratan como datos de solo lectura.
11. **Tema duplicado.** Parte de la apariencia viene de `ThemeData` y parte de constantes en `tema.dart`.
12. **URL local fija.** `127.0.0.1` requiere que el backend sea accesible desde el entorno del dispositivo; en Android físico/emulador puede requerir configuración como `adb reverse`.
13. **Pruebas insuficientes para el flujo.** El test incluido es el ejemplo inicial de Flutter y no cubre carga, error, vacío, selección ni detalle.

---

## 10. Qué datos aparecen y de dónde salen

| Elemento visible | Campo/origen | Transformación |
|---|---|---|
| Título del servicio | `m.tipo` | `tituloTipo` |
| Fecha | `m.fecha` | `DateTime.parse` y luego `fmtFecha` |
| Kilometraje | `m.kilometraje` | `fmtMiles` + `km` |
| Próximo servicio | `m.proximo_kilometraje` | Backend lo calcula; frontend lo formatea |
| Costo | `m.costo` | Se muestra solo si existe; redondeo + `fmtMiles` |
| Estado `HECHO` | Texto fijo de la UI | No viene del backend |
| Orden de las filas | Backend | Fecha descendente |

`proximo_kilometraje` no está guardado como columna en la tabla. En `backend/app/models/mantenimiento.py` es una propiedad calculada:

```text
proximo_kilometraje = kilometraje del servicio + intervalo de su tipo
```

---

## 11. Guion corto para defender el recorrido

Puedes explicarlo así:

> El usuario inicia el recorrido tocando el icono de historial en `InicioPantalla`. Su callback usa `Navigator.push` y un `MaterialPageRoute` para colocar `HistorialPantalla` en la pila. El historial es stateful porque debe representar carga, error y datos. En `initState` llama a `cargar`, que activa el indicador, consulta `GET /mantenimiento/historial` y convierte el JSON en objetos `Mantenimiento`. Con `setState`, Flutter reconstruye el cuerpo y muestra un error recuperable, un estado vacío o una lista. Cada fila es un `InkWell`, así que ofrece feedback táctil y al tocarla pasa el objeto completo a `DetalleMantenimientoPantalla`. El detalle es stateless porque solo presenta esos datos. Ambos niveles comparten colores, formateadores y el componente `PillEstado`, lo que mantiene consistencia visual y reduce la carga cognitiva.

Después agrega una observación crítica:

> Como mejora de IHC priorizaría aumentar el contraste del texto secundario, añadir etiquetas accesibles a los iconos y mantener la lista visible durante la actualización. Arquitectónicamente también falta conectar el registro de mantenimientos en el frontend.

---

## 12. Preguntas probables y respuestas

### ¿Por qué se usa `StatefulWidget` en el historial?

Porque la pantalla cambia después de construirse: empieza cargando, luego puede mostrar error, vacío o datos, y además puede recargarse.

### ¿Qué hace realmente `setState`?

Modifica variables y marca el widget para reconstrucción. Flutter vuelve a ejecutar `build` y reconcilia el nuevo árbol con el anterior.

### ¿Por qué se comprueba `mounted`?

Porque la petición puede terminar después de que el usuario haya cerrado la pantalla. Sin esa comprobación, se intentaría actualizar un estado que ya fue eliminado.

### ¿Cómo llega la información al detalle?

La fila recibe un `Mantenimiento`; al tocarla, ese mismo objeto se entrega como argumento del constructor de `DetalleMantenimientoPantalla`.

### ¿El detalle vuelve a consultar al backend?

No. Presenta el objeto recibido, por eso responde rápido, pero no obtiene cambios posteriores del servidor.

### ¿Quién ordena el historial?

El backend, por fecha descendente. El frontend respeta el orden de la respuesta.

### ¿Qué ocurre si el costo es nulo?

Flutter no agrega la caja de costo al árbol de widgets gracias al `if` dentro de `children`.

### ¿Cómo se expresa la affordance de las filas?

La tarjeta completa tiene respuesta táctil con `InkWell` y el chevrón hacia la derecha sugiere que puede abrirse.

### ¿Qué patrón de estado utiliza?

Estado local con `StatefulWidget` y `setState`, apropiado para el tamaño actual del flujo, sin una biblioteca externa.

### ¿Qué función tiene `PillEstado`?

Encapsula forma, padding y tipografía de una etiqueta. Evita duplicar ese diseño entre historial y detalle.

### ¿Qué aporta `formato.dart` a la usabilidad?

Traduce claves y números técnicos a textos familiares: títulos descriptivos, fechas cortas y separadores de miles.

### ¿Cómo vuelve el usuario?

El `AppBar` detecta que la ruta puede hacer `pop` y muestra automáticamente la flecha de regreso.

### ¿Se puede decir que la aplicación registra el mantenimiento en este flujo?

No con el frontend actual. El flujo estudiado consulta y presenta registros. El backend posee un endpoint de creación, pero todavía no está conectado a una interacción móvil.

---

## 13. Lista final de estudio

Antes de defender, asegúrate de poder:

- [ ] Dibujar la pila `Inicio -> Historial -> Detalle`.
- [ ] Explicar `onPressed`, `onTap`, `Navigator.push` y el regreso con `pop`.
- [ ] Diferenciar `StatefulWidget` de `StatelessWidget` usando estas pantallas.
- [ ] Describir el ciclo `initState -> cargar -> await -> setState -> build`.
- [ ] Enumerar los cuatro estados visuales del historial.
- [ ] Seguir un JSON hasta `Mantenimiento.fromJson` y luego hasta un `Text`.
- [ ] Explicar para qué sirve `mounted`.
- [ ] Describir `Material`, `InkWell`, `ListView`, `RefreshIndicator` y `Expanded`.
- [ ] Identificar `PillEstado`, `_fila`, `_resumen` y `_datoCaja`.
- [ ] Explicar el renderizado condicional del costo.
- [ ] Nombrar los colores principales y su intención visual.
- [ ] Relacionar el diseño con feedback, consistencia, visibilidad y reconocimiento.
- [ ] Señalar el problema de contraste de `muted`.
- [ ] Reconocer que el orden viene del backend.
- [ ] Aclarar que el detalle no hace otra petición.
- [ ] Aclarar que el registro móvil todavía no está implementado.

## Resumen de una línea

El historial administra estado local y datos remotos; la fila convierte esos datos en una interacción; el detalle recibe el objeto elegido y lo presenta de forma estática, consistente y jerarquizada.
