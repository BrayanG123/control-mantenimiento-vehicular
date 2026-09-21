class ErrorDominio(Exception):
    def __init__(self, mensaje: str):
        self.mensaje = mensaje
        super().__init__(mensaje)


class RecursoNoEncontrado(ErrorDominio):
    pass


class OperacionNoPermitida(ErrorDominio):
    pass
