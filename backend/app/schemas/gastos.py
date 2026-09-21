from datetime import date

from pydantic import BaseModel

from app.core.tipos import PeriodoGastos


class ItemGasto(BaseModel):
    tipo: str
    total: float
    cantidad: int


class ResumenGastos(BaseModel):
    periodo: PeriodoGastos
    desde: date | None
    hasta: date
    total: float
    preventivo: float
    reparacion: float
    con_costo: int
    sin_costo: int
    por_tipo: list[ItemGasto]
