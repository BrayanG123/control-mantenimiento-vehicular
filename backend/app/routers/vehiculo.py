from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.vehiculo import (
    VehiculoCreate,
    VehiculoResponse,
    VehiculoUpdateKilometraje,
)
from app.services import vehiculo_service


router = APIRouter(prefix="/vehiculo", tags=["Vehículo"])


@router.post("/", response_model=VehiculoResponse, status_code=201)
def registrar_vehiculo(
    datos: VehiculoCreate,
    db: Session = Depends(get_db),
):
    return vehiculo_service.registrar_vehiculo(db, datos)


@router.get("/", response_model=VehiculoResponse)
def obtener_vehiculo(db: Session = Depends(get_db)):
    return vehiculo_service.obtener_vehiculo(db)


@router.patch("/kilometraje", response_model=VehiculoResponse)
def actualizar_kilometraje(
    datos: VehiculoUpdateKilometraje,
    db: Session = Depends(get_db),
):
    return vehiculo_service.actualizar_kilometraje(
        db,
        datos.kilometraje_actual,
    )
