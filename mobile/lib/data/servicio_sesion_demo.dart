import 'almacen_sesion.dart'
    if (dart.library.js_interop) 'almacen_sesion_web.dart';

String? _obtenerCorreoDesdeUri(Uri uri) {
  final correoDirecto = uri.queryParameters['correo'];
  if (correoDirecto != null && correoDirecto.trim().isNotEmpty) {
    return correoDirecto;
  }
  var fragmento = uri.fragment;
  if (fragmento.startsWith('/')) fragmento = fragmento.substring(1);
  if (fragmento.startsWith('?')) {
    final correo = Uri.splitQueryString(fragmento.substring(1))['correo'];
    if (correo != null && correo.trim().isNotEmpty) return correo;
  }
  return null;
}

void hidratarSesionDemoAlArranque() {
  var correo = _obtenerCorreoDesdeUri(Uri.base);
  if (correo == null || correo.isEmpty) {
    correo = correoDesdeHtml();
  }
  if (correo == null || correo.isEmpty) return;
  ServicioSesionDemo.correoActivo = ServicioSesionDemo.normalizar(correo);
}

class ServicioSesionDemo {
  ServicioSesionDemo._();

  static const demoCorreo = 'mariana@correo.com';
  static const demoClave = '123456';

  static String? correoActivo;
  static final Map<String, String> cuentas = {demoCorreo: demoClave};

  static bool get haySesion => correoActivo != null;

  static String normalizar(String raw) => raw.trim().toLowerCase();

  static bool correoConFormato(String raw) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalizar(raw));
  }

  static String? iniciar(String correo, String clave) {
    final correoNormalizado = normalizar(correo);
    final claveGuardada = cuentas[correoNormalizado];
    if (claveGuardada == null || claveGuardada != clave) {
      return 'Correo o contrasena no coinciden.';
    }
    correoActivo = correoNormalizado;
    return null;
  }

  static String? crear(String correo, String clave) {
    final correoNormalizado = normalizar(correo);
    if (cuentas.containsKey(correoNormalizado)) {
      return 'Ya hay una cuenta con ese correo.';
    }
    cuentas[correoNormalizado] = clave;
    correoActivo = correoNormalizado;
    return null;
  }

  static void cerrar() {
    correoActivo = null;
    limpiarSesionWeb();
  }
}
