import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/configuracion_api.dart';
import 'error_api.dart';

class ClienteApi {
  ClienteApi({
    http.Client? clienteHttp,
    this.urlBase = ConfiguracionApi.urlBase,
  }) : _clienteHttp = clienteHttp ?? http.Client();

  final http.Client _clienteHttp;
  final String urlBase;

  Future<dynamic> obtener(String ruta) async {
    final respuesta = await _clienteHttp
        .get(Uri.parse('$urlBase$ruta'))
        .timeout(const Duration(seconds: 8));
    return _procesarRespuesta(respuesta);
  }

  Future<dynamic> enviar(String ruta, Map<String, dynamic> cuerpo) async {
    final respuesta = await _clienteHttp
        .post(
          Uri.parse('$urlBase$ruta'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(cuerpo),
        )
        .timeout(const Duration(seconds: 8));
    return _procesarRespuesta(respuesta);
  }

  Future<dynamic> actualizar(String ruta, Map<String, dynamic> cuerpo) async {
    final respuesta = await _clienteHttp
        .patch(
          Uri.parse('$urlBase$ruta'),
          headers: const {'Content-Type': 'application/json'},
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
      if (cuerpo is Map<String, dynamic> && cuerpo['detail'] is String) {
        mensaje = cuerpo['detail'] as String;
      }
    } catch (_) {}

    throw ErrorApi(mensaje, codigoEstado: respuesta.statusCode);
  }
}
