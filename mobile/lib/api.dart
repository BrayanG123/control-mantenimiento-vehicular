import 'dart:convert';

import 'package:http/http.dart' as http;

import 'modelos.dart';

const String baseUrl = 'http://127.0.0.1:8000';

Future<http.Response> _get(String path) {
  return http
      .get(Uri.parse('$baseUrl$path'))
      .timeout(const Duration(seconds: 8));
}

Future<http.Response> _post(String path, Map body) {
  return http
      .post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
      .timeout(const Duration(seconds: 8));
}

Future<http.Response> _patch(String path, Map body) {
  return http
      .patch(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
      .timeout(const Duration(seconds: 8));
}

Future<Vehiculo?> obtenerVehiculo() async {
  final resp = await _get('/vehiculo/');
  if (resp.statusCode == 404) {
    return null;
  }
  if (resp.statusCode != 200) {
    throw Exception('error al obtener vehiculo');
  }
  return Vehiculo.fromJson(jsonDecode(resp.body));
}

Future<Vehiculo> crearVehiculo(
  String marca,
  String modelo,
  int anio,
  String placa,
) async {
  final resp = await _post('/vehiculo/', {
    'marca': marca,
    'modelo': modelo,
    'anio': anio,
    'placa': placa,
  });

  if (resp.statusCode != 201) {
    print(resp.body);
    throw Exception('no se pudo crear el vehiculo');
  }

  return Vehiculo.fromJson(jsonDecode(resp.body));
}

Future<Vehiculo> actualizarKm(int km) async {
  final resp = await _patch('/vehiculo/kilometraje', {
    'kilometraje_actual': km,
  });

  if (resp.statusCode != 200) {
    print(resp.body);
    throw Exception('error al actualizar km');
  }

  return Vehiculo.fromJson(jsonDecode(resp.body));
}

Future<List<ProximoItem>> obtenerProximos() async {
  final resp = await _get('/mantenimiento/proximo');
  if (resp.statusCode != 200) {
    throw Exception('error al cargar proximos');
  }

  final lista = jsonDecode(resp.body) as List;
  return lista.map((e) => ProximoItem.fromJson(e)).toList();
}

Future<List<Mantenimiento>> obtenerHistorial() async {
  final resp = await _get('/mantenimiento/historial');
  if (resp.statusCode != 200) {
    throw Exception('error al cargar historial');
  }

  final lista = jsonDecode(resp.body) as List;
  return lista.map((e) => Mantenimiento.fromJson(e)).toList();
}

String _fechaIso(DateTime fecha) {
  final y = fecha.year.toString().padLeft(4, '0');
  final m = fecha.month.toString().padLeft(2, '0');
  final d = fecha.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

Future<Mantenimiento> crearMantenimiento({
  required String tipo,
  required DateTime fecha,
  required int kilometraje,
}) async {
  final resp = await _post('/mantenimiento/', {
    'tipo': tipo,
    'fecha': _fechaIso(fecha),
    'kilometraje': kilometraje,
  });

  if (resp.statusCode != 201) {
    print(resp.body);
    throw Exception('no se pudo registrar el mantenimiento');
  }

  return Mantenimiento.fromJson(jsonDecode(resp.body));
}
