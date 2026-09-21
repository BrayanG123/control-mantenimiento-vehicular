import '../../data/gastos_api.dart';
import '../../data/mantenimiento_api.dart';
import '../../data/vehiculo_api.dart';
import '../network/cliente_api.dart';

class DependenciasAplicacion {
  DependenciasAplicacion._();

  static final ClienteApi clienteApi = ClienteApi();
  static final VehiculoApi vehiculoApi = VehiculoApi(clienteApi);
  static final MantenimientoApi mantenimientoApi = MantenimientoApi(clienteApi);
  static final GastosApi gastosApi = GastosApi(clienteApi);
}
