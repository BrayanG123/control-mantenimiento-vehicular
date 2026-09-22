from pathlib import Path

from sqlalchemy import create_engine, inspect, text
from sqlalchemy.orm import sessionmaker, declarative_base
from app.config import settings


if settings.database_url.startswith("sqlite:///"):
    ruta = settings.database_url.replace("sqlite:///", "", 1)
    Path(ruta).parent.mkdir(parents=True, exist_ok=True)

argumentos_conexion = (
    {"check_same_thread": False}
    if settings.database_url.startswith("sqlite")
    else {}
)

engine = create_engine(settings.database_url, connect_args=argumentos_conexion)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)

Base = declarative_base()


def preparar_base_de_datos() -> None:
    Base.metadata.create_all(bind=engine)
    columnas_usuario = {
        columna["name"] for columna in inspect(engine).get_columns("usuarios")
    }
    if "version_sesion" not in columnas_usuario:
        with engine.begin() as conexion:
            conexion.execute(
                text(
                    "ALTER TABLE usuarios "
                    "ADD COLUMN version_sesion INTEGER NOT NULL DEFAULT 1"
                )
            )
    columnas_vehiculo = {
        columna["name"] for columna in inspect(engine).get_columns("vehiculos")
    }
    if "usuario_id" not in columnas_vehiculo:
        with engine.begin() as conexion:
            conexion.execute(text("ALTER TABLE vehiculos ADD COLUMN usuario_id INTEGER"))


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
