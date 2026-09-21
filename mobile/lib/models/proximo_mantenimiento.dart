class ProximoMantenimiento {
  const ProximoMantenimiento({
    required this.tipo,
    required this.ultimoKilometraje,
    required this.proximoKilometraje,
    required this.kilometrosRestantes,
    required this.estaVencido,
    required this.estado,
  });

  final String tipo;
  final int? ultimoKilometraje;
  final int proximoKilometraje;
  final int kilometrosRestantes;
  final bool estaVencido;
  final String estado;

  factory ProximoMantenimiento.fromJson(Map<String, dynamic> json) {
    return ProximoMantenimiento(
      tipo: json['tipo'] as String,
      ultimoKilometraje: json['ultimo_kilometraje'] as int?,
      proximoKilometraje: json['proximo_kilometraje'] as int,
      kilometrosRestantes: json['kilometrajes_restantes'] as int,
      estaVencido: json['vencido'] as bool,
      estado: json['estado'] as String,
    );
  }
}
