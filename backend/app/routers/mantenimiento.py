from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.autenticacion import obtener_usuario_actual
from app.database import get_db
from app.models.usuario import Usuario
from app.schemas.mantenimiento import (
    MantenimientoCreate,
    MantenimientoResponse,
    ProximoMantenimientoItem,
)
from app.services import mantenimiento_service


router = APIRouter(prefix="/mantenimiento", tags=["Mantenimiento"])


@router.post("/", response_model=MantenimientoResponse, status_code=201)
def registrar_mantenimiento(
    datos: MantenimientoCreate,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(obtener_usuario_actual),
):
    return mantenimiento_service.registrar_mantenimiento(db, datos, usuario.id)


@router.get("/historial", response_model=list[MantenimientoResponse])
def obtener_historial(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(obtener_usuario_actual),
):
    return mantenimiento_service.obtener_historial(db, usuario.id)


@router.get("/proximo", response_model=list[ProximoMantenimientoItem])
def obtener_proximos(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(obtener_usuario_actual),
):
    return mantenimiento_service.obtener_proximos(db, usuario.id)


@router.get("/pendientes", response_model=list[ProximoMantenimientoItem])
def obtener_pendientes(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(obtener_usuario_actual),
):
    return mantenimiento_service.obtener_pendientes(db, usuario.id)
