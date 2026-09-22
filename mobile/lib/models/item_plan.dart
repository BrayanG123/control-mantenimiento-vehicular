class ItemPlan {
  const ItemPlan({
    required this.tipo,
    required this.intervaloKm,
    required this.intervaloFabrica,
    required this.personalizado,
    required this.estado,
  });

  final String tipo;
  final int intervaloKm;
  final int intervaloFabrica;
  final bool personalizado;
  final String estado;

  factory ItemPlan.fromJson(Map<String, dynamic> json) {
    return ItemPlan(
      tipo: json['tipo'] as String,
      intervaloKm: json['intervalo_km'] as int,
      intervaloFabrica: json['intervalo_fabrica'] as int,
      personalizado: json['personalizado'] as bool,
      estado: json['estado'] as String,
    );
  }
}
