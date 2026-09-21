import 'package:flutter/foundation.dart';

import '../data/vehiculo_api.dart';
import '../models/vehiculo.dart';
import 'estado_carga.dart';

class ControladorVehiculo extends ChangeNotifier {
  ControladorVehiculo(this._vehiculoApi);

  final VehiculoApi _vehiculoApi;

  EstadoCarga estado = EstadoCarga.inicial;
  Vehiculo? vehiculo;
  String? mensajeError;
  bool estaGuardando = false;

  Future<void> cargarVehiculo() async {
    estado = EstadoCarga.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      vehiculo = await _vehiculoApi.obtenerVehiculo();
      estado = EstadoCarga.completado;
    } catch (_) {
      mensajeError = 'No se pudo cargar el vehículo';
      estado = EstadoCarga.error;
    }

    notifyListeners();
  }

  Future<bool> actualizarKilometraje(int nuevoKilometraje) async {
    estaGuardando = true;
    mensajeError = null;
    notifyListeners();

    try {
      vehiculo = await _vehiculoApi.actualizarKilometraje(nuevoKilometraje);
      estaGuardando = false;
      notifyListeners();
      return true;
    } catch (_) {
      mensajeError = 'No se pudo actualizar el kilometraje';
      estaGuardando = false;
      notifyListeners();
      return false;
    }
  }
}
