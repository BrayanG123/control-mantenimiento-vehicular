from datetime import date, timedelta
from sqlalchemy.orm import Session
from app.models.mantenimiento import Mantenimiento
from app.core.intervalos import TipoMantenimiento, INTERVALOS_KM
from app.schemas.mantenimiento import (
    ProximoMantenimientoItem,
    ItemGasto,
    ResumenGastos,
)



def calcular_proximo_mantenimiento(
    db: Session, 
    vehiculo_id: int,
    kilometraje_actual: int
) -> list[ProximoMantenimientoItem]:
    resultado = []

    for tipo in TipoMantenimiento:
        # cadena no es periodico
        if tipo == TipoMantenimiento.CADENA:
            continue

        ultimo = (
            db.query(Mantenimiento).filter(
                Mantenimiento.vehiculo_id == vehiculo_id,
                Mantenimiento.tipo == tipo,
            )
            .order_by(Mantenimiento.kilometraje.desc())
            .first()
        )

        ultimo_km = ultimo.kilometraje if ultimo else 0
        intervalo = INTERVALOS_KM[tipo]
        proximo_km = ultimo_km + intervalo
        restantes = proximo_km - kilometraje_actual

        resultado.append(
            ProximoMantenimientoItem(
                tipo=tipo,
                ultimo_kilometraje=ultimo.kilometraje if ultimo else None,
                proximo_kilometraje=proximo_km,
                kilometrajes_restantes=restantes,
                vencido=restantes <= 0,
            )
        )

    return resultado


def calcular_gastos(db: Session, vehiculo_id: int, periodo: str) -> ResumenGastos:
    hoy = date.today()

    if periodo == "3_meses":
        desde = hoy - timedelta(days=90)
    elif periodo == "todo":
        desde = None
    else:
        periodo = "este_anio"
        desde = date(hoy.year, 1, 1)

    q = db.query(Mantenimiento).filter(Mantenimiento.vehiculo_id == vehiculo_id)
    if desde is not None:
        q = q.filter(Mantenimiento.fecha >= desde)

    filas = q.all()

    total = 0.0
    preventivo = 0.0
    reparacion = 0.0
    con_costo = 0
    sin_costo = 0
    por_tipo_map = {}

    for m in filas:
        if m.costo is None:
            sin_costo += 1
            continue

        con_costo += 1
        total += m.costo

        if m.tipo == TipoMantenimiento.CADENA:
            reparacion += m.costo
        else:
            preventivo += m.costo

        key = m.tipo.value
        if key not in por_tipo_map:
            por_tipo_map[key] = {"total": 0.0, "cantidad": 0}
        por_tipo_map[key]["total"] += m.costo
        por_tipo_map[key]["cantidad"] += 1

    por_tipo = []
    for tipo, datos in por_tipo_map.items():
        por_tipo.append(
            ItemGasto(tipo=tipo, total=datos["total"], cantidad=datos["cantidad"])
        )
    por_tipo.sort(key=lambda x: x.total, reverse=True)

    return ResumenGastos(
        periodo=periodo,
        desde=desde,
        hasta=hoy,
        total=total,
        preventivo=preventivo,
        reparacion=reparacion,
        con_costo=con_costo,
        sin_costo=sin_costo,
        por_tipo=por_tipo,
    )
