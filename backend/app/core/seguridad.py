import base64
import hashlib
import hmac
import json
import secrets
from dataclasses import dataclass
from datetime import UTC, datetime, timedelta

from app.config import settings


def crear_hash_contrasena(contrasena: str) -> str:
    sal = secrets.token_bytes(16)
    clave = hashlib.scrypt(
        contrasena.encode(),
        salt=sal,
        n=16384,
        r=8,
        p=1,
        dklen=64,
    )
    return "$".join(
        [
            "scrypt",
            _codificar(sal),
            _codificar(clave),
        ]
    )


def verificar_contrasena(contrasena: str, hash_guardado: str) -> bool:
    partes = hash_guardado.split("$")
    if len(partes) != 3 or partes[0] != "scrypt":
        return False
    try:
        sal = _decodificar(partes[1])
        clave_esperada = _decodificar(partes[2])
        clave_recibida = hashlib.scrypt(
            contrasena.encode(),
            salt=sal,
            n=16384,
            r=8,
            p=1,
            dklen=64,
        )
    except (TypeError, ValueError):
        return False
    return hmac.compare_digest(clave_recibida, clave_esperada)


@dataclass(frozen=True)
class DatosTokenAcceso:
    usuario_id: int
    version_sesion: int


def crear_token_acceso(usuario_id: int, version_sesion: int = 1) -> str:
    encabezado = _codificar_json({"alg": "HS256", "typ": "JWT"})
    expiracion = datetime.now(UTC) + timedelta(
        minutes=settings.duracion_token_minutos
    )
    contenido = _codificar_json(
        {
            "sub": str(usuario_id),
            "exp": int(expiracion.timestamp()),
            "ver": version_sesion,
        }
    )
    mensaje = f"{encabezado}.{contenido}".encode()
    firma = hmac.new(
        settings.clave_secreta.encode(),
        mensaje,
        hashlib.sha256,
    ).digest()
    return f"{encabezado}.{contenido}.{_codificar(firma)}"


def obtener_datos_desde_token(token: str) -> DatosTokenAcceso | None:
    partes = token.split(".")
    if len(partes) != 3:
        return None
    encabezado, contenido, firma_recibida = partes
    try:
        firma_esperada = hmac.new(
            settings.clave_secreta.encode(),
            f"{encabezado}.{contenido}".encode(),
            hashlib.sha256,
        ).digest()
        if not hmac.compare_digest(firma_esperada, _decodificar(firma_recibida)):
            return None
        datos = json.loads(_decodificar(contenido))
        if int(datos["exp"]) <= int(datetime.now(UTC).timestamp()):
            return None
        return DatosTokenAcceso(
            usuario_id=int(datos["sub"]),
            version_sesion=int(datos.get("ver", 1)),
        )
    except (KeyError, TypeError, ValueError, json.JSONDecodeError):
        return None


def obtener_usuario_id_desde_token(token: str) -> int | None:
    datos = obtener_datos_desde_token(token)
    return datos.usuario_id if datos is not None else None


def crear_token_recuperacion() -> str:
    return secrets.token_urlsafe(32)


def crear_hash_token(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()


def _codificar(valor: bytes) -> str:
    return base64.urlsafe_b64encode(valor).rstrip(b"=").decode()


def _decodificar(valor: str) -> bytes:
    relleno = "=" * (-len(valor) % 4)
    return base64.urlsafe_b64decode(f"{valor}{relleno}")


def _codificar_json(datos: dict[str, str | int]) -> str:
    contenido = json.dumps(datos, separators=(",", ":")).encode()
    return _codificar(contenido)
