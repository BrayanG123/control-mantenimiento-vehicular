from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship

from app.database import Base


class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    correo = Column(String, unique=True, index=True, nullable=False)
    clave_hash = Column(String, nullable=False)

    vehiculo = relationship("Vehiculo", back_populates="usuario", uselist=False)
