# Aplicación mobile

Aplicación Flutter para registrar y consultar el mantenimiento de un vehículo.

## Organización

```text
lib/
├── core/       configuración, red y utilidades
├── data/       rutas de la API y almacenamiento de sesión
├── models/     datos que recibe y usa el mobile
├── screens/    pantallas y estado de formularios
├── shared/     widgets reutilizables
└── state/      sesión y controladores de carga
```

Las pantallas validan entradas y presentan resultados. Las clases de `data`
conocen las rutas HTTP. `SesionAplicacion` conserva el token de la sesión y
`ClienteApi` lo envía automáticamente en las rutas protegidas.

## Autenticación

El registro usa `POST /autenticacion/registro` y el inicio de sesión usa
`POST /autenticacion/inicio-sesion`. En Chrome, el token se guarda en
`localStorage`, por lo que se conserva al recargar la página. Cerrar sesión lo
elimina.

Las solicitudes de vehículo, mantenimiento y gastos incluyen:

```text
Authorization: Bearer <token>
```

## Ejecutar en Chrome

Inicia primero el backend en el puerto `8000`. Luego, desde `mobile/`:

```bash
flutter run -d chrome --dart-define=API_URL=http://127.0.0.1:8000
```

## Verificación

```bash
flutter analyze
flutter test
flutter build web
```
