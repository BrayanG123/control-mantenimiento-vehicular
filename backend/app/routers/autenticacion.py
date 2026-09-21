from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.autenticacion import obtener_usuario_actual
from app.core.seguridad import crear_token_acceso
from app.database import get_db
from app.models.usuario import Usuario
from app.schemas.usuario import (
    CredencialesUsuario,
    SesionResponse,
    UsuarioResponse,
)
from app.services import usuario_service


router = APIRouter(prefix="/autenticacion", tags=["Autenticación"])


@router.post("/registro", response_model=SesionResponse, status_code=201)
def registrar_usuario(
    credenciales: CredencialesUsuario,
    db: Session = Depends(get_db),
):
    usuario = usuario_service.registrar_usuario(db, credenciales)
    return _crear_respuesta_sesion(usuario)


@router.post("/inicio-sesion", response_model=SesionResponse)
def iniciar_sesion(
    credenciales: CredencialesUsuario,
    db: Session = Depends(get_db),
):
    usuario = usuario_service.autenticar_usuario(db, credenciales)
    if usuario is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Correo o contraseña no coinciden",
        )
    return _crear_respuesta_sesion(usuario)


@router.get("/sesion", response_model=UsuarioResponse)
def obtener_sesion(usuario: Usuario = Depends(obtener_usuario_actual)):
    return usuario


def _crear_respuesta_sesion(usuario: Usuario) -> SesionResponse:
    return SesionResponse(
        access_token=crear_token_acceso(usuario.id),
        usuario=UsuarioResponse.model_validate(usuario),
    )
