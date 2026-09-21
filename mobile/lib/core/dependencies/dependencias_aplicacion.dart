import '../../data/autenticacion_api.dart';
import '../../data/gastos_api.dart';
import '../../data/mantenimiento_api.dart';
import '../../data/vehiculo_api.dart';
import '../network/cliente_api.dart';
import '../../state/sesion_aplicacion.dart';

class DependenciasAplicacion {
  DependenciasAplicacion._();

  static final ClienteApi clienteApi = ClienteApi(
    obtenerToken: () => SesionAplicacion.token,
  );
  static final AutenticacionApi autenticacionApi = AutenticacionApi(clienteApi);
  static final VehiculoApi vehiculoApi = VehiculoApi(clienteApi);
  static final MantenimientoApi mantenimientoApi = MantenimientoApi(clienteApi);
  static final GastosApi gastosApi = GastosApi(clienteApi);
}
