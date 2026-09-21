class ErrorApi implements Exception {
  const ErrorApi(this.mensaje, {this.codigoEstado});

  final String mensaje;
  final int? codigoEstado;

  @override
  String toString() => mensaje;
}
