class Vehiculo {
  int id;
  String marca;
  String modelo;
  int anio;
  String? placa;
  int kilometraje_actual;

  Vehiculo({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.placa,
    required this.kilometraje_actual,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      placa: json['placa'],
      kilometraje_actual: json['kilometraje_actual'],
    );
  }
}

class ProximoItem {
  String tipo;
  int? ultimo_kilometraje;
  int proximo_kilometraje;
  int kilometrajes_restantes;
  bool vencido;

  ProximoItem({
    required this.tipo,
    this.ultimo_kilometraje,
    required this.proximo_kilometraje,
    required this.kilometrajes_restantes,
    required this.vencido,
  });

  factory ProximoItem.fromJson(Map<String, dynamic> json) {
    return ProximoItem(
      tipo: json['tipo'],
      ultimo_kilometraje: json['ultimo_kilometraje'],
      proximo_kilometraje: json['proximo_kilometraje'],
      kilometrajes_restantes: json['kilometrajes_restantes'],
      vencido: json['vencido'],
    );
  }
}

class Mantenimiento {
  int id;
  int vehiculo_id;
  String tipo;
  DateTime fecha;
  int kilometraje;
  int proximo_kilometraje;
  double? costo;

  Mantenimiento({
    required this.id,
    required this.vehiculo_id,
    required this.tipo,
    required this.fecha,
    required this.kilometraje,
    required this.proximo_kilometraje,
    this.costo,
  });

  factory Mantenimiento.fromJson(Map<String, dynamic> json) {
    return Mantenimiento(
      id: json['id'],
      vehiculo_id: json['vehiculo_id'],
      tipo: json['tipo'],
      fecha: DateTime.parse(json['fecha']),
      kilometraje: json['kilometraje'],
      proximo_kilometraje: json['proximo_kilometraje'],
      costo: (json['costo'] as num?)?.toDouble(),
    );
  }
}
