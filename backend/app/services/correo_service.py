import html
from pathlib import Path

import httpx

from app.config import settings
from app.core.excepciones import ServicioNoDisponible

_ARCHIVO_ENLACE_LOCAL = Path(__file__).resolve().parents[2] / "ultimo_enlace_recuperacion.txt"


def enviar_enlace_recuperacion(correo: str, enlace: str) -> None:
    if not settings.resend_api_key.strip():
        _guardar_enlace_local(correo, enlace)
        return

    contenido = (
        "<h2>Cambiar contraseña</h2>"
        "<p>Recibimos una solicitud para cambiar tu contraseña.</p>"
        f'<p><a href="{html.escape(enlace)}">Elegir contraseña nueva</a></p>'
        "<p>El enlace vence pronto y solo puede utilizarse una vez.</p>"
        "<p>Si no solicitaste el cambio, puedes ignorar este correo.</p>"
    )
    try:
        respuesta = httpx.post(
            "https://api.resend.com/emails",
            headers={
                "Authorization": f"Bearer {settings.resend_api_key}",
                "Content-Type": "application/json",
            },
            json={
                "from": settings.resend_remitente,
                "to": [correo],
                "subject": "Cambia tu contraseña",
                "html": contenido,
            },
            timeout=10,
        )
        respuesta.raise_for_status()
    except httpx.HTTPError as error:
        raise ServicioNoDisponible(
            "No se pudo enviar el correo de recuperación"
        ) from error


def _guardar_enlace_local(correo: str, enlace: str) -> None:
    """Sin Resend: deja el enlace en consola y en un archivo para la demo local."""
    texto = (
        "RECUPERACION LOCAL (sin RESEND_API_KEY)\n"
        f"Correo: {correo}\n"
        f"Enlace: {enlace}\n"
    )
    _ARCHIVO_ENLACE_LOCAL.write_text(texto, encoding="utf-8")
    print(texto, flush=True)
