from enum import Enum


class TipoMantenimiento(str, Enum):
    ACEITE = "aceite"
    LLANTAS = "llantas"
    FRENOS = "frenos"
    FILTROS = "filtros"
    CADENA = "cadena"


class EstadoMantenimiento(str, Enum):
    VENCIDO = "vencido"
    PROXIMO = "proximo"
    AL_DIA = "al_dia"


class PeriodoGastos(str, Enum):
    ESTE_ANIO = "este_anio"
    TRES_MESES = "3_meses"
    TODO = "todo"
