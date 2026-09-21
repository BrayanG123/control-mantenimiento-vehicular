from sqlalchemy.orm import Session

from app.core.intervalos import INTERVALOS_KM
from app.core.tipos import EstadoMantenimiento, TipoMantenimiento
from app.models.mantenimiento import Mantenimiento
from app.models.vehiculo import Vehiculo
from app.schemas.mantenimiento import (
    MantenimientoCreate,
    ProximoMantenimientoItem,
)
from app.services.vehiculo_service import obtener_vehiculo


def registrar_mantenimiento(
    db: Session,
    datos: MantenimientoCreate,
) -> Mantenimiento:
    vehiculo = obtener_vehiculo(db)
    mantenimiento = Mantenimiento(
        **datos.model_dump(),
        vehiculo_id=vehiculo.id,
    )

    if datos.kilometraje > vehiculo.kilometraje_actual:
        vehiculo.kilometraje_actual = datos.kilometraje

    db.add(mantenimiento)
    db.commit()
    db.refresh(mantenimiento)
    return mantenimiento


def obtener_historial(db: Session) -> list[Mantenimiento]:
    vehiculo = obtener_vehiculo(db)
    return (
        db.query(Mantenimiento)
        .filter(Mantenimiento.vehiculo_id == vehiculo.id)
        .order_by(Mantenimiento.fecha.desc(), Mantenimiento.id.desc())
        .all()
    )


def obtener_proximos(db: Session) -> list[ProximoMantenimientoItem]:
    vehiculo = obtener_vehiculo(db)
    return calcular_proximos(
        db,
        vehiculo.id,
        vehiculo.kilometraje_actual,
    )


def obtener_pendientes(db: Session) -> list[ProximoMantenimientoItem]:
    return [
        mantenimiento
        for mantenimiento in obtener_proximos(db)
        if mantenimiento.estado != EstadoMantenimiento.AL_DIA
    ]


def calcular_proximos(
    db: Session,
    vehiculo_id: int,
    kilometraje_actual: int,
) -> list[ProximoMantenimientoItem]:
    proximos = []

    for tipo in TipoMantenimiento:
        if tipo == TipoMantenimiento.CADENA:
            continue

        ultimo_mantenimiento = (
            db.query(Mantenimiento)
            .filter(
                Mantenimiento.vehiculo_id == vehiculo_id,
                Mantenimiento.tipo == tipo,
            )
            .order_by(Mantenimiento.kilometraje.desc())
            .first()
        )

        ultimo_kilometraje = (
            ultimo_mantenimiento.kilometraje
            if ultimo_mantenimiento is not None
            else 0
        )
        intervalo = INTERVALOS_KM[tipo]
        proximo_kilometraje = ultimo_kilometraje + intervalo
        kilometros_restantes = proximo_kilometraje - kilometraje_actual
        estado = determinar_estado(kilometros_restantes, intervalo)

        proximos.append(
            ProximoMantenimientoItem(
                tipo=tipo,
                ultimo_kilometraje=(
                    ultimo_mantenimiento.kilometraje
                    if ultimo_mantenimiento is not None
                    else None
                ),
                proximo_kilometraje=proximo_kilometraje,
                kilometrajes_restantes=kilometros_restantes,
                vencido=estado == EstadoMantenimiento.VENCIDO,
                estado=estado,
            )
        )

    return sorted(
        proximos,
        key=lambda mantenimiento: mantenimiento.kilometrajes_restantes,
    )


def determinar_estado(
    kilometros_restantes: int,
    intervalo: int,
) -> EstadoMantenimiento:
    if kilometros_restantes <= 0:
        return EstadoMantenimiento.VENCIDO
    if kilometros_restantes <= intervalo * 0.2:
        return EstadoMantenimiento.PROXIMO
    return EstadoMantenimiento.AL_DIA
