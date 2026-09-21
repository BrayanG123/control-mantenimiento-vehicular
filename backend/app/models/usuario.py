from sqlalchemy import Boolean, Column, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import relationship

from app.database import Base


class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    correo = Column(String, unique=True, index=True, nullable=False)
    clave_hash = Column(String, nullable=False)
    version_sesion = Column(Integer, nullable=False, default=1)

    vehiculo = relationship("Vehiculo", back_populates="usuario", uselist=False)
    recuperaciones = relationship(
        "RecuperacionContrasena",
        back_populates="usuario",
        cascade="all, delete-orphan",
    )


class RecuperacionContrasena(Base):
    __tablename__ = "recuperaciones_contrasena"

    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    token_hash = Column(String, unique=True, index=True, nullable=False)
    expira_en = Column(DateTime, nullable=False)
    usado = Column(Boolean, nullable=False, default=False)

    usuario = relationship("Usuario", back_populates="recuperaciones")
