from datetime import UTC, datetime, timedelta
from urllib.parse import urlencode

from sqlalchemy.orm import Session

from app.config import settings
from app.core.excepciones import OperacionNoPermitida
from app.core.seguridad import (
    crear_hash_contrasena,
    crear_hash_token,
    crear_token_recuperacion,
)
from app.models.usuario import RecuperacionContrasena, Usuario
from app.services.correo_service import enviar_enlace_recuperacion


def solicitar_recuperacion(db: Session, correo: str) -> None:
    usuario = db.query(Usuario).filter(Usuario.correo == correo).first()
    if usuario is None:
        return

    _invalidar_recuperaciones_anteriores(db, usuario.id)
    token = crear_token_recuperacion()
    recuperacion = RecuperacionContrasena(
        usuario_id=usuario.id,
        token_hash=crear_hash_token(token),
        expira_en=_ahora() + timedelta(
            minutes=settings.duracion_recuperacion_minutos
        ),
    )
    db.add(recuperacion)
    db.commit()

    parametros = urlencode({"token_recuperacion": token})
    enlace = f"{settings.url_mobile.rstrip('/')}?{parametros}"
    enviar_enlace_recuperacion(usuario.correo, enlace)


def restablecer_contrasena(
    db: Session,
    token: str,
    nueva_contrasena: str,
) -> None:
    recuperacion = (
        db.query(RecuperacionContrasena)
        .filter(
            RecuperacionContrasena.token_hash == crear_hash_token(token),
            RecuperacionContrasena.usado.is_(False),
        )
        .first()
    )
    if recuperacion is None or recuperacion.expira_en <= _ahora():
        raise OperacionNoPermitida("El enlace no es válido o ya venció")

    usuario = db.get(Usuario, recuperacion.usuario_id)
    if usuario is None:
        raise OperacionNoPermitida("El enlace no es válido o ya venció")

    usuario.clave_hash = crear_hash_contrasena(nueva_contrasena)
    usuario.version_sesion += 1
    _invalidar_recuperaciones_anteriores(db, usuario.id)
    db.commit()


def _invalidar_recuperaciones_anteriores(db: Session, usuario_id: int) -> None:
    recuperaciones = (
        db.query(RecuperacionContrasena)
        .filter(
            RecuperacionContrasena.usuario_id == usuario_id,
            RecuperacionContrasena.usado.is_(False),
        )
        .all()
    )
    for recuperacion in recuperaciones:
        recuperacion.usado = True


def _ahora() -> datetime:
    return datetime.now(UTC).replace(tzinfo=None)
