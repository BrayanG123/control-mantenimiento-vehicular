from pydantic import BaseModel, ConfigDict

class VehiculoBase(BaseModel):
    marca: str
    modelo: str
    anio: int
    placa: str | None = None


class VehiculoCreate(VehiculoBase):
    pass

class VehiculoUpdateKilometraje(BaseModel):
    kilometraje_actual: int

class VehiculoResponse(VehiculoBase):
    id: int
    kilometraje_actual: int

    model_config = ConfigDict(from_attributes=True)