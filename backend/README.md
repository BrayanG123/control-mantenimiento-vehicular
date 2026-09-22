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
uvicorn app.main:app --reload --port 8000
```

## Pruebas

```bash
python -m unittest discover -s tests -v
```

## Autenticación

Un usuario se registra con `POST /autenticacion/registro` y luego puede iniciar
sesión con `POST /autenticacion/inicio-sesion`. Ambas rutas reciben este cuerpo:

```json
{
  "correo": "mariana@correo.com",
  "contrasena": "123456"
}
```

La respuesta contiene `access_token`. Las rutas de vehículo, mantenimiento y
gastos requieren enviar ese valor en el encabezado:

```text
Authorization: Bearer <access_token>
```

Cada usuario tiene un vehículo y sus propios mantenimientos y gastos. Las
contraseñas se guardan como hashes `scrypt`; nunca se almacenan ni devuelven en
texto plano. La duración y la firma de los tokens se configuran con
`DURACION_TOKEN_MINUTOS` y `CLAVE_SECRETA` en `.env`.

## Recuperación de contraseña con Resend

Configura estas variables en `.env`:

```env
RESEND_API_KEY=re_tu_clave
RESEND_REMITENTE=Mantenimiento <correo@tu-dominio-verificado.com>
URL_MOBILE=http://127.0.0.1:8080
DURACION_RECUPERACION_MINUTOS=15
```

Si `RESEND_API_KEY` está vacío, el backend no falla: deja el enlace en
`ultimo_enlace_recuperacion.txt` y en la consola de uvicorn (modo demo local).

`POST /autenticacion/recuperacion` envía el enlace y
`POST /autenticacion/restablecimiento` guarda la contraseña nueva. El token del
enlace se almacena como hash, vence y solo puede utilizarse una vez.
