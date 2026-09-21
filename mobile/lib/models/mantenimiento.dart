class Mantenimiento {
  const Mantenimiento({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.fecha,
    required this.kilometraje,
    required this.proximoKilometraje,
    this.costo,
  });

  final int id;
  final int vehiculoId;
  final String tipo;
  final DateTime fecha;
  final int kilometraje;
  final int proximoKilometraje;
  final double? costo;

  factory Mantenimiento.fromJson(Map<String, dynamic> json) {
    return Mantenimiento(
      id: json['id'] as int,
      vehiculoId: json['vehiculo_id'] as int,
      tipo: json['tipo'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      kilometraje: json['kilometraje'] as int,
      proximoKilometraje: json['proximo_kilometraje'] as int,
      costo: (json['costo'] as num?)?.toDouble(),
    );
  }
}

class DatosNuevoMantenimiento {
  const DatosNuevoMantenimiento({
    required this.tipo,
    required this.fecha,
    required this.kilometraje,
    this.costo,
  });

  final String tipo;
  final DateTime fecha;
  final int kilometraje;
  final double? costo;

  Map<String, dynamic> toJson() {
    final anio = fecha.year.toString().padLeft(4, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final dia = fecha.day.toString().padLeft(2, '0');
    return {
      'tipo': tipo,
      'fecha': '$anio-$mes-$dia',
      'kilometraje': kilometraje,
      if (costo != null) 'costo': costo,
    };
  }
}
