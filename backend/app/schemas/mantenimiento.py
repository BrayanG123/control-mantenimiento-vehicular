from datetime import date
from pydantic import BaseModel, ConfigDict
from app.core.intervalos import TipoMantenimiento




class MantenimientoBase(BaseModel):
    tipo: TipoMantenimiento
    fecha: date
    kilometraje: int
    costo: float | None = None


class MantenimientoCreate(MantenimientoBase):
    pass


class MantenimientoResponse(MantenimientoBase):
    id: int
    vehiculo_id: int

    model_config = ConfigDict(from_attributes=True)


class ProximoMantenimientoItem(BaseModel):
    tipo: TipoMantenimiento
    ultimo_kilometraje: int | None
    proximo_kilometraje: int
    kilometrajes_restantes: int
    vencido: bool