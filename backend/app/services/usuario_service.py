from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core.excepciones import OperacionNoPermitida
from app.core.seguridad import crear_hash_contrasena, verificar_contrasena
from app.models.usuario import Usuario
from app.schemas.usuario import CredencialesUsuario


def registrar_usuario(db: Session, credenciales: CredencialesUsuario) -> Usuario:
    usuario = Usuario(
        correo=credenciales.correo,
        clave_hash=crear_hash_contrasena(credenciales.contrasena),
    )
    db.add(usuario)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise OperacionNoPermitida("Ya existe una cuenta con ese correo")
    db.refresh(usuario)
    return usuario


def autenticar_usuario(
    db: Session,
    credenciales: CredencialesUsuario,
) -> Usuario | None:
    usuario = (
        db.query(Usuario)
        .filter(Usuario.correo == credenciales.correo)
        .first()
    )
    if usuario is None:
        return None
    if not verificar_contrasena(credenciales.contrasena, usuario.clave_hash):
        return None
    return usuario


def obtener_usuario_por_id(db: Session, usuario_id: int) -> Usuario | None:
    return db.get(Usuario, usuario_id)
