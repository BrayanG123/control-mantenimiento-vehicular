import 'package:flutter/material.dart';

import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';
import '../models/item_plan.dart';
import 'editar_intervalo.dart';

class DetalleIntervaloPantalla extends StatefulWidget {
  const DetalleIntervaloPantalla({super.key, required this.item});

  final ItemPlan item;

  @override
  State<DetalleIntervaloPantalla> createState() =>
      _DetalleIntervaloPantallaState();
}

class _DetalleIntervaloPantallaState extends State<DetalleIntervaloPantalla> {
  late int intervaloKm;
  late bool personalizado;

  @override
  void initState() {
    super.initState();
    intervaloKm = widget.item.intervaloKm;
    personalizado = widget.item.personalizado;
  }

  Future<void> editar() async {
    final nuevo = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => EditarIntervaloPantalla(
          tipo: widget.item.tipo,
          intervaloActual: intervaloKm,
          intervaloFabrica: widget.item.intervaloFabrica,
        ),
      ),
    );
    if (nuevo == null || !mounted) return;
    setState(() {
      intervaloKm = nuevo;
      personalizado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final origen = personalizado ? 'Ajustado a tu uso' : 'Fabrica / promedio';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: texto,
        elevation: 0,
        title: Text(
          obtenerTituloMantenimiento(widget.item.tipo),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Text(
            'Detalle del item del plan',
            style: TextStyle(fontSize: 13, color: muted),
          ),
          const SizedBox(height: 16),
          _caja('Intervalo actual', '${formatearMiles(intervaloKm)} km'),
          const SizedBox(height: 12),
          _caja('Origen', origen),
          const SizedBox(height: 12),
          _caja('Por que se recomienda?', motivoDelIntervalo(widget.item.tipo)),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: editar,
            style: FilledButton.styleFrom(
              backgroundColor: teal,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Editar intervalo'),
          ),
        ],
      ),
    );
  }

  Widget _caja(String label, String valor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: grisCaja,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: muted)),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: texto,
            ),
          ),
        ],
      ),
    );
  }
}
