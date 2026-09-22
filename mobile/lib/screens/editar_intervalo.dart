import 'package:flutter/material.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/network/error_api.dart';
import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';

class EditarIntervaloPantalla extends StatefulWidget {
  const EditarIntervaloPantalla({
    super.key,
    required this.tipo,
    required this.intervaloActual,
    required this.intervaloFabrica,
  });

  final String tipo;
  final int intervaloActual;
  final int intervaloFabrica;

  @override
  State<EditarIntervaloPantalla> createState() =>
      _EditarIntervaloPantallaState();
}

class _EditarIntervaloPantallaState extends State<EditarIntervaloPantalla> {
  late final TextEditingController ctrl;
  final foco = FocusNode();

  bool guardando = false;
  bool guardadoOk = false;
  String? errorCampo;
  int? kmGuardado;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(
      text: formatearMiles(widget.intervaloActual),
    );
    foco.addListener(() => setState(() {}));
    ctrl.addListener(() {
      if (errorCampo != null || guardadoOk) {
        setState(() {
          errorCampo = null;
          guardadoOk = false;
        });
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    foco.dispose();
    super.dispose();
  }

  // null = error de formato. El mensaje va aparte.
  int? _numeroEscrito() {
    final limpio = ctrl.text.replaceAll('.', '').replaceAll(',', '').replaceAll(' ', '');
    if (limpio.isEmpty) return null;
    return int.tryParse(limpio);
  }

  String? _validar() {
    final escrito = ctrl.text.trim();
    if (escrito.isEmpty) {
      return 'Ingresa un intervalo en km. Ejemplo: 3.000';
    }

    final tieneLetras = RegExp(r'[a-zA-Z]').hasMatch(escrito);
    final numero = _numeroEscrito();
    if (tieneLetras || numero == null) {
      return 'Solo numeros. Sin letras ni simbolos.';
    }

    if (numero < 500) {
      return 'Muy corto: el minimo es 500 km.';
    }

    if (numero == widget.intervaloFabrica) {
      return 'Es el mismo de fabrica. Para uso intensivo bajalo (ej. 3.000).';
    }

    return null;
  }

  Future<void> guardar() async {
    final error = _validar();
    if (error != null) {
      setState(() {
        errorCampo = error;
        guardadoOk = false;
      });
      return;
    }

    final numero = _numeroEscrito()!;
    setState(() {
      guardando = true;
      errorCampo = null;
    });

    try {
      await DependenciasAplicacion.mantenimientoApi.actualizarIntervalo(
        widget.tipo,
        numero,
      );
      if (!mounted) return;
      // Vuelve al detalle; el detalle cierra y deja en Plan con lista fresca.
      Navigator.pop(context, numero);
    } on ErrorApi catch (errorApi) {
      if (!mounted) return;
      setState(() {
        guardando = false;
        errorCampo = errorApi.mensaje;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        guardando = false;
        errorCampo = 'No se pudo guardar el intervalo';
      });
    }
  }

  void _volver() {
    Navigator.pop(context, guardadoOk ? kmGuardado : null);
  }

  @override
  Widget build(BuildContext context) {
    final hayFoco = foco.hasFocus;
    final hayError = errorCampo != null;

    Color colorBorde;
    Color colorLabel;
    Color fondoInput;
    String ayuda;
    Color colorAyuda;
    IconData iconoAyuda;
    Widget? iconoCampo;

    if (hayError) {
      colorBorde = rojoEstado;
      colorLabel = rojoEstado;
      fondoInput = const Color(0xFFFEF6F6);
      ayuda = errorCampo!;
      colorAyuda = rojoEstado;
      iconoAyuda = Icons.error_outline;
      iconoCampo = const Icon(Icons.error_outline, color: rojoEstado, size: 20);
    } else if (guardadoOk) {
      colorBorde = teal;
      colorLabel = teal;
      fondoInput = const Color(0xFFF4FBF9);
      ayuda = 'Intervalo actualizado. El pendiente se recalcula en Inicio.';
      colorAyuda = teal;
      iconoAyuda = Icons.check_circle_outline;
      iconoCampo = const Icon(
        Icons.check_circle_outline,
        color: teal,
        size: 20,
      );
    } else if (hayFoco) {
      colorBorde = teal;
      colorLabel = teal;
      fondoInput = const Color(0xFFFAFEFD);
      ayuda =
          'Antes: ${formatearMiles(widget.intervaloFabrica)} km (fabrica)';
      colorAyuda = muted;
      iconoAyuda = Icons.info_outline;
    } else {
      colorBorde = borde;
      colorLabel = muted;
      fondoInput = Colors.white;
      ayuda =
          'Antes: ${formatearMiles(widget.intervaloFabrica)} km (fabrica)';
      colorAyuda = muted;
      iconoAyuda = Icons.info_outline;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _volver();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: texto,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Volver',
            onPressed: _volver,
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            'Editar intervalo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              '${obtenerTituloMantenimiento(widget.tipo)} · ajusta segun tu uso',
              style: const TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 20),
            Text(
              'Nuevo intervalo (km)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: hayFoco || hayError || guardadoOk
                    ? FontWeight.w600
                    : FontWeight.w500,
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
                  width: hayFoco || hayError || guardadoOk ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      textField: true,
                      label: 'Nuevo intervalo en kilometros',
                      child: TextField(
                        controller: ctrl,
                        focusNode: foco,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 17, color: texto),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Ej. 3.000',
                          hintStyle: TextStyle(
                            color: placeholder,
                            fontSize: 17,
                          ),
                          suffixText: 'km',
                          suffixStyle: TextStyle(color: muted, fontSize: 14),
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
                    ayuda,
                    style: TextStyle(fontSize: 12, color: colorAyuda),
                  ),
                ),
              ],
            ),
            if (guardadoOk) ...[
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 14, color: teal),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Listo. Volve a Inicio para ver el pendiente recalculado.',
                      style: TextStyle(fontSize: 12, color: teal),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: fondoSuave,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sugerencia para uso intensivo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: texto,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Con ~200 km/dia, 3.000 km son mas o menos cada 15 dias. Mas seguro que el promedio de fabrica.',
                    style: TextStyle(fontSize: 13, color: muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: guardando ? null : guardar,
              style: FilledButton.styleFrom(
                backgroundColor: teal,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Guardar intervalo'),
            ),
          ],
        ),
      ),
    );
  }
}
