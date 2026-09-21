import '../core/network/cliente_api.dart';
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
}
