import 'package:flutter/foundation.dart';

import '../data/mantenimiento_api.dart';
import '../models/mantenimiento.dart';
import 'estado_carga.dart';

class ControladorHistorial extends ChangeNotifier {
  ControladorHistorial(this._mantenimientoApi);

  final MantenimientoApi _mantenimientoApi;

  EstadoCarga estado = EstadoCarga.inicial;
  List<Mantenimiento> mantenimientos = [];
  String? mensajeError;

  Future<void> cargarHistorial() async {
    estado = EstadoCarga.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      mantenimientos = await _mantenimientoApi.obtenerHistorial();
      estado = EstadoCarga.completado;
    } catch (_) {
      mensajeError = 'No se pudo cargar el historial';
      estado = EstadoCarga.error;
    }

    notifyListeners();
  }
}
