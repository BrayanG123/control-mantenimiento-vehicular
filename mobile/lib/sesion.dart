/// Sesion local del Flujo 5. No hay backend de usuarios: las cuentas
/// viven en memoria para poder defender happy path y validacion en codigo.
import 'sesion_html.dart' if (dart.library.js_interop) 'sesion_html_web.dart';

String? _correoEnUri(Uri u) {
  final directo = u.queryParameters['correo'];
  if (directo != null && directo.trim().isNotEmpty) return directo;
  var frag = u.fragment;
  if (frag.startsWith('/')) frag = frag.substring(1);
  if (frag.startsWith('?')) {
    final c = Uri.splitQueryString(frag.substring(1))['correo'];
    if (c != null && c.trim().isNotEmpty) return c;
  }
  return null;
}

void hidratarSesionAlArranque() {
  var c = _correoEnUri(Uri.base);
  if (c == null || c.isEmpty) {
    c = correoDesdeHtml();
  }
  if (c == null || c.isEmpty) return;
  Sesion.correoActivo = Sesion.normalizar(c);
}

class Sesion {
  Sesion._();

  /// Cuenta de la persona (Mariana). Sirve el happy path de la expo.
  static const demoCorreo = 'mariana@correo.com';
  static const demoClave = '123456';

  static String? correoActivo;
  static final Map<String, String> cuentas = {
    demoCorreo: demoClave,
  };

  static bool get haySesion => correoActivo != null;

  static String normalizar(String raw) => raw.trim().toLowerCase();

  static bool correoConFormato(String raw) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalizar(raw));
  }

  static String? iniciar(String correo, String clave) {
    final c = normalizar(correo);
    final guardada = cuentas[c];
    if (guardada == null || guardada != clave) {
      return 'Correo o contrasena no coinciden.';
    }
    correoActivo = c;
    return null;
  }

  static String? crear(String correo, String clave) {
    final c = normalizar(correo);
    if (cuentas.containsKey(c)) {
      return 'Ya hay una cuenta con ese correo.';
    }
    cuentas[c] = clave;
    correoActivo = c;
    return null;
  }

  static void cerrar() {
    correoActivo = null;
    limpiarSesionWeb();
  }
}
