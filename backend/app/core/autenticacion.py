from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from app.core.seguridad import obtener_datos_desde_token
from app.database import get_db
from app.models.usuario import Usuario
from app.services.usuario_service import obtener_usuario_por_id


esquema_bearer = HTTPBearer(auto_error=False)


def obtener_usuario_actual(
    credenciales: HTTPAuthorizationCredentials | None = Depends(esquema_bearer),
    db: Session = Depends(get_db),
) -> Usuario:
    if credenciales is None:
        raise _error_sesion_invalida()
    datos_token = obtener_datos_desde_token(credenciales.credentials)
    if datos_token is None:
        raise _error_sesion_invalida()
    usuario = obtener_usuario_por_id(db, datos_token.usuario_id)
    if usuario is None or usuario.version_sesion != datos_token.version_sesion:
        raise _error_sesion_invalida()
    return usuario


def _error_sesion_invalida() -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="La sesión no es válida o venció",
        headers={"WWW-Authenticate": "Bearer"},
    )
