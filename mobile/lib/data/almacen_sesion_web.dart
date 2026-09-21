import 'package:web/web.dart' as web;

String? tokenDesdeAlmacen() {
  try {
    final guardado = web.window.localStorage.getItem('cmv_token');
    if (guardado != null && guardado.trim().isNotEmpty) {
      return guardado.trim();
    }
  } catch (_) {}
  return null;
}

void guardarTokenEnAlmacen(String token) {
  try {
    web.window.localStorage.setItem('cmv_token', token);
  } catch (_) {}
}

void limpiarAlmacenSesion() {
  try {
    web.window.localStorage.removeItem('cmv_token');
  } catch (_) {}
}
