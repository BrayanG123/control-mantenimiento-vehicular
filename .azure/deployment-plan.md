# Deployment Plan — CMV API

## Status
Deployed

## Azure
- Subscription: Azure for Students (`41a4808f-a0e7-453b-b19f-d85297091ec5`)
- Resource group: `rg-cmv-api` (Brazil South)
- Plan: `plan-cmv-api` (Linux B1)
- Web App: `cmv-api-dj`
- URL: https://cmv-api-dj.azurewebsites.net
- Startup: gunicorn with `--chdir /home/site/wwwroot`
- DB: SQLite en `/home/data/mantenimiento.db`

## Mobile
- `ConfiguracionApi.urlBase` → `https://cmv-api-dj.azurewebsites.net`
