from sqlalchemy.orm import Session
from app.models.mantenimiento import Mantenimiento
from app.core.intervalos import TipoMantenimiento, INTERVALOS_KM
from app.schemas.mantenimiento import ProximoMantenimientoItem



def calcular_proximo_mantenimiento(
    db: Session, 
    vehiculo_id: int,
    kilometraje_actual: int
) -> list[ProximoMantenimientoItem]:
    resultado = []

    for tipo in TipoMantenimiento:
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

        return resultados