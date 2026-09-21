import '../core/network/cliente_api.dart';
import '../models/resumen_gastos.dart';

class GastosApi {
  GastosApi(this._clienteApi);

  final ClienteApi _clienteApi;

  Future<ResumenGastos> obtenerResumen({String periodo = 'este_anio'}) async {
    final respuesta = await _clienteApi.obtener(
      '/mantenimiento/gastos?periodo=$periodo',
    );
    return ResumenGastos.fromJson(respuesta as Map<String, dynamic>);
  }
}
