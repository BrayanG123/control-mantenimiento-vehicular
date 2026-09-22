from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    database_url: str = "sqlite:///./mantenimiento.db"
    clave_secreta: str = "cambia-esta-clave-secreta-antes-de-publicar-la-api"
    duracion_token_minutos: int = 480
    duracion_recuperacion_minutos: int = 15
    resend_api_key: str = ""
    resend_remitente: str = "Mantenimiento <onboarding@resend.dev>"
    url_mobile: str = "http://127.0.0.1:8080"

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()
