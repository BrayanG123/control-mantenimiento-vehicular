from app.core.tipos import TipoMantenimiento


# fabrica. El de aceite es 4.000 porque el flujo de Mariana parte de ahi
# (uso promedio) y ella lo baja a 3.000 por uso intensivo.
INTERVALOS_KM: dict[TipoMantenimiento, int] = {
    TipoMantenimiento.ACEITE:  4000,
    TipoMantenimiento.LLANTAS: 20000,
    TipoMantenimiento.FRENOS:  15000,
    TipoMantenimiento.FILTROS: 10000,
    TipoMantenimiento.CADENA:  5000,
}

MINIMO_INTERVALO_KM = 500

# lo que se puede ajustar. La cadena no es periodica.
TIPOS_CON_INTERVALO = (
    TipoMantenimiento.ACEITE,
    TipoMantenimiento.FRENOS,
    TipoMantenimiento.LLANTAS,
    TipoMantenimiento.FILTROS,
)
