import 'package:flutter/foundation.dart';

import '../data/gastos_api.dart';
import '../data/mantenimiento_api.dart';
import '../data/vehiculo_api.dart';
import '../models/proximo_mantenimiento.dart';
import '../models/resumen_gastos.dart';
import '../models/vehiculo.dart';
import 'estado_carga.dart';

class ControladorInicio extends ChangeNotifier {
  factory ControladorInicio({
    required VehiculoApi vehiculoApi,
    required MantenimientoApi mantenimientoApi,
    required GastosApi gastosApi,
  }) {
    return ControladorInicio._(vehiculoApi, mantenimientoApi, gastosApi);
  }

  ControladorInicio._(
    this._vehiculoApi,
    this._mantenimientoApi,
    this._gastosApi,
  );

  final VehiculoApi _vehiculoApi;
  final MantenimientoApi _mantenimientoApi;
  final GastosApi _gastosApi;

  EstadoCarga estado = EstadoCarga.inicial;
  Vehiculo? vehiculo;
  List<ProximoMantenimiento> proximosMantenimientos = [];
  ResumenGastos? resumenGastos;
  String? mensajeError;

  Future<void> cargarInicio() async {
    estado = EstadoCarga.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      vehiculo = await _vehiculoApi.obtenerVehiculo();
      proximosMantenimientos = await _mantenimientoApi.obtenerProximos();
      resumenGastos = await _gastosApi.obtenerResumen();
      estado = EstadoCarga.completado;
    } catch (_) {
      mensajeError = 'No se pudo cargar el inicio';
      estado = EstadoCarga.error;
    }

    notifyListeners();
  }
}
