from sqlalchemy import Column, Integer, String
from app.database import Base

class Vehiculo(Base):
    __tablename__ = "vehiculos"

    id = Column(Integer, primary_key=True, index=True)
    marca  = Column(String,  nullable=False)
    modelo = Column(String,  nullable=False)
    anio   = Column(Integer, nullable=False)
    placa  = Column(String,  nullable=False)
    kilometraje_actual = Column(Integer, nullable=False, default=0)

    