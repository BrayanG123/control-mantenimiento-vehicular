from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.vehiculo import Vehiculo
from app.models.mantenimiento import Mantenimiento
from app.schemas.mantenimiento import (
    MantenimientoCreate,
    MantenimientoResponse,
    ProximoMantenimientoItem
)
from app.services.calculo_mantenimiento import calcular_proximo_mantenimiento



router = APIRouter(prefix="/mantenimiento", tags=["Mantenimiento"])


def _obtener_vehiculo_unico(db: Session) -> Vehiculo:
    vehiculo = db.query(Vehiculo).first()
    if not vehiculo:
        raise HTTPException(
            status_code=404,
            detail="No hay vehiculo registrado aun"
        )
    return vehiculo


@router.post("/", response_model=MantenimientoResponse, status_code=201)
def registrar_mantenimiento(
    datos: MantenimientoCreate,
    db: Session = Depends(get_db)
):
    vehiculo = _obtener_vehiculo_unico(db)

    nuevo = Mantenimiento(**datos.model_dump(), vehiculo_id=vehiculo.id)
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)

    return nuevo


@router.get("/historial", response_model=list[MantenimientoResponse])
def obtener_historial(db: Session = Depends(get_db)):
    vehiculo = _obtener_vehiculo_unico(db)
    return (
        db.query(Mantenimiento)
        .filter(Mantenimiento.vehiculo_id == vehiculo.id)
        .order_by(Mantenimiento.fecha.desc())
        .all()
    )


@router.get("/proximo", response_model=list[ProximoMantenimientoItem])
def obtener_proximo_mantenimiento(db: Session = Depends(get_db)):
    vehiculo = _obtener_vehiculo_unico(db)
    return calcular_proximo_mantenimiento(db, vehiculo.id, vehiculo.kilometraje_actual)

@router.get("/pendientes", response_model=list[ProximoMantenimientoItem])
def obtener_pendientes(db: Session = Depends(get_db)):
    vehiculo = _obtener_vehiculo_unico(db)
    todos = calcular_proximo_mantenimiento(db, vehiculo.id, vehiculo.kilometraje_actual)
    return [item for item in todos if item.vencido]