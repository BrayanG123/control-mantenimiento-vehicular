import 'package:flutter/material.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';
import '../models/mantenimiento.dart';
import '../shared/widgets/indicador_estado.dart';
import '../shared/widgets/estado_pantalla.dart';
import '../state/controlador_gastos_tipo.dart';
import '../state/estado_carga.dart';
import 'detalle_mantenimiento.dart';

class GastosTipoPantalla extends StatefulWidget {
  const GastosTipoPantalla({
    super.key,
    required this.tipo,
    required this.total,
    required this.periodo,
  });

  final String tipo;
  final double total;
  final String periodo;

  @override
  State<GastosTipoPantalla> createState() => _GastosTipoPantallaState();
}

class _GastosTipoPantallaState extends State<GastosTipoPantalla> {
  late final ControladorGastosTipo controlador;

  @override
  void initState() {
    super.initState();
    controlador = ControladorGastosTipo(
      DependenciasAplicacion.mantenimientoApi,
    );
    controlador.addListener(_actualizarPantalla);
    controlador.cargarMantenimientos(
      tipo: widget.tipo,
      periodo: widget.periodo,
    );
  }

  void _actualizarPantalla() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controlador
      ..removeListener(_actualizarPantalla)
      ..dispose();
    super.dispose();
  }

  void abrirDetalle(Mantenimiento m) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleMantenimientoPantalla(mantenimiento: m),
      ),
    );
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
        title: Text(
          obtenerTituloMantenimiento(widget.tipo),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),
      ),
      body: _cuerpo(),
    );
  }

  Widget _cuerpo() {
    if (controlador.estado == EstadoCarga.cargando ||
        controlador.estado == EstadoCarga.inicial) {
      return const VistaCargando();
    }

    if (controlador.estado == EstadoCarga.error) {
      return VistaError(
        mensaje: controlador.mensajeError!,
        alReintentar: () => controlador.cargarMantenimientos(
          tipo: widget.tipo,
          periodo: widget.periodo,
        ),
      );
    }

    final items = controlador.mantenimientos;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          items.isEmpty
              ? 'No hay servicios de este tipo en el periodo'
              : '${items.length} servicio${items.length == 1 ? '' : 's'}',
          style: const TextStyle(fontSize: 13, color: muted),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: fondoSuave,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('Total', style: TextStyle(fontSize: 12, color: muted)),
              const Spacer(),
              Text(
                'Bs ${formatearMiles(widget.total.round())}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: teal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final mantenimiento in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _fila(mantenimiento),
          ),
      ],
    );
  }

  Widget _fila(Mantenimiento mantenimiento) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => abrirDetalle(mantenimiento),
        borderRadius: BorderRadius.circular(16),
        highlightColor: grisCaja,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borde),
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
                      mantenimiento.costo != null
                          ? '${formatearFecha(mantenimiento.fecha)} · ${formatearMiles(mantenimiento.kilometraje)} km · Bs ${formatearMiles(mantenimiento.costo!.round())}'
                          : '${formatearFecha(mantenimiento.fecha)} · ${formatearMiles(mantenimiento.kilometraje)} km',
                      style: const TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const IndicadorEstado(
                label: 'HECHO',
                color: neutro,
                fondo: grisCaja,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
