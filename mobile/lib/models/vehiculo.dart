class Vehiculo {
  const Vehiculo({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.placa,
    required this.kilometrajeActual,
  });

  final int id;
  final String marca;
  final String modelo;
  final int anio;
  final String? placa;
  final int kilometrajeActual;

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'] as int,
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anio: json['anio'] as int,
      placa: json['placa'] as String?,
      kilometrajeActual: json['kilometraje_actual'] as int,
    );
  }
}

class DatosNuevoVehiculo {
  const DatosNuevoVehiculo({
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.placa,
  });

  final String marca;
  final String modelo;
  final int anio;
  final String placa;

  Map<String, dynamic> toJson() {
    return {'marca': marca, 'modelo': modelo, 'anio': anio, 'placa': placa};
  }
}
