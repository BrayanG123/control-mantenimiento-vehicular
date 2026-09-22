# Deployment Plan — CMV API

## Status
Preparing

## Goal
Publicar el backend FastAPI en Azure App Service (HTTPS) para que la app Flutter
use la API sin cable USB / sin `adb reverse`.

## Azure context
- Subscription: Azure for Students (`41a4808f-a0e7-453b-b19f-d85297091ec5`)
- Location: `brazilsouth` (cercanía LATAM)
- Resource group: `rg-cmv-api`
- App Service Plan: `plan-cmv-api` (Linux, B1)
- Web App: `cmv-api-diego` (si el nombre está tomado, agregar sufijo)

## Recipe
- Type: Azure App Service (Python 3.12) + zip deploy
- Database: SQLite en `/home/data/mantenimiento.db` (persistente en App Service)
- Auth secrets: app settings `CLAVE_SECRETA`, `DATABASE_URL`

## App changes
1. `gunicorn` + worker uvicorn en `requirements.txt`
2. Startup: gunicorn binding 0.0.0.0:8000
3. Flutter rebuild con `--dart-define=API_URL=https://<app>.azurewebsites.net`

## Out of scope
- Azure SQL / Cosmos (innecesario para demo estudiante)
- Custom domain / Front Door
