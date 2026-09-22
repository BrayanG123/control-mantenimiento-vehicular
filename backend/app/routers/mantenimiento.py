from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.autenticacion import obtener_usuario_actual
from app.database import get_db
from app.models.usuario import Usuario
from app.core.tipos import TipoMantenimiento
from app.schemas.mantenimiento import (
    IntervaloUpdate,
    ItemPlan,
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


@router.get("/plan", response_model=list[ItemPlan])
def obtener_plan(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(obtener_usuario_actual),
):
    return mantenimiento_service.listar_plan(db, usuario.id)


@router.patch("/plan/{tipo}", response_model=ItemPlan)
def actualizar_intervalo(
    tipo: TipoMantenimiento,
    datos: IntervaloUpdate,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(obtener_usuario_actual),
):
    return mantenimiento_service.actualizar_intervalo(
        db,
        usuario.id,
        tipo,
        datos.intervalo_km,
    )
