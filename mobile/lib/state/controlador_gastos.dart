import 'package:flutter/foundation.dart';

import '../data/gastos_api.dart';
import '../models/resumen_gastos.dart';
import 'estado_carga.dart';

class ControladorGastos extends ChangeNotifier {
  ControladorGastos(this._gastosApi);

  final GastosApi _gastosApi;

  EstadoCarga estado = EstadoCarga.inicial;
  ResumenGastos? resumen;
  String periodoSeleccionado = 'este_anio';
  String? mensajeError;

  Future<void> cargarGastos() async {
    estado = EstadoCarga.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      resumen = await _gastosApi.obtenerResumen(periodo: periodoSeleccionado);
      estado = EstadoCarga.completado;
    } catch (_) {
      mensajeError = 'No se pudieron cargar los gastos';
      estado = EstadoCarga.error;
    }

    notifyListeners();
  }

  Future<void> seleccionarPeriodo(String periodo) async {
    if (periodo == periodoSeleccionado) return;
    periodoSeleccionado = periodo;
    await cargarGastos();
  }
}
