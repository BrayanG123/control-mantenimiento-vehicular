from enum import Enum


class TipoMantenimiento(str, Enum):
    ACEITE = "aceite"
    LLANTAS = "llantas"
    FRENOS = "frenos"
    FILTROS = "filtros"
    # reparacion, no va en el semaforo de inicio
    CADENA = "cadena"


INTERVALOS_KM: dict[TipoMantenimiento, int] = {
    TipoMantenimiento.ACEITE:  5000,
    TipoMantenimiento.LLANTAS: 20000,
    TipoMantenimiento.FRENOS:  15000,
    TipoMantenimiento.FILTROS: 10000,
    TipoMantenimiento.CADENA:  5000,
}
