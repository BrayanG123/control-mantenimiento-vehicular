from datetime import date

from pydantic import BaseModel, ConfigDict, Field


class VehiculoBase(BaseModel):
    marca: str = Field(min_length=1, max_length=80)
    modelo: str = Field(min_length=1, max_length=80)
    anio: int = Field(ge=1980, le=date.today().year + 1)
    placa: str = Field(min_length=1, max_length=20)

    model_config = ConfigDict(str_strip_whitespace=True)


class VehiculoCreate(VehiculoBase):
    pass

class VehiculoUpdateKilometraje(BaseModel):
    kilometraje_actual: int = Field(ge=0)


class VehiculoResponse(VehiculoBase):
    id: int
    kilometraje_actual: int

    model_config = ConfigDict(from_attributes=True)
