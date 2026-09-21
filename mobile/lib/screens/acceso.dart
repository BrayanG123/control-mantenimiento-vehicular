import 'package:flutter/material.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/layout/marco_movil.dart';
import '../core/network/error_api.dart';
import '../core/theme/tema_aplicacion.dart';
import '../core/utils/validacion_correo.dart';
import '../state/sesion_aplicacion.dart';

class BienvenidaPantalla extends StatelessWidget {
  const BienvenidaPantalla({super.key, required this.onSesion});

  final VoidCallback onSesion;

  @override
  Widget build(BuildContext context) {
    return HojaAcceso(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: fondoSuave,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.two_wheeler, color: teal, size: 44),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Mantenimiento',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kilometraje, proximo servicio y gastos de tu vehiculo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: muted),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: BotonAcceso(
                    label: 'Iniciar sesion',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              IniciarSesionPantalla(onSesion: onSesion),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CrearCuentaPantalla(onSesion: onSesion),
                        ),
                      );
                    },
                    child: const Text('Crear cuenta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IniciarSesionPantalla extends StatefulWidget {
  const IniciarSesionPantalla({super.key, required this.onSesion});

  final VoidCallback onSesion;

  @override
  State<IniciarSesionPantalla> createState() => _IniciarSesionPantallaState();
}

class _IniciarSesionPantallaState extends State<IniciarSesionPantalla> {
  final correoCtrl = TextEditingController();
  final claveCtrl = TextEditingController();
  final correoFocus = FocusNode();
  final claveFocus = FocusNode();
  String? errorCorreo;
  String? errorClave;
  bool enviando = false;

  @override
  void initState() {
    super.initState();
    correoFocus.addListener(() => setState(() {}));
    claveFocus.addListener(() => setState(() {}));
    correoCtrl.addListener(() {
      if (errorCorreo != null) setState(() => errorCorreo = null);
    });
    claveCtrl.addListener(() {
      if (errorClave != null) setState(() => errorClave = null);
    });
  }

  @override
  void dispose() {
    correoCtrl.dispose();
    claveCtrl.dispose();
    correoFocus.dispose();
    claveFocus.dispose();
    super.dispose();
  }

  Future<void> enviar() async {
    if (enviando) return;
    final correo = correoCtrl.text;
    final clave = claveCtrl.text;
    String? errCorreo;
    String? errClave;

    if (correo.trim().isEmpty) {
      errCorreo = 'Ingresa un correo. Ejemplo: mariana@correo.com';
    } else if (!correoTieneFormatoValido(correo)) {
      errCorreo =
          'El correo no tiene formato valido. Ejemplo: mariana@correo.com';
    }
    if (clave.isEmpty) {
      errClave = 'Ingresa la contrasena.';
    } else if (clave.length < 6) {
      errClave = 'La contrasena debe tener al menos 6 caracteres.';
    }

    if (errCorreo != null || errClave != null) {
      setState(() {
        errorCorreo = errCorreo;
        errorClave = errClave;
      });
      return;
    }

    setState(() => enviando = true);
    try {
      final sesion = await DependenciasAplicacion.autenticacionApi
          .iniciarSesion(correo: normalizarCorreo(correo), contrasena: clave);
      SesionAplicacion.iniciar(sesion);
      if (!mounted) return;
      widget.onSesion();
    } on ErrorApi catch (error) {
      if (!mounted) return;
      setState(() {
        errorClave = error.codigoEstado == 401
            ? 'Correo o contrasena no coinciden.'
            : error.mensaje;
      });
      claveFocus.requestFocus();
    } catch (_) {
      if (!mounted) return;
      setState(() => errorClave = 'No se pudo conectar con el backend.');
    } finally {
      if (mounted) setState(() => enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HojaAcceso(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: texto,
          elevation: 0,
          title: const Text(
            'Iniciar sesion',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const Text(
              'Entra para ver el proximo mantenimiento.',
              style: TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 20),
            CampoAcceso(
              etiqueta: 'Correo',
              controller: correoCtrl,
              focus: correoFocus,
              error: errorCorreo,
              ayuda: 'Ejemplo: mariana@correo.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => claveFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            CampoAcceso(
              etiqueta: 'Contrasena',
              controller: claveCtrl,
              focus: claveFocus,
              error: errorClave,
              ayuda: 'La que usaste al crear la cuenta',
              obscure: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => enviar(),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OlvideClavePantalla(),
                    ),
                  );
                },
                child: const Text('Olvide la contrasena'),
              ),
            ),
            const SizedBox(height: 8),
            BotonAcceso(
              label: enviando ? 'Iniciando sesion...' : 'Iniciar sesion',
              onTap: enviando ? null : enviar,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CrearCuentaPantalla(onSesion: widget.onSesion),
                  ),
                );
              },
              child: const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}

class CrearCuentaPantalla extends StatefulWidget {
  const CrearCuentaPantalla({super.key, required this.onSesion});

  final VoidCallback onSesion;

  @override
  State<CrearCuentaPantalla> createState() => _CrearCuentaPantallaState();
}

class _CrearCuentaPantallaState extends State<CrearCuentaPantalla> {
  final correoCtrl = TextEditingController();
  final claveCtrl = TextEditingController();
  final repetirCtrl = TextEditingController();
  final correoFocus = FocusNode();
  final claveFocus = FocusNode();
  final repetirFocus = FocusNode();
  String? errorCorreo;
  String? errorClave;
  String? errorRepetir;
  bool enviando = false;

  @override
  void initState() {
    super.initState();
    for (final f in [correoFocus, claveFocus, repetirFocus]) {
      f.addListener(() => setState(() {}));
    }
    correoCtrl.addListener(() {
      if (errorCorreo != null) setState(() => errorCorreo = null);
    });
    claveCtrl.addListener(() {
      if (errorClave != null) setState(() => errorClave = null);
    });
    repetirCtrl.addListener(() {
      if (errorRepetir != null) setState(() => errorRepetir = null);
    });
  }

  @override
  void dispose() {
    correoCtrl.dispose();
    claveCtrl.dispose();
    repetirCtrl.dispose();
    correoFocus.dispose();
    claveFocus.dispose();
    repetirFocus.dispose();
    super.dispose();
  }

  Future<void> enviar() async {
    if (enviando) return;
    final correo = correoCtrl.text;
    final clave = claveCtrl.text;
    final repetir = repetirCtrl.text;
    String? errCorreo;
    String? errClave;
    String? errRepetir;

    if (correo.trim().isEmpty) {
      errCorreo = 'Ingresa un correo. Ejemplo: mariana@correo.com';
    } else if (!correoTieneFormatoValido(correo)) {
      errCorreo =
          'El correo no tiene formato valido. Ejemplo: mariana@correo.com';
    }
    if (clave.isEmpty) {
      errClave = 'Ingresa la contrasena.';
    } else if (clave.length < 6) {
      errClave = 'La contrasena debe tener al menos 6 caracteres.';
    }
    if (repetir.isEmpty) {
      errRepetir = 'Repite la contrasena.';
    } else if (clave.isNotEmpty && clave != repetir) {
      errRepetir = 'Las contrasenas no coinciden.';
    }

    if (errCorreo != null || errClave != null || errRepetir != null) {
      setState(() {
        errorCorreo = errCorreo;
        errorClave = errClave;
        errorRepetir = errRepetir;
      });
      if (errCorreo != null) {
        correoFocus.requestFocus();
      } else if (errClave != null) {
        claveFocus.requestFocus();
      } else {
        repetirFocus.requestFocus();
      }
      return;
    }

    setState(() => enviando = true);
    try {
      final sesion = await DependenciasAplicacion.autenticacionApi.registrar(
        correo: normalizarCorreo(correo),
        contrasena: clave,
      );
      SesionAplicacion.iniciar(sesion);
      if (!mounted) return;
      widget.onSesion();
    } on ErrorApi catch (error) {
      if (!mounted) return;
      setState(() => errorCorreo = error.mensaje);
      correoFocus.requestFocus();
    } catch (_) {
      if (!mounted) return;
      setState(() => errorCorreo = 'No se pudo conectar con el backend.');
    } finally {
      if (mounted) setState(() => enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HojaAcceso(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: texto,
          elevation: 0,
          title: const Text(
            'Crear cuenta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const Text(
              'Con una cuenta queda el historial de tu vehiculo.',
              style: TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 20),
            CampoAcceso(
              etiqueta: 'Correo',
              controller: correoCtrl,
              focus: correoFocus,
              error: errorCorreo,
              ayuda: 'Ejemplo: mariana@correo.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => claveFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            CampoAcceso(
              etiqueta: 'Contrasena',
              controller: claveCtrl,
              focus: claveFocus,
              error: errorClave,
              ayuda: 'Minimo para entrar de nuevo',
              obscure: true,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => repetirFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            CampoAcceso(
              etiqueta: 'Repetir contrasena',
              controller: repetirCtrl,
              focus: repetirFocus,
              error: errorRepetir,
              ayuda: 'Tiene que ser la misma',
              obscure: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => enviar(),
            ),
            const SizedBox(height: 24),
            BotonAcceso(
              label: enviando ? 'Creando cuenta...' : 'Crear cuenta',
              onTap: enviando ? null : enviar,
            ),
          ],
        ),
      ),
    );
  }
}

class OlvideClavePantalla extends StatefulWidget {
  const OlvideClavePantalla({super.key});

  @override
  State<OlvideClavePantalla> createState() => _OlvideClavePantallaState();
}

class _OlvideClavePantallaState extends State<OlvideClavePantalla> {
  final correoCtrl = TextEditingController();
  final correoFocus = FocusNode();
  String? errorCorreo;
  bool enviando = false;

  @override
  void initState() {
    super.initState();
    correoFocus.addListener(() => setState(() {}));
    correoCtrl.addListener(() {
      if (errorCorreo != null) setState(() => errorCorreo = null);
    });
  }

  @override
  void dispose() {
    correoCtrl.dispose();
    correoFocus.dispose();
    super.dispose();
  }

  Future<void> enviar() async {
    if (enviando) return;
    final correo = correoCtrl.text;
    if (correo.trim().isEmpty) {
      setState(() {
        errorCorreo = 'Ingresa el correo para enviarte el enlace.';
      });
      correoFocus.requestFocus();
      return;
    }
    if (!correoTieneFormatoValido(correo)) {
      setState(() {
        errorCorreo =
            'El correo no tiene formato valido. Ejemplo: mariana@correo.com';
      });
      correoFocus.requestFocus();
      return;
    }
    setState(() => enviando = true);
    try {
      final correoNormalizado = normalizarCorreo(correo);
      await DependenciasAplicacion.autenticacionApi.solicitarRecuperacion(
        correoNormalizado,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EnlaceEnviadoPantalla(correo: correoNormalizado),
        ),
      );
    } on ErrorApi catch (error) {
      if (!mounted) return;
      setState(() => errorCorreo = error.mensaje);
    } catch (_) {
      if (!mounted) return;
      setState(() => errorCorreo = 'No se pudo conectar con el backend.');
    } finally {
      if (mounted) setState(() => enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HojaAcceso(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: texto,
          elevation: 0,
          title: const Text(
            'Olvide la contrasena',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const Text(
              'Te mandamos un enlace para elegir una contrasena nueva.',
              style: TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 20),
            CampoAcceso(
              etiqueta: 'Correo',
              controller: correoCtrl,
              focus: correoFocus,
              error: errorCorreo,
              ayuda: 'El mismo con el que creaste la cuenta',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => enviar(),
            ),
            const SizedBox(height: 24),
            BotonAcceso(
              label: enviando ? 'Enviando...' : 'Enviar enlace',
              onTap: enviando ? null : enviar,
            ),
          ],
        ),
      ),
    );
  }
}

class EnlaceEnviadoPantalla extends StatelessWidget {
  const EnlaceEnviadoPantalla({super.key, required this.correo});

  final String correo;

  @override
  Widget build(BuildContext context) {
    return HojaAcceso(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: texto,
          elevation: 0,
          title: const Text(
            'Revisa tu correo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.mark_email_read_outlined, color: teal, size: 48),
              const SizedBox(height: 16),
              Text(
                'Si hay una cuenta en $correo, vas a recibir el enlace para cambiar la contrasena.',
                style: const TextStyle(fontSize: 16, color: texto, height: 1.4),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: muted),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Si no llega, revisa spam. El enlace vence.',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              BotonAcceso(
                label: 'Volver a iniciar sesion',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RestablecerContrasenaPantalla extends StatefulWidget {
  const RestablecerContrasenaPantalla({
    super.key,
    required this.token,
    required this.onFinalizado,
  });

  final String token;
  final VoidCallback onFinalizado;

  @override
  State<RestablecerContrasenaPantalla> createState() =>
      _RestablecerContrasenaPantallaState();
}

class _RestablecerContrasenaPantallaState
    extends State<RestablecerContrasenaPantalla> {
  final contrasenaCtrl = TextEditingController();
  final repetirCtrl = TextEditingController();
  final contrasenaFocus = FocusNode();
  final repetirFocus = FocusNode();
  String? errorContrasena;
  String? errorRepetir;
  bool enviando = false;
  bool actualizada = false;

  @override
  void initState() {
    super.initState();
    contrasenaFocus.addListener(() => setState(() {}));
    repetirFocus.addListener(() => setState(() {}));
    contrasenaCtrl.addListener(() {
      if (errorContrasena != null) setState(() => errorContrasena = null);
    });
    repetirCtrl.addListener(() {
      if (errorRepetir != null) setState(() => errorRepetir = null);
    });
  }

  @override
  void dispose() {
    contrasenaCtrl.dispose();
    repetirCtrl.dispose();
    contrasenaFocus.dispose();
    repetirFocus.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    if (enviando) return;
    final contrasena = contrasenaCtrl.text;
    final repetir = repetirCtrl.text;
    String? errorNueva;
    String? errorConfirmacion;

    if (contrasena.length < 6) {
      errorNueva = 'La contrasena debe tener al menos 6 caracteres.';
    }
    if (repetir.isEmpty) {
      errorConfirmacion = 'Repite la contrasena.';
    } else if (contrasena != repetir) {
      errorConfirmacion = 'Las contrasenas no coinciden.';
    }
    if (errorNueva != null || errorConfirmacion != null) {
      setState(() {
        errorContrasena = errorNueva;
        errorRepetir = errorConfirmacion;
      });
      return;
    }

    setState(() => enviando = true);
    try {
      await DependenciasAplicacion.autenticacionApi.restablecerContrasena(
        token: widget.token,
        nuevaContrasena: contrasena,
      );
      if (!mounted) return;
      setState(() => actualizada = true);
    } on ErrorApi catch (error) {
      if (!mounted) return;
      setState(() => errorContrasena = error.mensaje);
    } catch (_) {
      if (!mounted) return;
      setState(() => errorContrasena = 'No se pudo conectar con el backend.');
    } finally {
      if (mounted) setState(() => enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (actualizada) {
      return HojaAcceso(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, color: teal, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Contrasena actualizada',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: texto,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ya puedes iniciar sesion con tu nueva contrasena.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted),
                  ),
                  const SizedBox(height: 24),
                  BotonAcceso(
                    label: 'Ir a iniciar sesion',
                    onTap: widget.onFinalizado,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return HojaAcceso(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: texto,
          title: const Text('Elegir contrasena nueva'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const Text(
              'Ingresa la contrasena que usaras desde ahora.',
              style: TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 20),
            CampoAcceso(
              etiqueta: 'Contrasena nueva',
              controller: contrasenaCtrl,
              focus: contrasenaFocus,
              error: errorContrasena,
              ayuda: 'Minimo 6 caracteres',
              obscure: true,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => repetirFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            CampoAcceso(
              etiqueta: 'Repetir contrasena',
              controller: repetirCtrl,
              focus: repetirFocus,
              error: errorRepetir,
              ayuda: 'Tiene que ser la misma',
              obscure: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => guardar(),
            ),
            const SizedBox(height: 24),
            BotonAcceso(
              label: enviando ? 'Guardando...' : 'Guardar contrasena',
              onTap: enviando ? null : guardar,
            ),
          ],
        ),
      ),
    );
  }
}

class CampoAcceso extends StatelessWidget {
  const CampoAcceso({
    super.key,
    required this.etiqueta,
    required this.controller,
    required this.focus,
    required this.error,
    required this.ayuda,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final String etiqueta;
  final TextEditingController controller;
  final FocusNode focus;
  final String? error;
  final String ayuda;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final hayFoco = focus.hasFocus;
    final hayError = error != null;

    Color colorBorde;
    Color colorLabel;
    Color fondoInput;
    Color colorAyuda;
    IconData iconoAyuda;
    Widget? iconoCampo;
    String textoAyuda;

    if (hayError) {
      colorBorde = rojoEstado;
      colorLabel = rojoEstado;
      fondoInput = const Color(0xFFFEF6F6);
      colorAyuda = rojoEstado;
      iconoAyuda = Icons.error_outline;
      iconoCampo = const Icon(Icons.error_outline, color: rojoEstado, size: 20);
      textoAyuda = error!;
    } else if (hayFoco) {
      colorBorde = teal;
      colorLabel = teal;
      fondoInput = const Color(0xFFFAFEFD);
      colorAyuda = muted;
      iconoAyuda = Icons.info_outline;
      textoAyuda = ayuda;
    } else {
      colorBorde = borde;
      colorLabel = muted;
      fondoInput = Colors.white;
      colorAyuda = muted;
      iconoAyuda = Icons.info_outline;
      textoAyuda = ayuda;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 13,
            fontWeight: hayFoco || hayError ? FontWeight.w600 : FontWeight.w500,
            color: colorLabel,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fondoInput,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorBorde,
              width: hayFoco || hayError ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  textField: true,
                  label: etiqueta,
                  hint: hayError ? error : ayuda,
                  child: TextField(
                    controller: controller,
                    focusNode: focus,
                    obscureText: obscure,
                    keyboardType: keyboardType,
                    textInputAction: textInputAction,
                    onSubmitted: onSubmitted,
                    style: const TextStyle(fontSize: 17, color: texto),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: ayuda,
                      hintStyle: const TextStyle(
                        color: Color(0xFFB0B8B5),
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              ?iconoCampo,
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(iconoAyuda, size: 14, color: colorAyuda),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                textoAyuda,
                style: TextStyle(fontSize: 12, color: colorAyuda),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BotonAcceso extends StatelessWidget {
  const BotonAcceso({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
