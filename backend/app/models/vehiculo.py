from sqlalchemy import Column, ForeignKey, Integer, String
from app.database import Base

from sqlalchemy.orm import relationship



class Vehiculo(Base):
    __tablename__ = "vehiculos"

    id = Column(Integer, primary_key=True, index=True)
    marca  = Column(String,  nullable=False)
    modelo = Column(String,  nullable=False)
    anio   = Column(Integer, nullable=False)
    placa  = Column(String,  nullable=False)
    kilometraje_actual = Column(Integer, nullable=False, default=0)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), unique=True, nullable=False)

    mantenimientos = relationship(
        "Mantenimiento",
        back_populates="vehiculo",
        cascade="all, delete-orphan",
    )
    intervalos = relationship(
        "IntervaloVehiculo",
        back_populates="vehiculo",
        cascade="all, delete-orphan",
    )
    usuario = relationship("Usuario", back_populates="vehiculo")

