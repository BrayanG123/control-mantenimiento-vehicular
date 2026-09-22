from sqlalchemy import Column, Integer, String, Date, Float, ForeignKey, Enum as SAEnum
from sqlalchemy.orm import relationship
from app.database import Base
from app.core.intervalos import INTERVALOS_KM
from app.core.tipos import TipoMantenimiento



class Mantenimiento(Base):
    __tablename__ = "mantenimientos"

    id = Column(Integer, primary_key=True, index=True)
    vehiculo_id = Column(Integer, ForeignKey("vehiculos.id"), nullable=False)
    tipo = Column(SAEnum(TipoMantenimiento), nullable=False)
    fecha = Column(Date, nullable=False)
    kilometraje = Column(Integer, nullable=False)
    costo = Column(Float, nullable=True)

    vehiculo = relationship("Vehiculo", back_populates="mantenimientos")

    @property
    def proximo_kilometraje(self) -> int:
        intervalo = INTERVALOS_KM[self.tipo]
        if self.vehiculo is not None:
            for fila in self.vehiculo.intervalos:
                if fila.tipo == self.tipo:
                    intervalo = fila.kilometros
                    break
        return self.kilometraje + intervalo
