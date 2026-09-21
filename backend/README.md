# Backend

API FastAPI para vehículo, mantenimiento, historial y gastos.

## Organización

```text
app/
├── main.py
├── config.py
├── database.py
├── core/
├── models/
├── schemas/
├── routers/
└── services/
```

- `core`: tipos, intervalos y excepciones del dominio.
- `models`: tablas y relaciones de SQLAlchemy.
- `schemas`: contratos de entrada y salida de la API.
- `routers`: rutas HTTP y delegación a servicios.
- `services`: operaciones completas y reglas del negocio.

## Responsabilidades

Los routers reciben solicitudes y llaman a servicios. Los servicios consultan y modifican los modelos. Los schemas validan los datos antes de ejecutar las operaciones.

Registrar un mantenimiento también actualiza el kilometraje del vehículo cuando el kilometraje del servicio es mayor. El estado `vencido`, `proximo` o `al_dia` se calcula en el backend.

## Ejecución

```bash
uvicorn app.main:app --reload --port 8001
```

## Pruebas

```bash
python -m unittest discover -s tests -v
```
