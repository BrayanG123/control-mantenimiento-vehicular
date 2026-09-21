import 'package:flutter/material.dart';

import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';
import '../models/mantenimiento.dart';
import '../shared/widgets/indicador_estado.dart';

class DetalleMantenimientoPantalla extends StatelessWidget {
  const DetalleMantenimientoPantalla({super.key, required this.mantenimiento});

  final Mantenimiento mantenimiento;

  @override
  Widget build(BuildContext context) {
    final mantenimientoActual = mantenimiento;

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
            obtenerTituloMantenimiento(mantenimientoActual.tipo),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
          const SizedBox(height: 16),
          _resumen(mantenimientoActual),
          const SizedBox(height: 20),
          if (mantenimientoActual.costo != null) ...[
            _datoCaja(
              'Costo del servicio',
              'Bs ${formatearMiles(mantenimientoActual.costo!.round())}',
            ),
            const SizedBox(height: 12),
          ],
          _datoCaja(
            'Fecha del servicio',
            formatearFecha(mantenimientoActual.fecha),
          ),
          const SizedBox(height: 12),
          _datoCaja(
            'Kilometraje del servicio',
            '${formatearMiles(mantenimientoActual.kilometraje)} km',
          ),
          if (mantenimientoActual.tipo != 'cadena') ...[
            const SizedBox(height: 12),
            _datoCaja(
              'Proximo servicio',
              '${formatearMiles(mantenimientoActual.proximoKilometraje)} km',
            ),
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

  Widget _resumen(Mantenimiento mantenimiento) {
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
                  obtenerTituloMantenimiento(mantenimiento.tipo),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hecho el ${formatearFecha(mantenimiento.fecha)}',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
                Text(
                  'A los ${formatearMiles(mantenimiento.kilometraje)} km',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const IndicadorEstado(label: 'HECHO', color: neutro, fondo: grisCaja),
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
