from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.core.excepciones import (
    OperacionNoPermitida,
    RecursoNoEncontrado,
    ServicioNoDisponible,
)
from app.database import preparar_base_de_datos
from app.routers import autenticacion, gastos, mantenimiento, vehiculo

preparar_base_de_datos()

app = FastAPI(title="API de control de mantenimiento vehicular")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(autenticacion.router)
app.include_router(vehiculo.router)
app.include_router(mantenimiento.router)
app.include_router(gastos.router)


@app.exception_handler(RecursoNoEncontrado)
def manejar_recurso_no_encontrado(
    request: Request,
    error: RecursoNoEncontrado,
):
    return JSONResponse(status_code=404, content={"detail": error.mensaje})


@app.exception_handler(OperacionNoPermitida)
def manejar_operacion_no_permitida(
    request: Request,
    error: OperacionNoPermitida,
):
    return JSONResponse(status_code=400, content={"detail": error.mensaje})


@app.exception_handler(ServicioNoDisponible)
def manejar_servicio_no_disponible(
    request: Request,
    error: ServicioNoDisponible,
):
    return JSONResponse(status_code=503, content={"detail": error.mensaje})


@app.get("/")
def root():
    return {"status": "ok"}
