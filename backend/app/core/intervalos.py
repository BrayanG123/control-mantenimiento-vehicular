from enum import Enum


class TipoMantenimiento(str, Enum):
    ACEITE = "aceite"
    LLANTAS = "llantas"
    FRENOS = "frenos"
    FILTROS = "filtros"


INTERVALOS_KM: dict[TipoMantenimiento, int] = {
    TipoMantenimiento.ACEITE:  5000,
    TipoMantenimiento.LLANTAS: 20000,
    TipoMantenimiento.FRENOS:  15000,
    TipoMantenimiento.FILTROS: 10000,
}