import '../core/network/cliente_api.dart';
import '../models/item_plan.dart';
import '../models/mantenimiento.dart';
import '../models/proximo_mantenimiento.dart';

class MantenimientoApi {
  MantenimientoApi(this._clienteApi);

  final ClienteApi _clienteApi;

  Future<List<ProximoMantenimiento>> obtenerProximos() async {
    final respuesta = await _clienteApi.obtener('/mantenimiento/proximo');
    return (respuesta as List<dynamic>)
        .map(
          (item) => ProximoMantenimiento.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<Mantenimiento>> obtenerHistorial() async {
    final respuesta = await _clienteApi.obtener('/mantenimiento/historial');
    return (respuesta as List<dynamic>)
        .map((item) => Mantenimiento.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Mantenimiento> registrarMantenimiento(
    DatosNuevoMantenimiento datos,
  ) async {
    final respuesta = await _clienteApi.enviar(
      '/mantenimiento/',
      datos.toJson(),
    );
    return Mantenimiento.fromJson(respuesta as Map<String, dynamic>);
  }

  Future<List<ItemPlan>> obtenerPlan() async {
    final respuesta = await _clienteApi.obtener('/mantenimiento/plan');
    return (respuesta as List<dynamic>)
        .map((item) => ItemPlan.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ItemPlan> actualizarIntervalo(String tipo, int intervaloKm) async {
    final respuesta = await _clienteApi.actualizar(
      '/mantenimiento/plan/$tipo',
      {'intervalo_km': intervaloKm},
    );
    return ItemPlan.fromJson(respuesta as Map<String, dynamic>);
  }
}
