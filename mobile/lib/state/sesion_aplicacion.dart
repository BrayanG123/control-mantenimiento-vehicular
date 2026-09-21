import '../data/almacen_sesion.dart'
    if (dart.library.js_interop) '../data/almacen_sesion_web.dart';
import '../models/usuario.dart';

class SesionAplicacion {
  SesionAplicacion._();

  static String? _token;
  static Usuario? _usuario;

  static String? get token => _token;
  static Usuario? get usuario => _usuario;
  static bool get haySesion => _token != null;

  static void hidratarAlArranque() {
    _token = tokenDesdeAlmacen();
  }

  static void iniciar(SesionAutenticada sesion) {
    _token = sesion.token;
    _usuario = sesion.usuario;
    guardarTokenEnAlmacen(sesion.token);
  }

  static void cerrar() {
    _token = null;
    _usuario = null;
    limpiarAlmacenSesion();
  }
}
