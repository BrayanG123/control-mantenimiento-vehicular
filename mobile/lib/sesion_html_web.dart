import 'package:web/web.dart' as web;

String? correoDesdeHtml() {
  try {
    final guardado = web.window.sessionStorage.getItem('cmv_correo');
    if (guardado != null && guardado.trim().isNotEmpty) {
      return guardado.trim();
    }
  } catch (_) {}
  try {
    final attr =
        web.document.documentElement?.getAttribute('data-cmv-correo');
    if (attr != null && attr.trim().isNotEmpty) {
      return attr.trim();
    }
  } catch (_) {}
  return null;
}

void limpiarSesionWeb() {
  try {
    web.window.sessionStorage.removeItem('cmv_correo');
  } catch (_) {}
  try {
    web.document.documentElement?.removeAttribute('data-cmv-correo');
  } catch (_) {}
}
