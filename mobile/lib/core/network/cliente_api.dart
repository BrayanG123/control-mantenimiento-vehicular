import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/configuracion_api.dart';
import 'error_api.dart';

class ClienteApi {
  ClienteApi({
    http.Client? clienteHttp,
    this.urlBase = ConfiguracionApi.urlBase,
    String? Function()? obtenerToken,
  }) : _clienteHttp = clienteHttp ?? http.Client(),
       _obtenerToken = obtenerToken ?? _sinToken;

  final http.Client _clienteHttp;
  final String urlBase;
  final String? Function() _obtenerToken;

  Future<dynamic> obtener(String ruta, {bool incluirToken = true}) async {
    final respuesta = await _clienteHttp
        .get(
          Uri.parse('$urlBase$ruta'),
          headers: _encabezados(incluirToken: incluirToken),
        )
        .timeout(const Duration(seconds: 8));
    return _procesarRespuesta(respuesta);
  }

  Future<dynamic> enviar(
    String ruta,
    Map<String, dynamic> cuerpo, {
    bool incluirToken = true,
  }) async {
    final respuesta = await _clienteHttp
        .post(
          Uri.parse('$urlBase$ruta'),
          headers: _encabezados(
            incluirToken: incluirToken,
            incluirContenidoJson: true,
          ),
          body: jsonEncode(cuerpo),
        )
        .timeout(const Duration(seconds: 8));
    return _procesarRespuesta(respuesta);
  }

  Future<dynamic> actualizar(
    String ruta,
    Map<String, dynamic> cuerpo, {
    bool incluirToken = true,
  }) async {
    final respuesta = await _clienteHttp
        .patch(
          Uri.parse('$urlBase$ruta'),
          headers: _encabezados(
            incluirToken: incluirToken,
            incluirContenidoJson: true,
          ),
          body: jsonEncode(cuerpo),
        )
        .timeout(const Duration(seconds: 8));
    return _procesarRespuesta(respuesta);
  }

  dynamic _procesarRespuesta(http.Response respuesta) {
    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      return jsonDecode(respuesta.body);
    }

    String mensaje = 'No se pudo completar la solicitud';
    try {
      final cuerpo = jsonDecode(respuesta.body);
      if (cuerpo is Map<String, dynamic>) {
        final detail = cuerpo['detail'];
        if (detail is String) {
          mensaje = detail;
        } else if (detail is List && detail.isNotEmpty) {
          final primero = detail.first;
          if (primero is Map && primero['msg'] is String) {
            final msg = primero['msg'] as String;
            mensaje = msg.contains('at least 20')
                ? 'El enlace no es valido o ya vencio'
                : msg;
          }
        }
      }
    } catch (_) {}

    throw ErrorApi(mensaje, codigoEstado: respuesta.statusCode);
  }

  Map<String, String> _encabezados({
    required bool incluirToken,
    bool incluirContenidoJson = false,
  }) {
    final token = _obtenerToken();
    return {
      if (incluirContenidoJson) 'Content-Type': 'application/json',
      if (incluirToken && token != null) 'Authorization': 'Bearer $token',
    };
  }

  static String? _sinToken() => null;
}
