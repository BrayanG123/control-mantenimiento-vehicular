from app.core.tipos import TipoMantenimiento


INTERVALOS_KM: dict[TipoMantenimiento, int] = {
    TipoMantenimiento.ACEITE:  5000,
    TipoMantenimiento.LLANTAS: 20000,
    TipoMantenimiento.FRENOS:  15000,
    TipoMantenimiento.FILTROS: 10000,
    TipoMantenimiento.CADENA:  5000,
}
