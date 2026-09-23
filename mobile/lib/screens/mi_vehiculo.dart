import 'package:flutter/material.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';
import '../models/vehiculo.dart';
import '../state/controlador_vehiculo.dart';
import '../state/estado_carga.dart';
import 'plan_mantenimiento.dart';

const _teal = Color(0xFF00695C);
const _muted = muted;
const _texto = texto;
const _borde = borde;
const _fondoSuave = fondoSuave;
const _grisCaja = grisCaja;
const _errorRojo = rojoEstado;
const _placeholder = placeholder;

class MiVehiculoPantalla extends StatefulWidget {
  const MiVehiculoPantalla({super.key, this.onCerrarSesion});

  final VoidCallback? onCerrarSesion;

  @override
  State<MiVehiculoPantalla> createState() => _MiVehiculoPantallaState();
}

class _MiVehiculoPantallaState extends State<MiVehiculoPantalla> {
  late final ControladorVehiculo controlador;
  bool guardadoOk = false;
  String? errorCampo;
  int? kmSumados;

  Vehiculo? get vehiculo => controlador.vehiculo;
  String? get error => controlador.mensajeError;
  bool get cargando =>
      controlador.estado == EstadoCarga.inicial ||
      controlador.estado == EstadoCarga.cargando;
  bool get guardando => controlador.estaGuardando;

  final kmCtrl = TextEditingController();
  final kmFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    controlador = ControladorVehiculo(DependenciasAplicacion.vehiculoApi);
    controlador.addListener(_actualizarPantalla);
    kmFocus.addListener(() {
      setState(() {});
    });
    kmCtrl.addListener(() {
      if (errorCampo != null || guardadoOk) {
        setState(() {
          errorCampo = null;
          guardadoOk = false;
          kmSumados = null;
        });
      } else {
        setState(() {});
      }
    });
    controlador.cargarVehiculo();
  }

  void _actualizarPantalla() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    kmCtrl.dispose();
    kmFocus.dispose();
    controlador
      ..removeListener(_actualizarPantalla)
      ..dispose();
    super.dispose();
  }

  int? _kmIngresado() {
    final raw = kmCtrl.text.replaceAll('.', '').replaceAll(' ', '');
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  Future<void> guardarKm() async {
    final vehiculoActual = vehiculo;
    if (vehiculoActual == null) return;

    final km = _kmIngresado();
    if (km == null) {
      setState(() {
        errorCampo = 'Pone un numero';
        guardadoOk = false;
      });
      return;
    }

    if (km <= vehiculoActual.kilometrajeActual) {
      setState(() {
        errorCampo =
            'Debe ser mayor al ultimo registrado: ${formatearMiles(vehiculoActual.kilometrajeActual)} km';
        guardadoOk = false;
      });
      return;
    }

    setState(() {
      errorCampo = null;
      guardadoOk = false;
    });

    final kilometrajeAnterior = vehiculoActual.kilometrajeActual;
    final actualizado = await controlador.actualizarKilometraje(km);
    if (!mounted) return;
    if (actualizado) {
      setState(() {
        kmSumados = km - kilometrajeAnterior;
        guardadoOk = true;
        kmCtrl.clear();
      });
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(controlador.mensajeError!)));
  }

  Widget _cabecera() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Mi vehiculo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _texto,
            ),
          ),
        ),
        if (widget.onCerrarSesion != null)
          TextButton.icon(
            onPressed: widget.onCerrarSesion,
            icon: const Icon(Icons.logout, size: 18, color: _teal),
            label: const Text(
              'Cerrar sesion',
              style: TextStyle(
                color: _teal,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            _cabecera(),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    if (error != null || vehiculo == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            _cabecera(),
            Expanded(
              child: Center(child: Text(error ?? 'sin vehiculo')),
            ),
            if (widget.onCerrarSesion != null) ...[
              const SizedBox(height: 16),
              _botonCerrarSesion(),
            ],
          ],
        ),
      );
    }

    final vehiculoActual = vehiculo!;
    final km = _kmIngresado();
    final hayFoco = kmFocus.hasFocus;
    final hayError = errorCampo != null;
    final vacio = kmCtrl.text.trim().isEmpty;

    Color colorBorde;
    Color colorLabel;
    Color fondoInput;
    String ayuda;
    Color colorAyuda;
    IconData iconoAyuda;
    Widget? iconoCampo;

    if (hayError) {
      colorBorde = _errorRojo;
      colorLabel = _errorRojo;
      fondoInput = const Color(0xFFFEF6F6);
      ayuda = errorCampo!;
      colorAyuda = _errorRojo;
      iconoAyuda = Icons.error_outline;
      iconoCampo = const Icon(Icons.error_outline, color: _errorRojo, size: 20);
    } else if (guardadoOk) {
      colorBorde = _teal;
      colorLabel = _teal;
      fondoInput = const Color(0xFFF4FBF9);
      ayuda = kmSumados == null
          ? 'Kilometraje guardado'
          : 'Kilometraje guardado · sumaste ${formatearMiles(kmSumados!)} km';
      colorAyuda = _teal;
      iconoAyuda = Icons.check_circle_outline;
      iconoCampo = const Icon(
        Icons.check_circle_outline,
        color: _teal,
        size: 20,
      );
    } else if (hayFoco) {
      colorBorde = _teal;
      colorLabel = _teal;
      fondoInput = const Color(0xFFFAFEFD);
      ayuda = 'Escribi el numero que marca el tablero hoy';
      colorAyuda = _muted;
      iconoAyuda = Icons.info_outline;
    } else {
      colorBorde = _borde;
      colorLabel = _muted;
      fondoInput = Colors.white;
      ayuda = 'Se usa para calcular los proximos mantenimientos';
      colorAyuda = _muted;
      iconoAyuda = Icons.info_outline;
    }

    final puedeGuardar =
        !vacio && km != null && km > vehiculoActual.kilometrajeActual;
    final botonApagado = guardando || hayError || !puedeGuardar;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _cabecera(),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, cons) {
            final ficha = Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borde),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A34403D),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: _fondoSuave,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.two_wheeler,
                          color: _teal,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehiculoActual.marca,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: _texto,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              vehiculoActual.modelo,
                              style: const TextStyle(
                                fontSize: 14,
                                color: _muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: _borde),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _datoCaja('Anio', '${vehiculoActual.anio}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _datoCaja('Placa', vehiculoActual.placa ?? '-'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: _fondoSuave,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Kilometraje actual',
                            style: TextStyle(fontSize: 13, color: _muted),
                          ),
                        ),
                        Text(
                          '${formatearMiles(vehiculoActual.kilometrajeActual)} km',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: _teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

            final form = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actualizar kilometraje',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _texto,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Kilometraje actual',
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
                          label: 'Kilometraje actual en kilometros',
                          child: TextField(
                            controller: kmCtrl,
                            focusNode: kmFocus,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 17, color: _texto),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: 'Ej. 12.500',
                              hintStyle: TextStyle(
                                color: _placeholder,
                                fontSize: 17,
                              ),
                              suffixText: 'km',
                              suffixStyle: TextStyle(
                                color: _muted,
                                fontSize: 14,
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
                        ayuda,
                        style: TextStyle(fontSize: 12, color: colorAyuda),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _botonGuardar(
                    apagado: botonApagado && !guardando && !guardadoOk,
                    guardando: guardando,
                    listo: guardadoOk,
                    onTap: botonApagado || guardando ? null : guardarKm,
                  ),
                ),
              ],
            );

            if (cons.maxWidth < 600) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ficha, const SizedBox(height: 20), form],
              );
            }
            final colW = (cons.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(width: colW, child: ficha),
                SizedBox(width: colW, child: form),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        _entradaPlan(),
        if (widget.onCerrarSesion != null) ...[
          const SizedBox(height: 32),
          _botonCerrarSesion(),
        ],
      ],
    );
  }

  void abrirPlan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlanMantenimientoPantalla()),
    );
  }

  Widget _entradaPlan() {
    return TextButton(
      onPressed: abrirPlan,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16),
        foregroundColor: _texto,
        alignment: Alignment.centerLeft,
        minimumSize: const Size(double.infinity, 72),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _borde),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.build_outlined, color: _teal),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan de mantenimiento',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _texto,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Intervalos por tipo · toca para ajustar',
                  style: TextStyle(fontSize: 12, color: _muted),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: _muted),
        ],
      ),
    );
  }

  Widget _botonCerrarSesion() {
    return Semantics(
      button: true,
      label: 'Cerrar sesion',
      child: OutlinedButton.icon(
        onPressed: widget.onCerrarSesion,
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Cerrar sesion'),
        style: OutlinedButton.styleFrom(
          foregroundColor: _teal,
          side: const BorderSide(color: _borde),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _datoCaja(String label, String valor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _grisCaja,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: _muted)),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _texto,
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonGuardar({
    required bool apagado,
    required bool guardando,
    required bool listo,
    required VoidCallback? onTap,
  }) {
    Color fondo;
    Color texto;
    Color? borde;
    String label;
    Widget? extra;

    if (guardando) {
      fondo = _teal.withValues(alpha: 0.8);
      texto = Colors.white;
      label = 'Guardando...';
      extra = const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    } else if (listo) {
      fondo = _fondoSuave;
      texto = _teal;
      borde = _teal;
      label = 'Kilometraje guardado';
      extra = const Icon(Icons.check, size: 18, color: _teal);
    } else if (apagado) {
      fondo = const Color(0xFFDAE0DE);
      texto = const Color(0xFF9EA6A4);
      label = 'Guardar kilometraje';
    } else {
      fondo = _teal;
      texto = Colors.white;
      label = 'Guardar kilometraje';
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: borde == null
                  ? null
                  : Border.all(color: borde, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (extra != null) ...[extra, const SizedBox(width: 8)],
                Text(
                  label,
                  style: TextStyle(
                    color: texto,
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
