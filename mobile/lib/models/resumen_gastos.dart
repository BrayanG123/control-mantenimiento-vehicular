class GastoPorTipo {
  const GastoPorTipo({
    required this.tipo,
    required this.total,
    required this.cantidad,
  });

  final String tipo;
  final double total;
  final int cantidad;

  factory GastoPorTipo.fromJson(Map<String, dynamic> json) {
    return GastoPorTipo(
      tipo: json['tipo'] as String,
      total: (json['total'] as num).toDouble(),
      cantidad: json['cantidad'] as int,
    );
  }
}

class ResumenGastos {
  const ResumenGastos({
    required this.periodo,
    required this.desde,
    required this.hasta,
    required this.total,
    required this.preventivo,
    required this.reparacion,
    required this.conCosto,
    required this.sinCosto,
    required this.porTipo,
  });

  final String periodo;
  final DateTime? desde;
  final DateTime hasta;
  final double total;
  final double preventivo;
  final double reparacion;
  final int conCosto;
  final int sinCosto;
  final List<GastoPorTipo> porTipo;

  factory ResumenGastos.fromJson(Map<String, dynamic> json) {
    final gastosPorTipo = json['por_tipo'] as List<dynamic>;
    return ResumenGastos(
      periodo: json['periodo'] as String,
      desde: json['desde'] == null
          ? null
          : DateTime.parse(json['desde'] as String),
      hasta: DateTime.parse(json['hasta'] as String),
      total: (json['total'] as num).toDouble(),
      preventivo: (json['preventivo'] as num).toDouble(),
      reparacion: (json['reparacion'] as num).toDouble(),
      conCosto: json['con_costo'] as int,
      sinCosto: json['sin_costo'] as int,
      porTipo: gastosPorTipo
          .map((item) => GastoPorTipo.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
