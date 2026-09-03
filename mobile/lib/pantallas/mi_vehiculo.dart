import 'package:flutter/material.dart';
import '../api.dart';
import '../modelos.dart';

const _teal = Color(0xFF00695C);
const _muted = Color(0xFF98A3A0);
const _texto = Color(0xFF34403D);
const _borde = Color(0xFFCFD8D5);
const _fondoSuave = Color(0xFFE8F5F2);
const _grisCaja = Color(0xFFE7ECEA);
const _errorRojo = Color(0xFFC93D3D);
const _placeholder = Color(0xFFB0B8B5);

class MiVehiculoPantalla extends StatefulWidget {
  const MiVehiculoPantalla({super.key});

  @override
  State<MiVehiculoPantalla> createState() => _MiVehiculoPantallaState();
}

class _MiVehiculoPantallaState extends State<MiVehiculoPantalla> {
  Vehiculo? vehiculo;
  String? error;
  bool cargando = true;
  bool guardando = false;
  bool guardadoOk = false;
  String? errorCampo;
  int? kmSumados;

  final kmCtrl = TextEditingController();
  final kmFocus = FocusNode();

  @override
  void initState() {
    super.initState();
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
    cargar();
  }

  @override
  void dispose() {
    kmCtrl.dispose();
    kmFocus.dispose();
    super.dispose();
  }

  Future<void> cargar() async {
    setState(() {
      cargando = true;
      error = null;
    });
    try {
      final v = await obtenerVehiculo();
      setState(() {
        vehiculo = v;
        kmCtrl.clear();
        cargando = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = 'Error al cargar vehiculo';
        cargando = false;
      });
    }
  }

  int? _kmIngresado() {
    final raw = kmCtrl.text.replaceAll('.', '').replaceAll(' ', '');
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  Future<void> guardarKm() async {
    final v = vehiculo;
    if (v == null) return;

    final km = _kmIngresado();
    if (km == null) {
      setState(() {
        errorCampo = 'Pone un numero';
        guardadoOk = false;
      });
      return;
    }

    if (km <= v.kilometraje_actual) {
      setState(() {
        errorCampo =
            'Debe ser mayor al ultimo registrado: ${_fmt(v.kilometraje_actual)} km';
        guardadoOk = false;
      });
      return;
    }

    setState(() {
      guardando = true;
      errorCampo = null;
      guardadoOk = false;
    });

    try {
      final actualizado = await actualizarKm(km);
      if (!mounted) return;
      setState(() {
        kmSumados = km - v.kilometraje_actual;
        vehiculo = actualizado;
        guardando = false;
        guardadoOk = true;
        kmCtrl.clear();
      });
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          guardando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('no se pudo actualizar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null || vehiculo == null) {
      return Center(child: Text(error ?? 'sin vehiculo'));
    }

    final v = vehiculo!;
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
          : 'Kilometraje guardado · sumaste ${_fmt(kmSumados!)} km';
      colorAyuda = _teal;
      iconoAyuda = Icons.check_circle_outline;
      iconoCampo = const Icon(Icons.check_circle_outline, color: _teal, size: 20);
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

    final puedeGuardar = !vacio && km != null && km > v.kilometraje_actual;
    final botonApagado = guardando || hayError || !puedeGuardar;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
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
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('editar viene mas adelante')),
                );
              },
              icon: const Icon(Icons.edit_outlined, color: _teal),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
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
                    child: const Icon(Icons.two_wheeler, color: _teal, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.marca,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: _texto,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          v.modelo,
                          style: const TextStyle(fontSize: 14, color: _muted),
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
                    child: _datoCaja('Anio', '${v.anio}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _datoCaja('Placa', v.placa ?? '-'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      '${_fmt(v.kilometraje_actual)} km',
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
        ),
        const SizedBox(height: 20),
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
                child: TextField(
                  controller: kmCtrl,
                  focusNode: kmFocus,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 17, color: _texto),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Ej. 12.500',
                    hintStyle: TextStyle(color: _placeholder, fontSize: 17),
                    suffixText: 'km',
                    suffixStyle: TextStyle(color: _muted, fontSize: 14),
                  ),
                ),
              ),
              if (iconoCampo != null) iconoCampo,
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

    return Material(
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
            border: borde == null ? null : Border.all(color: borde, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (extra != null) ...[
                extra,
                const SizedBox(width: 8),
              ],
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
    );
  }
}

String _fmt(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final resto = s.length - i;
    if (i != 0 && resto % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}
