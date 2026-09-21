import 'package:flutter/material.dart';

import '../api.dart';
import '../componentes.dart';
import '../formato.dart';
import '../modelos.dart';
import '../tema.dart';

class RegistrarMantenimientoPantalla extends StatefulWidget {
  const RegistrarMantenimientoPantalla({
    super.key,
    required this.tipo,
    required this.kilometrajeActual,
    required this.item,
  });

  final String tipo;
  final int kilometrajeActual;
  final ProximoItem item;

  @override
  State<RegistrarMantenimientoPantalla> createState() =>
      _RegistrarMantenimientoPantallaState();
}

class _RegistrarMantenimientoPantallaState
    extends State<RegistrarMantenimientoPantalla> {
  late final TextEditingController kmCtrl;
  final kmFocus = FocusNode();
  final costoCtrl = TextEditingController();
  final costoFocus = FocusNode();

  late DateTime fecha;
  bool guardando = false;
  String? errorCampo;
  String? errorCosto;

  @override
  void initState() {
    super.initState();
    fecha = DateTime.now();
    kmCtrl = TextEditingController(text: '${widget.kilometrajeActual}');
    kmFocus.addListener(() => setState(() {}));
    costoFocus.addListener(() => setState(() {}));
    kmCtrl.addListener(() {
      if (errorCampo != null) {
        setState(() => errorCampo = null);
      } else {
        setState(() {});
      }
    });
    costoCtrl.addListener(() {
      if (errorCosto != null) {
        setState(() => errorCosto = null);
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    kmCtrl.dispose();
    kmFocus.dispose();
    costoCtrl.dispose();
    costoFocus.dispose();
    super.dispose();
  }

  int? _kmIngresado() {
    final raw = kmCtrl.text.replaceAll('.', '').replaceAll(' ', '');
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  double? _costoIngresado() {
    final raw = costoCtrl.text.replaceAll('.', '').replaceAll(',', '').replaceAll(' ', '');
    if (raw.isEmpty) return null;
    return double.tryParse(raw);
  }

  Future<void> elegirFecha() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: fecha.isAfter(hoy) ? hoy : fecha,
      firstDate: DateTime(2000),
      lastDate: hoy,
      helpText: 'Fecha del servicio',
    );
    if (picked != null) {
      setState(() => fecha = picked);
    }
  }

  Future<void> guardar() async {
    final km = _kmIngresado();
    if (km == null) {
      setState(() => errorCampo = 'Pone un numero');
      return;
    }
    if (km <= 0) {
      setState(() => errorCampo = 'Debe ser mayor a 0');
      return;
    }
    if (costoCtrl.text.trim().isNotEmpty && _costoIngresado() == null) {
      setState(() => errorCosto = 'El costo no es un numero');
      return;
    }

    setState(() => guardando = true);

    try {
      await crearMantenimiento(
        tipo: widget.tipo,
        fecha: fecha,
        kilometraje: km,
        costo: _costoIngresado(),
      );
      if (km > widget.kilometrajeActual) {
        try {
          await actualizarKm(km);
        } catch (e) {
          print(e);
        }
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() => guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el mantenimiento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = tituloTipo(widget.tipo);
    final km = _kmIngresado();
    final hayFoco = kmFocus.hasFocus;
    final hayError = errorCampo != null;
    final hayErrorCosto = errorCosto != null;
    final vacio = kmCtrl.text.trim().isEmpty;
    final puedeGuardar = !vacio && km != null && km > 0;
    final botonApagado =
        guardando || hayError || hayErrorCosto || !puedeGuardar;
    final vencido = widget.item.kilometrajes_restantes <= 0;

    Color colorBorde;
    Color colorLabel;
    Color fondoInput;
    String ayuda;
    Color colorAyuda;
    IconData iconoAyuda;
    Widget? iconoCampo;

    if (hayError) {
      colorBorde = const Color(0xFFC93D3D);
      colorLabel = const Color(0xFFC93D3D);
      fondoInput = const Color(0xFFFEF6F6);
      ayuda = errorCampo!;
      colorAyuda = const Color(0xFFC93D3D);
      iconoAyuda = Icons.error_outline;
      iconoCampo = const Icon(
        Icons.error_outline,
        color: Color(0xFFC93D3D),
        size: 20,
      );
    } else if (hayFoco) {
      colorBorde = teal;
      colorLabel = teal;
      fondoInput = const Color(0xFFFAFEFD);
      ayuda = 'Kilometraje que marco el tablero en el taller';
      colorAyuda = muted;
      iconoAyuda = Icons.info_outline;
    } else {
      colorBorde = borde;
      colorLabel = muted;
      fondoInput = Colors.white;
      ayuda = 'Se usa para calcular el proximo ${widget.tipo}';
      colorAyuda = muted;
      iconoAyuda = Icons.info_outline;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: texto,
        elevation: 0,
        title: const Text(
          'Registrar servicio',
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
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Deja asentado el servicio que ya hiciste. El proximo se recalcula solo.',
            style: TextStyle(fontSize: 13, color: muted),
          ),
          const SizedBox(height: 16),
          _resumen(vencido),
          const SizedBox(height: 20),
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kilometraje del servicio',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        hayFoco || hayError ? FontWeight.w600 : FontWeight.w500,
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
                        child: TextField(
                            controller: kmCtrl,
                            focusNode: kmFocus,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => costoFocus.requestFocus(),
                            style: const TextStyle(fontSize: 17, color: texto),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: 'Ej. 12.500',
                              hintStyle: TextStyle(
                                color: Color(0xFFB0B8B5),
                                fontSize: 17,
                              ),
                              suffixText: 'km',
                              suffixStyle:
                                  TextStyle(color: muted, fontSize: 14),
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
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Fecha del servicio',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: muted,
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            button: true,
            enabled: !guardando,
            label: 'Fecha del servicio, ${fmtFecha(fecha)}',
            hint: 'El dia en que te hicieron el servicio en el taller',
            child: ExcludeSemantics(
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: guardando ? null : elegirFecha,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borde),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            fmtFecha(fecha),
                            style: const TextStyle(fontSize: 17, color: texto),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: teal,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: muted),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'El dia en que te hicieron el servicio en el taller',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Costo del servicio',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: costoFocus.hasFocus || hayErrorCosto
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: hayErrorCosto
                        ? const Color(0xFFC93D3D)
                        : (costoFocus.hasFocus ? teal : muted),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: hayErrorCosto
                        ? const Color(0xFFFEF6F6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hayErrorCosto
                          ? const Color(0xFFC93D3D)
                          : (costoFocus.hasFocus ? teal : borde),
                      width: costoFocus.hasFocus || hayErrorCosto ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            controller: costoCtrl,
                            focusNode: costoFocus,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 17, color: texto),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: 'Ej. 180',
                              hintStyle: TextStyle(
                                color: Color(0xFFB0B8B5),
                                fontSize: 17,
                              ),
                              suffixText: 'Bs',
                              suffixStyle:
                                  TextStyle(color: muted, fontSize: 14),
                            ),
                          ),
                      ),
                      if (hayErrorCosto)
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFC93D3D),
                          size: 20,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      hayErrorCosto ? Icons.error_outline : Icons.info_outline,
                      size: 14,
                      color: hayErrorCosto
                          ? const Color(0xFFC93D3D)
                          : muted,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        hayErrorCosto
                            ? errorCosto!
                            : 'Opcional. En bolivianos.',
                        style: TextStyle(
                          fontSize: 12,
                          color: hayErrorCosto
                              ? const Color(0xFFC93D3D)
                              : muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: _botonGuardar(
              apagado: botonApagado && !guardando,
              guardando: guardando,
              onTap: botonApagado || guardando ? null : guardar,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumen(bool vencido) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borde),
        boxShadow: const [sombraCard],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: fondoSuave,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.build_outlined, color: teal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tituloTipo(widget.tipo),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Km actual del vehiculo: ${fmtMiles(widget.kilometrajeActual)} km',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
                Text(
                  vencido
                      ? 'Vencido por ${fmtMiles(widget.item.kilometrajes_restantes.abs())} km'
                      : 'Proximo a los ${fmtMiles(widget.item.proximo_kilometraje)} km',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          PillEstado(
            label: vencido ? 'VENCIDO' : 'PENDIENTE',
            color: vencido ? const Color(0xFFC93D3D) : neutro,
            fondo: vencido ? const Color(0xFFFEF6F6) : grisCaja,
          ),
        ],
      ),
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
      label = 'Guardar mantenimiento';
    } else {
      fondo = teal;
      colorTexto = Colors.white;
      label = 'Guardar mantenimiento';
    }

    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: fondo,
        foregroundColor: colorTexto,
        disabledBackgroundColor: const Color(0xFFDAE0DE),
        disabledForegroundColor: const Color(0xFF9EA6A4),
        minimumSize: const Size(230, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (extra != null) ...[
            extra,
            const SizedBox(width: 8),
          ],
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
    );
  }
}
