from datetime import date
from pydantic import BaseModel, ConfigDict, Field, field_validator

from app.core.tipos import EstadoMantenimiento, TipoMantenimiento


class MantenimientoBase(BaseModel):
    tipo: TipoMantenimiento
    fecha: date
    kilometraje: int = Field(gt=0)
    costo: float | None = Field(default=None, ge=0)

    @field_validator("fecha")
    @classmethod
    def validar_fecha(cls, fecha: date) -> date:
        if fecha > date.today():
            raise ValueError("La fecha del mantenimiento no puede ser futura")
        return fecha


class MantenimientoCreate(MantenimientoBase):
    pass


class MantenimientoResponse(MantenimientoBase):
    id: int
    vehiculo_id: int
    proximo_kilometraje: int

    model_config = ConfigDict(from_attributes=True)


class ProximoMantenimientoItem(BaseModel):
    tipo: TipoMantenimiento
    ultimo_kilometraje: int | None
    proximo_kilometraje: int
    kilometrajes_restantes: int
    vencido: bool
    estado: EstadoMantenimiento
