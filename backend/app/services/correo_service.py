import html

import httpx

from app.config import settings
from app.core.excepciones import ServicioNoDisponible


def enviar_enlace_recuperacion(correo: str, enlace: str) -> None:
    if not settings.resend_api_key:
        raise ServicioNoDisponible("El servicio de correo no está configurado")

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
        raise ServicioNoDisponible("No se pudo enviar el correo de recuperación") from error
