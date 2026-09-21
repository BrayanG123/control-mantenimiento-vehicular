import 'package:flutter/material.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';
import '../models/resumen_gastos.dart';
import '../shared/widgets/estado_pantalla.dart';
import '../state/controlador_gastos.dart';
import '../state/estado_carga.dart';
import 'gastos_tipo.dart';

class GastosPantalla extends StatefulWidget {
  const GastosPantalla({super.key});

  @override
  State<GastosPantalla> createState() => _GastosPantallaState();
}

class _GastosPantallaState extends State<GastosPantalla> {
  late final ControladorGastos controlador;

  @override
  void initState() {
    super.initState();
    controlador = ControladorGastos(DependenciasAplicacion.gastosApi);
    controlador.addListener(_actualizarPantalla);
    controlador.cargarGastos();
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

  void sheetPeriodo() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Este año'),
                trailing: controlador.periodoSeleccionado == 'este_anio'
                    ? const Icon(Icons.check, color: teal)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  controlador.seleccionarPeriodo('este_anio');
                },
              ),
              ListTile(
                title: const Text('Ultimos 3 meses'),
                trailing: controlador.periodoSeleccionado == '3_meses'
                    ? const Icon(Icons.check, color: teal)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  controlador.seleccionarPeriodo('3_meses');
                },
              ),
              ListTile(
                title: const Text('Todo'),
                trailing: controlador.periodoSeleccionado == 'todo'
                    ? const Icon(Icons.check, color: teal)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  controlador.seleccionarPeriodo('todo');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void abrirTipo(GastoPorTipo item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GastosTipoPantalla(
          tipo: item.tipo,
          total: item.total,
          periodo: controlador.periodoSeleccionado,
        ),
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
          'Gastos',
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
        alReintentar: controlador.cargarGastos,
      );
    }

    final resumen = controlador.resumen!;
    final periodo = controlador.periodoSeleccionado;
    String etiqueta;
    if (periodo == '3_meses') {
      etiqueta = 'ultimos 3 meses';
    } else if (periodo == 'todo') {
      etiqueta = 'todo el historial';
    } else {
      etiqueta = 'este año';
    }

    double maxTotal = 1;
    if (resumen.porTipo.isNotEmpty) {
      maxTotal = resumen.porTipo.first.total;
      if (maxTotal <= 0) maxTotal = 1;
    }

    return RefreshIndicator(
      onRefresh: controlador.cargarGastos,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borde),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bs ${formatearMiles(resumen.total.round())}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: teal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  etiqueta,
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _cajaMini(
                  'Preventivo',
                  'Bs ${formatearMiles(resumen.preventivo.round())}',
                  fondoSuave,
                  teal,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _cajaMini(
                  'Reparacion',
                  'Bs ${formatearMiles(resumen.reparacion.round())}',
                  const Color(0xFFFEF6F6),
                  const Color(0xFFC93D3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _chip('este_anio', 'Este año'),
              const SizedBox(width: 8),
              _chip('3_meses', '3 meses'),
              const SizedBox(width: 8),
              _chip('todo', 'Todo'),
              const Spacer(),
              IconButton(
                tooltip: 'Elegir periodo de gastos',
                onPressed: sheetPeriodo,
                icon: const Icon(Icons.tune, color: muted),
              ),
            ],
          ),
          if (resumen.sinCosto > 0) ...[
            Text(
              resumen.sinCosto == 1
                  ? 'Hay 1 servicio sin costo'
                  : 'Hay ${resumen.sinCosto} servicios sin costo',
              style: const TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          const Text(
            'Desglose por tipo',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: texto,
            ),
          ),
          const SizedBox(height: 12),
          if (resumen.porTipo.isEmpty)
            const Text(
              'Todavia no hay gastos con costo en este periodo.',
              style: TextStyle(fontSize: 13, color: muted),
            ),
          for (final item in resumen.porTipo)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _rubro(item, maxTotal),
            ),
        ],
      ),
    );
  }

  Widget _cajaMini(String label, String valor, Color fondo, Color colorValor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: muted)),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorValor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String id, String label) {
    final on = controlador.periodoSeleccionado == id;
    return GestureDetector(
      onTap: () => controlador.seleccionarPeriodo(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: on ? teal : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: on ? teal : borde),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: on ? Colors.white : texto,
          ),
        ),
      ),
    );
  }

  Widget _rubro(GastoPorTipo item, double maxTotal) {
    var barra = 0.0;
    if (maxTotal > 0) {
      barra = item.total / maxTotal;
      if (barra > 1) barra = 1;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => abrirTipo(item),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borde),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      obtenerTituloMantenimiento(item.tipo),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: texto,
                      ),
                    ),
                  ),
                  Text(
                    'Bs ${formatearMiles(item.total.round())}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: teal,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: muted, size: 18),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: barra,
                  minHeight: 6,
                  color: teal,
                  backgroundColor: fondoSuave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
