from datetime import date, timedelta

from sqlalchemy.orm import Session

from app.core.tipos import PeriodoGastos, TipoMantenimiento
from app.models.mantenimiento import Mantenimiento
from app.schemas.gastos import ItemGasto, ResumenGastos
from app.services.vehiculo_service import obtener_vehiculo


def obtener_resumen_gastos(
    db: Session,
    periodo: PeriodoGastos,
    usuario_id: int,
) -> ResumenGastos:
    vehiculo = obtener_vehiculo(db, usuario_id)
    fecha_actual = date.today()
    fecha_inicial = obtener_fecha_inicial(periodo, fecha_actual)

    consulta = db.query(Mantenimiento).filter(
        Mantenimiento.vehiculo_id == vehiculo.id
    )
    if fecha_inicial is not None:
        consulta = consulta.filter(Mantenimiento.fecha >= fecha_inicial)

    total = 0.0
    preventivo = 0.0
    reparacion = 0.0
    con_costo = 0
    sin_costo = 0
    totales_por_tipo: dict[str, dict[str, float | int]] = {}

    for mantenimiento in consulta.all():
        if mantenimiento.costo is None:
            sin_costo += 1
            continue

        con_costo += 1
        total += mantenimiento.costo

        if mantenimiento.tipo == TipoMantenimiento.CADENA:
            reparacion += mantenimiento.costo
        else:
            preventivo += mantenimiento.costo

        tipo = mantenimiento.tipo.value
        datos_tipo = totales_por_tipo.setdefault(
            tipo,
            {"total": 0.0, "cantidad": 0},
        )
        datos_tipo["total"] = float(datos_tipo["total"]) + mantenimiento.costo
        datos_tipo["cantidad"] = int(datos_tipo["cantidad"]) + 1

    gastos_por_tipo = [
        ItemGasto(
            tipo=tipo,
            total=float(datos["total"]),
            cantidad=int(datos["cantidad"]),
        )
        for tipo, datos in totales_por_tipo.items()
    ]
    gastos_por_tipo.sort(key=lambda gasto: gasto.total, reverse=True)

    return ResumenGastos(
        periodo=periodo,
        desde=fecha_inicial,
        hasta=fecha_actual,
        total=total,
        preventivo=preventivo,
        reparacion=reparacion,
        con_costo=con_costo,
        sin_costo=sin_costo,
        por_tipo=gastos_por_tipo,
    )


def obtener_fecha_inicial(
    periodo: PeriodoGastos,
    fecha_actual: date,
) -> date | None:
    if periodo == PeriodoGastos.TRES_MESES:
        return fecha_actual - timedelta(days=90)
    if periodo == PeriodoGastos.TODO:
        return None
    return date(fecha_actual.year, 1, 1)
