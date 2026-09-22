from sqlalchemy import Column, ForeignKey, Integer, UniqueConstraint, Enum as SAEnum
from sqlalchemy.orm import relationship

from app.core.tipos import TipoMantenimiento
from app.database import Base


class IntervaloVehiculo(Base):
    __tablename__ = "intervalos_vehiculo"
    __table_args__ = (
        UniqueConstraint("vehiculo_id", "tipo", name="uq_intervalo_vehiculo_tipo"),
    )

    id = Column(Integer, primary_key=True, index=True)
    vehiculo_id = Column(Integer, ForeignKey("vehiculos.id"), nullable=False)
    tipo = Column(SAEnum(TipoMantenimiento), nullable=False)
    kilometros = Column(Integer, nullable=False)

    vehiculo = relationship("Vehiculo", back_populates="intervalos")
