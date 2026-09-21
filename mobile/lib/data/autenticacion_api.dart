import '../core/network/cliente_api.dart';
import '../models/usuario.dart';

class AutenticacionApi {
  AutenticacionApi(this._clienteApi);

  final ClienteApi _clienteApi;

  Future<SesionAutenticada> registrar({
    required String correo,
    required String contrasena,
  }) async {
    final respuesta = await _clienteApi.enviar('/autenticacion/registro', {
      'correo': correo,
      'contrasena': contrasena,
    }, incluirToken: false);
    return SesionAutenticada.fromJson(respuesta as Map<String, dynamic>);
  }

  Future<SesionAutenticada> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    final respuesta = await _clienteApi.enviar('/autenticacion/inicio-sesion', {
      'correo': correo,
      'contrasena': contrasena,
    }, incluirToken: false);
    return SesionAutenticada.fromJson(respuesta as Map<String, dynamic>);
  }
}
