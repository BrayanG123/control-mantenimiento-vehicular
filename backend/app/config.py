from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    database_url: str = "sqlite:///./mantenimiento.db"
    clave_secreta: str = "cambia-esta-clave-secreta-antes-de-publicar-la-api"
    duracion_token_minutos: int = 480

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()
