import 'package:flutter/foundation.dart';

import '../data/mantenimiento_api.dart';
import '../models/mantenimiento.dart';
import '../core/utils/formato.dart';
import 'estado_carga.dart';

class ControladorGastosTipo extends ChangeNotifier {
  ControladorGastosTipo(this._mantenimientoApi);

  final MantenimientoApi _mantenimientoApi;

  EstadoCarga estado = EstadoCarga.inicial;
  List<Mantenimiento> mantenimientos = [];
  String? mensajeError;

  Future<void> cargarMantenimientos({
    required String tipo,
    required String periodo,
  }) async {
    estado = EstadoCarga.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      final historial = await _mantenimientoApi.obtenerHistorial();
      mantenimientos =
          historial
              .where(
                (mantenimiento) =>
                    mantenimiento.tipo == tipo &&
                    fechaPerteneceAlPeriodo(mantenimiento.fecha, periodo),
              )
              .toList()
            ..sort(
              (primero, segundo) =>
                  (segundo.costo ?? 0).compareTo(primero.costo ?? 0),
            );
      estado = EstadoCarga.completado;
    } catch (_) {
      mensajeError = 'No se pudieron cargar los mantenimientos';
      estado = EstadoCarga.error;
    }

    notifyListeners();
  }
}
