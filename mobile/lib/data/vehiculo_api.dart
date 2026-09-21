import '../core/network/cliente_api.dart';
import '../core/network/error_api.dart';
import '../models/vehiculo.dart';

class VehiculoApi {
  VehiculoApi(this._clienteApi);

  final ClienteApi _clienteApi;

  Future<Vehiculo?> obtenerVehiculo() async {
    try {
      final respuesta = await _clienteApi.obtener('/vehiculo/');
      return Vehiculo.fromJson(respuesta as Map<String, dynamic>);
    } on ErrorApi catch (error) {
      if (error.codigoEstado == 404) return null;
      rethrow;
    }
  }

  Future<Vehiculo> registrarVehiculo(DatosNuevoVehiculo datos) async {
    final respuesta = await _clienteApi.enviar('/vehiculo/', datos.toJson());
    return Vehiculo.fromJson(respuesta as Map<String, dynamic>);
  }

  Future<Vehiculo> actualizarKilometraje(int nuevoKilometraje) async {
    final respuesta = await _clienteApi.actualizar('/vehiculo/kilometraje', {
      'kilometraje_actual': nuevoKilometraje,
    });
    return Vehiculo.fromJson(respuesta as Map<String, dynamic>);
  }
}
