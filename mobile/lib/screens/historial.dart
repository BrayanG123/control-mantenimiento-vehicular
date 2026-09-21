import 'package:flutter/material.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';
import '../models/mantenimiento.dart';
import '../shared/widgets/indicador_estado.dart';
import '../shared/widgets/estado_pantalla.dart';
import '../state/controlador_historial.dart';
import '../state/estado_carga.dart';
import 'detalle_mantenimiento.dart';

class HistorialPantalla extends StatefulWidget {
  const HistorialPantalla({super.key});

  @override
  State<HistorialPantalla> createState() => _HistorialPantallaState();
}

class _HistorialPantallaState extends State<HistorialPantalla> {
  late final ControladorHistorial controlador;

  @override
  void initState() {
    super.initState();
    controlador = ControladorHistorial(DependenciasAplicacion.mantenimientoApi);
    controlador.addListener(_actualizarPantalla);
    controlador.cargarHistorial();
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
        title: const Text(
          'Historial',
          style: TextStyle(
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
        alReintentar: controlador.cargarHistorial,
      );
    }

    if (controlador.mantenimientos.isEmpty) {
      return _vacio();
    }

    return RefreshIndicator(
      onRefresh: controlador.cargarHistorial,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            controlador.mantenimientos.length == 1
                ? '1 servicio registrado'
                : '${controlador.mantenimientos.length} servicios registrados',
            style: const TextStyle(fontSize: 13, color: muted),
          ),
          const SizedBox(height: 16),
          for (final mantenimiento in controlador.mantenimientos)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _fila(mantenimiento),
            ),
        ],
      ),
    );
  }

  Widget _vacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: grisCaja,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.history, color: muted, size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              'Todavia no hay servicios registrados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: texto,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cuando registres un mantenimiento va a quedar aca con fecha, km y el costo si lo pusiste.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: muted),
            ),
          ],
        ),
      ),
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
