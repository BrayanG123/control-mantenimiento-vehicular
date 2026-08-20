from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.vehiculo import Vehiculo
from app.schemas.vehiculo import VehiculoCreate, VehiculoResponse, VehiculoUpdateKilometraje




router = APIRouter(prefix="/vehiculo", tags=["Vehiculo"])

@router.post("/", response_model=VehiculoResponse, status_code=201)
def crear_vehiculo(
    vehiculo: VehiculoCreate, 
    db: Session = Depends(get_db)
):
    existente = db.query(Vehiculo).first()
    if existente:
        raise HTTPException(
            status_code=400,
            detail="ya existe un vehiculo registrado"
        )

    nuevo_vehiculo = Vehiculo(**vehiculo.model_dump())
    db.add(nuevo_vehiculo)
    db.commit()
    db.refresh(nuevo_vehiculo)
    return nuevo_vehiculo


@router.get("/", response_model=VehiculoResponse)
def obtener_vehiculo(db: Session = Depends(get_db)):
    vehiculo = db.query(Vehiculo).first()
    if not vehiculo:
        raise HTTPException(
            status_code=404,
            detail="No existe vehiculos registrados"
        )
    
    return vehiculo


@router.patch("/kilometraje", response_model=VehiculoResponse)
def actualizar_kilometraje(
    datos: VehiculoUpdateKilometraje,
    db: Session = Depends(get_db)
):
    vehiculo = db.query(Vehiculo).first()
    if not vehiculo:
        raise HTTPException(
            status_code=404,
            detail="No existe vehiculo registrado aun"
        )

    if datos.kilometraje_actual < vehiculo.kilometraje_actual:
        raise HTTPException(
            status_code=400,
            detail="El nuevo kilometraje no puede ser menor al actual"
        )

    vehiculo.kilometraje_actual = datos.kilometraje_actual
    db.commit()
    db.refresh(vehiculo)
    return vehiculo