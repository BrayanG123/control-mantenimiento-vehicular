from sqlalchemy.orm import Session

from app.core.excepciones import OperacionNoPermitida, RecursoNoEncontrado
from app.models.vehiculo import Vehiculo
from app.schemas.vehiculo import VehiculoCreate


def obtener_vehiculo(db: Session, usuario_id: int) -> Vehiculo:
    vehiculo = (
        db.query(Vehiculo)
        .filter(Vehiculo.usuario_id == usuario_id)
        .first()
    )
    if vehiculo is None:
        raise RecursoNoEncontrado("No existe un vehículo registrado")
    return vehiculo


def registrar_vehiculo(
    db: Session,
    datos: VehiculoCreate,
    usuario_id: int,
) -> Vehiculo:
    vehiculo_existente = (
        db.query(Vehiculo)
        .filter(Vehiculo.usuario_id == usuario_id)
        .first()
    )
    if vehiculo_existente is not None:
        raise OperacionNoPermitida("Ya existe un vehículo registrado")

    vehiculo = Vehiculo(**datos.model_dump(), usuario_id=usuario_id)
    db.add(vehiculo)
    db.commit()
    db.refresh(vehiculo)
    return vehiculo


def actualizar_kilometraje(
    db: Session,
    nuevo_kilometraje: int,
    usuario_id: int,
) -> Vehiculo:
    vehiculo = obtener_vehiculo(db, usuario_id)
    if nuevo_kilometraje <= vehiculo.kilometraje_actual:
        raise OperacionNoPermitida(
            "El nuevo kilometraje debe ser mayor al kilometraje actual"
        )

    vehiculo.kilometraje_actual = nuevo_kilometraje
    db.commit()
    db.refresh(vehiculo)
    return vehiculo
