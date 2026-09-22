from sqlalchemy.orm import Session

from app.core.excepciones import OperacionNoPermitida
from app.core.intervalos import (
    INTERVALOS_KM,
    MINIMO_INTERVALO_KM,
    TIPOS_CON_INTERVALO,
)
from app.core.tipos import EstadoMantenimiento, TipoMantenimiento
from app.models.intervalo_vehiculo import IntervaloVehiculo
from app.models.mantenimiento import Mantenimiento
from app.schemas.mantenimiento import (
    ItemPlan,
    MantenimientoCreate,
    ProximoMantenimientoItem,
)
from app.services.vehiculo_service import obtener_vehiculo


def registrar_mantenimiento(
    db: Session,
    datos: MantenimientoCreate,
    usuario_id: int,
) -> Mantenimiento:
    vehiculo = obtener_vehiculo(db, usuario_id)
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


def obtener_historial(db: Session, usuario_id: int) -> list[Mantenimiento]:
    vehiculo = obtener_vehiculo(db, usuario_id)
    return (
        db.query(Mantenimiento)
        .filter(Mantenimiento.vehiculo_id == vehiculo.id)
        .order_by(Mantenimiento.fecha.desc(), Mantenimiento.id.desc())
        .all()
    )


def obtener_proximos(
    db: Session,
    usuario_id: int,
) -> list[ProximoMantenimientoItem]:
    vehiculo = obtener_vehiculo(db, usuario_id)
    return calcular_proximos(
        db,
        vehiculo.id,
        vehiculo.kilometraje_actual,
    )


def obtener_pendientes(
    db: Session,
    usuario_id: int,
) -> list[ProximoMantenimientoItem]:
    return [
        mantenimiento
        for mantenimiento in obtener_proximos(db, usuario_id)
        if mantenimiento.estado != EstadoMantenimiento.AL_DIA
    ]


def calcular_proximos(
    db: Session,
    vehiculo_id: int,
    kilometraje_actual: int,
) -> list[ProximoMantenimientoItem]:
    proximos = []

    for tipo in TIPOS_CON_INTERVALO:
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
        intervalo = intervalo_en_uso(db, vehiculo_id, tipo)
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


def _fila_intervalo(db: Session, vehiculo_id: int, tipo: TipoMantenimiento):
    return (
        db.query(IntervaloVehiculo)
        .filter(
            IntervaloVehiculo.vehiculo_id == vehiculo_id,
            IntervaloVehiculo.tipo == tipo,
        )
        .first()
    )


def intervalo_en_uso(db: Session, vehiculo_id: int, tipo: TipoMantenimiento) -> int:
    fila = _fila_intervalo(db, vehiculo_id, tipo)
    if fila is None:
        return INTERVALOS_KM[tipo]
    return fila.kilometros


def listar_plan(db: Session, usuario_id: int) -> list[ItemPlan]:
    vehiculo = obtener_vehiculo(db, usuario_id)
    proximos = {
        item.tipo: item
        for item in calcular_proximos(db, vehiculo.id, vehiculo.kilometraje_actual)
    }

    plan = []
    for tipo in TIPOS_CON_INTERVALO:
        fila = _fila_intervalo(db, vehiculo.id, tipo)
        intervalo = fila.kilometros if fila is not None else INTERVALOS_KM[tipo]
        plan.append(
            ItemPlan(
                tipo=tipo,
                intervalo_km=intervalo,
                intervalo_fabrica=INTERVALOS_KM[tipo],
                personalizado=fila is not None,
                estado=proximos[tipo].estado,
            )
        )
    return plan


def actualizar_intervalo(
    db: Session,
    usuario_id: int,
    tipo: TipoMantenimiento,
    intervalo_km: int,
) -> ItemPlan:
    if tipo not in TIPOS_CON_INTERVALO:
        raise OperacionNoPermitida("Ese tipo no tiene intervalo para ajustar")

    if intervalo_km < MINIMO_INTERVALO_KM:
        raise OperacionNoPermitida("Muy corto: el minimo es 500 km.")

    if intervalo_km == INTERVALOS_KM[tipo]:
        raise OperacionNoPermitida(
            "Es el mismo de fabrica. Para uso intensivo bajalo (ej. 3.000)."
        )

    vehiculo = obtener_vehiculo(db, usuario_id)
    fila = _fila_intervalo(db, vehiculo.id, tipo)
    if fila is None:
        fila = IntervaloVehiculo(
            vehiculo_id=vehiculo.id,
            tipo=tipo,
            kilometros=intervalo_km,
        )
        db.add(fila)
    else:
        fila.kilometros = intervalo_km

    db.commit()
    db.refresh(fila)

    proximos = calcular_proximos(db, vehiculo.id, vehiculo.kilometraje_actual)
    estado = next(item.estado for item in proximos if item.tipo == tipo)
    return ItemPlan(
        tipo=tipo,
        intervalo_km=fila.kilometros,
        intervalo_fabrica=INTERVALOS_KM[tipo],
        personalizado=True,
        estado=estado,
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
