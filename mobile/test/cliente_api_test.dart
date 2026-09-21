import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile/core/network/cliente_api.dart';
import 'package:mobile/data/autenticacion_api.dart';

void main() {
  test('adjunta el token Bearer en solicitudes protegidas', () async {
    final cliente = ClienteApi(
      urlBase: 'http://api.local',
      obtenerToken: () => 'token-de-prueba',
      clienteHttp: MockClient((solicitud) async {
        expect(solicitud.headers['authorization'], 'Bearer token-de-prueba');
        return http.Response('{}', 200);
      }),
    );

    await cliente.obtener('/vehiculo/');
  });

  test('no adjunta el token durante el inicio de sesion', () async {
    final cliente = ClienteApi(
      urlBase: 'http://api.local',
      obtenerToken: () => 'token-anterior',
      clienteHttp: MockClient((solicitud) async {
        expect(solicitud.headers.containsKey('authorization'), isFalse);
        expect(solicitud.body, contains('contrasena'));
        return http.Response(
          '{"access_token":"token-nuevo","usuario":{"id":1,"correo":"mariana@correo.com"}}',
          200,
        );
      }),
    );

    final sesion = await AutenticacionApi(cliente)
        .iniciarSesion(correo: 'mariana@correo.com', contrasena: '123456');

    expect(sesion.token, 'token-nuevo');
    expect(sesion.usuario.correo, 'mariana@correo.com');
  });

  test('recuperacion solicita correo y envia la contrasena nueva', () async {
    final rutas = <String>[];
    final cuerpos = <String>[];
    final cliente = ClienteApi(
      urlBase: 'http://api.local',
      clienteHttp: MockClient((solicitud) async {
        rutas.add(solicitud.url.path);
        cuerpos.add(solicitud.body);
        return http.Response('{"mensaje":"ok"}', 200);
      }),
    );
    final autenticacion = AutenticacionApi(cliente);

    await autenticacion.solicitarRecuperacion('mariana@correo.com');
    await autenticacion.restablecerContrasena(
      token: 'token-de-recuperacion-valido',
      nuevaContrasena: 'nueva-clave',
    );

    expect(rutas, [
      '/autenticacion/recuperacion',
      '/autenticacion/restablecimiento',
    ]);
    expect(cuerpos.first, contains('mariana@correo.com'));
    expect(cuerpos.last, contains('nueva_contrasena'));
  });
}
