import re

from pydantic import BaseModel, ConfigDict, Field, field_validator


class CredencialesUsuario(BaseModel):
    correo: str = Field(min_length=3, max_length=254)
    contrasena: str = Field(min_length=6, max_length=128)

    model_config = ConfigDict(str_strip_whitespace=True)

    @field_validator("correo")
    @classmethod
    def validar_correo(cls, correo: str) -> str:
        correo_normalizado = correo.lower()
        if not re.fullmatch(r"[^@\s]+@[^@\s]+\.[^@\s]+", correo_normalizado):
            raise ValueError("El correo no tiene un formato válido")
        return correo_normalizado


class UsuarioResponse(BaseModel):
    id: int
    correo: str

    model_config = ConfigDict(from_attributes=True)


class SesionResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    usuario: UsuarioResponse


class SolicitudRecuperacion(BaseModel):
    correo: str = Field(min_length=3, max_length=254)

    model_config = ConfigDict(str_strip_whitespace=True)

    @field_validator("correo")
    @classmethod
    def validar_correo(cls, correo: str) -> str:
        return CredencialesUsuario.validar_correo(correo)


class RestablecimientoContrasena(BaseModel):
    token: str = Field(max_length=256)
    nueva_contrasena: str = Field(min_length=6, max_length=128)

    @field_validator("token")
    @classmethod
    def validar_token(cls, token: str) -> str:
        token_limpio = token.strip()
        if len(token_limpio) < 20:
            raise ValueError("El enlace no es válido o ya venció")
        return token_limpio


class MensajeResponse(BaseModel):
    mensaje: str
