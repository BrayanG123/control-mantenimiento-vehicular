import 'package:flutter/material.dart';

import '../componentes.dart';
import '../formato.dart';
import '../modelos.dart';
import '../tema.dart';

class DetalleMantenimientoPantalla extends StatelessWidget {
  const DetalleMantenimientoPantalla({super.key, required this.mantenimiento});

  final Mantenimiento mantenimiento;

  @override
  Widget build(BuildContext context) {
    final m = mantenimiento;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: texto,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Text(
            tituloTipo(m.tipo),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
          const SizedBox(height: 16),
          _resumen(m),
          const SizedBox(height: 20),
          _datoCaja('Fecha del servicio', fmtFecha(m.fecha)),
          const SizedBox(height: 12),
          _datoCaja(
            'Kilometraje del servicio',
            '${fmtMiles(m.kilometraje)} km',
          ),
          const SizedBox(height: 12),
          _datoCaja(
            'Proximo servicio',
            '${fmtMiles(m.proximo_kilometraje)} km',
          ),
          if (m.costo != null) ...[
            const SizedBox(height: 12),
            _datoCaja('Costo', 'Bs ${fmtMiles(m.costo!.round())}'),
          ],
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: muted),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Quedo guardada la fecha y el kilometraje de este servicio.',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resumen(Mantenimiento m) {
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
            child: const Icon(Icons.check, color: teal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tituloTipo(m.tipo),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hecho el ${fmtFecha(m.fecha)}',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
                Text(
                  'A los ${fmtMiles(m.kilometraje)} km',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const PillEstado(label: 'HECHO', color: neutro, fondo: grisCaja),
        ],
      ),
    );
  }

  Widget _datoCaja(String label, String valor) {
    return Container(
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
