# Aplicación móvil

Aplicación Flutter para consultar el vehículo, registrar mantenimientos, revisar el historial y visualizar gastos.

## Organización

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── config/
│   ├── dependencies/
│   ├── layout/
│   ├── network/
│   ├── theme/
│   └── utils/
├── data/
├── models/
├── screens/
├── shared/widgets/
└── state/
```

- `core`: configuración y recursos generales de la aplicación.
- `data`: comunicación con la API y sesión temporal de demostración.
- `models`: representación de los datos utilizados por el mobile.
- `screens`: pantallas y estado exclusivo de formularios.
- `shared/widgets`: componentes visuales reutilizables.
- `state`: controladores de carga, datos y errores.

## Responsabilidades

Las pantallas presentan datos y capturan entradas. Los controladores coordinan el estado asíncrono. Las clases de `data` conocen las rutas HTTP. Los modelos convierten el JSON del backend a nombres propios de Dart.

La sesión actual es una implementación local de demostración y se encuentra identificada como `ServicioSesionDemo`.

## Configuración de la API

La URL predeterminada es `http://127.0.0.1:8001`. Puede cambiarse al ejecutar o compilar la aplicación:

```bash
flutter run --dart-define=API_URL=http://10.0.2.2:8001
```

## Verificación

```bash
flutter analyze
flutter test
flutter build web
```
