import 'package:flutter/foundation.dart';

import '../data/mantenimiento_api.dart';
import '../data/vehiculo_api.dart';
import '../models/item_plan.dart';
import '../models/vehiculo.dart';
import 'estado_carga.dart';

class ControladorPlan extends ChangeNotifier {
  ControladorPlan(this._mantenimientoApi, this._vehiculoApi);

  final MantenimientoApi _mantenimientoApi;
  final VehiculoApi _vehiculoApi;

  EstadoCarga estado = EstadoCarga.inicial;
  List<ItemPlan> items = [];
  Vehiculo? vehiculo;
  String? mensajeError;

  Future<void> cargar() async {
    estado = EstadoCarga.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      vehiculo = await _vehiculoApi.obtenerVehiculo();
      items = await _mantenimientoApi.obtenerPlan();
      estado = EstadoCarga.completado;
    } catch (_) {
      mensajeError = 'No se pudo cargar el plan';
      estado = EstadoCarga.error;
    }

    notifyListeners();
  }
}
