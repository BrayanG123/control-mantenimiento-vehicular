from sqlalchemy.orm import Session

from app.core.excepciones import OperacionNoPermitida, RecursoNoEncontrado
from app.models.vehiculo import Vehiculo
from app.schemas.vehiculo import VehiculoCreate


def obtener_vehiculo(db: Session) -> Vehiculo:
    vehiculo = db.query(Vehiculo).first()
    if vehiculo is None:
        raise RecursoNoEncontrado("No existe un vehículo registrado")
    return vehiculo


def registrar_vehiculo(db: Session, datos: VehiculoCreate) -> Vehiculo:
    if db.query(Vehiculo).first() is not None:
        raise OperacionNoPermitida("Ya existe un vehículo registrado")

    vehiculo = Vehiculo(**datos.model_dump())
    db.add(vehiculo)
    db.commit()
    db.refresh(vehiculo)
    return vehiculo


def actualizar_kilometraje(
    db: Session,
    nuevo_kilometraje: int,
) -> Vehiculo:
    vehiculo = obtener_vehiculo(db)
    if nuevo_kilometraje <= vehiculo.kilometraje_actual:
        raise OperacionNoPermitida(
            "El nuevo kilometraje debe ser mayor al kilometraje actual"
        )

    vehiculo.kilometraje_actual = nuevo_kilometraje
    db.commit()
    db.refresh(vehiculo)
    return vehiculo
