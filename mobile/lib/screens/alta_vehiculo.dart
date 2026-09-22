import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/theme/tema_aplicacion.dart';
import '../models/vehiculo.dart';

class AltaVehiculoPantalla extends StatefulWidget {
  final VoidCallback onCreado;
  final VoidCallback? onCerrarSesion;

  const AltaVehiculoPantalla({
    super.key,
    required this.onCreado,
    this.onCerrarSesion,
  });

  @override
  State<AltaVehiculoPantalla> createState() => _AltaVehiculoPantallaState();
}

class _AltaVehiculoPantallaState extends State<AltaVehiculoPantalla> {
  final marcaCtrl = TextEditingController(text: 'Honda');
  final modeloCtrl = TextEditingController(text: 'CB 150');
  final anioCtrl = TextEditingController(text: '2021');
  final placaCtrl = TextEditingController(text: 'ABC-123');

  final marcaFocus = FocusNode();
  final modeloFocus = FocusNode();
  final anioFocus = FocusNode();
  final placaFocus = FocusNode();

  bool guardando = false;
  String? errorMarca;
  String? errorModelo;
  String? errorAnio;
  String? errorPlaca;
  String? errorRed;

  @override
  void initState() {
    super.initState();
    for (final f in [marcaFocus, modeloFocus, anioFocus, placaFocus]) {
      f.addListener(() => setState(() {}));
    }
    marcaCtrl.addListener(() {
      if (errorMarca != null) setState(() => errorMarca = null);
    });
    modeloCtrl.addListener(() {
      if (errorModelo != null) setState(() => errorModelo = null);
    });
    anioCtrl.addListener(() {
      if (errorAnio != null) setState(() => errorAnio = null);
    });
    placaCtrl.addListener(() {
      if (errorPlaca != null) setState(() => errorPlaca = null);
    });
  }

  @override
  void dispose() {
    marcaCtrl.dispose();
    modeloCtrl.dispose();
    anioCtrl.dispose();
    placaCtrl.dispose();
    marcaFocus.dispose();
    modeloFocus.dispose();
    anioFocus.dispose();
    placaFocus.dispose();
    super.dispose();
  }

  bool _validar() {
    final anioRaw = anioCtrl.text.trim();
    final anio = int.tryParse(anioRaw);
    final anioMax = DateTime.now().year + 1;
    var ok = true;

    setState(() {
      errorRed = null;
      errorMarca = marcaCtrl.text.trim().isEmpty
          ? 'Ingresa la marca del vehiculo.'
          : null;
      errorModelo = modeloCtrl.text.trim().isEmpty
          ? 'Ingresa el modelo del vehiculo.'
          : null;
      if (anioRaw.isEmpty) {
        errorAnio = 'Ingresa el anio. Ejemplo: 2021.';
      } else if (anio == null) {
        errorAnio = 'El anio debe ser un numero.';
      } else if (anio < 1980 || anio > anioMax) {
        errorAnio = 'Ingresa un anio entre 1980 y $anioMax.';
      } else {
        errorAnio = null;
      }
      errorPlaca = placaCtrl.text.trim().isEmpty
          ? 'Ingresa la placa para reconocer el vehiculo.'
          : null;
    });

    if (errorMarca != null) {
      marcaFocus.requestFocus();
      ok = false;
    } else if (errorModelo != null) {
      modeloFocus.requestFocus();
      ok = false;
    } else if (errorAnio != null) {
      anioFocus.requestFocus();
      ok = false;
    } else if (errorPlaca != null) {
      placaFocus.requestFocus();
      ok = false;
    }

    return ok;
  }

  Future<void> guardar() async {
    if (guardando) return;
    if (!_validar()) return;

    setState(() => guardando = true);

    try {
      await DependenciasAplicacion.vehiculoApi.registrarVehiculo(
        DatosNuevoVehiculo(
          marca: marcaCtrl.text.trim(),
          modelo: modeloCtrl.text.trim(),
          anio: int.parse(anioCtrl.text.trim()),
          placa: placaCtrl.text.trim(),
        ),
      );
      widget.onCreado();
    } catch (_) {
      if (mounted) {
        setState(() {
          errorRed = 'No se pudo guardar el vehiculo. Revisa la conexion e intenta de nuevo.';
        });
      }
    }

    if (mounted) {
      setState(() => guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: texto,
        elevation: 0,
        title: const Text(
          'Registrar vehiculo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),
        actions: [
          if (widget.onCerrarSesion != null)
            IconButton(
              tooltip: 'Cerrar sesion',
              onPressed: widget.onCerrarSesion,
              icon: const Icon(Icons.logout, color: teal),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const Text(
            'Datos del vehiculo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Completa los datos para calcular el proximo mantenimiento. Un vehiculo por cuenta.',
            style: TextStyle(fontSize: 13, color: muted),
          ),
          const SizedBox(height: 20),
          _campo(
            etiqueta: 'Marca',
            controller: marcaCtrl,
            focus: marcaFocus,
            error: errorMarca,
            ayuda: 'Ejemplo: Honda',
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => modeloFocus.requestFocus(),
          ),
          const SizedBox(height: 16),
          _campo(
            etiqueta: 'Modelo',
            controller: modeloCtrl,
            focus: modeloFocus,
            error: errorModelo,
            ayuda: 'Ejemplo: CB 150',
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => anioFocus.requestFocus(),
          ),
          const SizedBox(height: 16),
          _campo(
            etiqueta: 'Anio',
            controller: anioCtrl,
            focus: anioFocus,
            error: errorAnio,
            ayuda: 'Anio de fabricacion del vehiculo',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => placaFocus.requestFocus(),
          ),
          const SizedBox(height: 16),
          _campo(
            etiqueta: 'Placa',
            controller: placaCtrl,
            focus: placaFocus,
            error: errorPlaca,
            ayuda: 'Sirve para reconocer el vehiculo en el historial',
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (!guardando) guardar();
            },
          ),
          if (errorRed != null) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, size: 16, color: rojoEstado),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorRed!,
                    style: const TextStyle(fontSize: 13, color: rojoEstado),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: _botonGuardar(
              apagado: guardando,
              guardando: guardando,
              onTap: guardando ? null : guardar,
            ),
          ),
          if (widget.onCerrarSesion != null) ...[
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: 'Cerrar sesion',
              child: OutlinedButton.icon(
                onPressed: widget.onCerrarSesion,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Cerrar sesion'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: teal,
                  side: const BorderSide(color: borde),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _campo({
    required String etiqueta,
    required TextEditingController controller,
    required FocusNode focus,
    required String? error,
    required String ayuda,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    ValueChanged<String>? onSubmitted,
  }) {
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
      textoAyuda = error;
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
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    textInputAction: textInputAction,
                    textCapitalization: textCapitalization,
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

  Widget _botonGuardar({
    required bool apagado,
    required bool guardando,
    required VoidCallback? onTap,
  }) {
    Color fondo;
    Color colorTexto;
    String label;
    Widget? extra;

    if (guardando) {
      fondo = teal.withValues(alpha: 0.8);
      colorTexto = Colors.white;
      label = 'Guardando...';
      extra = const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    } else if (apagado) {
      fondo = const Color(0xFFDAE0DE);
      colorTexto = const Color(0xFF9EA6A4);
      label = 'Guardar vehiculo';
    } else {
      fondo = teal;
      colorTexto = Colors.white;
      label = 'Guardar vehiculo';
    }

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: Material(
        color: fondo,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 48,
            constraints: const BoxConstraints(minWidth: 230),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (extra != null) ...[extra, const SizedBox(width: 8)],
                Text(
                  label,
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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
