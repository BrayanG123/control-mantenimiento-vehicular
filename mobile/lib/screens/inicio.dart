import 'package:flutter/material.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';
import '../models/item_plan.dart';
import '../models/proximo_mantenimiento.dart';
import '../models/resumen_gastos.dart';
import '../models/vehiculo.dart';
import '../shared/widgets/estado_pantalla.dart';
import '../state/controlador_inicio.dart';
import '../state/estado_carga.dart';
import 'gastos.dart';
import 'historial.dart';
import 'plan_mantenimiento.dart';
import 'registrar_mantenimiento.dart';

class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key, this.onAbrirVehiculo});

  final VoidCallback? onAbrirVehiculo;

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  late final ControladorInicio controlador;

  Vehiculo? get vehiculo => controlador.vehiculo;
  List<ProximoMantenimiento>? get lista =>
      controlador.estado == EstadoCarga.completado
      ? controlador.proximosMantenimientos
      : null;
  ResumenGastos? get gastos => controlador.resumenGastos;
  String? get error => controlador.mensajeError;
  bool get cargando =>
      controlador.estado == EstadoCarga.inicial ||
      controlador.estado == EstadoCarga.cargando;

  @override
  void initState() {
    super.initState();
    controlador = ControladorInicio(
      vehiculoApi: DependenciasAplicacion.vehiculoApi,
      mantenimientoApi: DependenciasAplicacion.mantenimientoApi,
      gastosApi: DependenciasAplicacion.gastosApi,
    );
    controlador.addListener(_actualizarPantalla);
    controlador.cargarInicio();
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

  Future<void> cargar() {
    return controlador.cargarInicio();
  }

  void abrirHistorial() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistorialPantalla()),
    );
  }

  void abrirGastos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GastosPantalla()),
    );
  }

  Future<void> abrirPlan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlanMantenimientoPantalla()),
    );
    if (mounted) await cargar();
  }

  Future<void> abrirRegistro(ProximoMantenimiento item) async {
    final vehiculoActual = vehiculo;
    if (vehiculoActual == null) return;

    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarMantenimientoPantalla(
          tipo: item.tipo,
          kilometrajeActual: vehiculoActual.kilometrajeActual,
          item: item,
        ),
      ),
    );

    if (ok == true && mounted) {
      await cargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const VistaCargando();
    }

    if (error != null) {
      return VistaError(mensaje: error!, alReintentar: cargar);
    }

    return RefreshIndicator(
      onRefresh: cargar,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: const Text(
                      'Proximo mantenimiento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Historial de mantenimientos',
                  onPressed: abrirHistorial,
                  icon: const Icon(Icons.history),
                ),
                IconButton(
                  tooltip: 'Actualizar',
                  onPressed: cargar,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            if (controlador.intervaloAjustado != null) ...[
              const SizedBox(height: 12),
              _avisoIntervalo(controlador.intervaloAjustado!),
            ],
            const SizedBox(height: 16),
            if (vehiculo != null) ...[
              _cardVehiculo(vehiculo!),
              const SizedBox(height: 16),
              _cardPlan(),
              const SizedBox(height: 16),
              _cardGastos(),
              const SizedBox(height: 24),
            ],
            Semantics(
              header: true,
              child: const Text(
                'Mantenimientos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, cons) {
                final w = cons.maxWidth;
                const minCard = 260.0;
                const gap = 12.0;
                var cols = 1;
                if (w >= minCard * 2 + gap) cols = 2;
                if (w >= minCard * 3 + gap * 2) cols = 3;
                final cardW = cols == 1 ? w : (w - gap * (cols - 1)) / cols;
                return Wrap(
                  spacing: gap,
                  runSpacing: 16,
                  children: [
                    for (final item in lista!)
                      SizedBox(width: cardW, child: _cardMantenimiento(item)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _avisoIntervalo(ItemPlan item) {
    final nombre = item.tipo == 'aceite'
        ? 'Aceite'
        : obtenerTituloMantenimiento(item.tipo);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fondoSuave,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: teal, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Intervalo actualizado',
                  style: TextStyle(fontWeight: FontWeight.w600, color: texto),
                ),
                Text(
                  '$nombre cada ${formatearMiles(item.intervaloKm)} km · pendiente recalculado',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardPlan() {
    return Card(
      child: TextButton(
        onPressed: abrirPlan,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          foregroundColor: texto,
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: CircleAvatar(
                backgroundColor: Colors.teal.shade50,
                child: Icon(Icons.build_outlined, color: Colors.teal.shade700),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan de mantenimiento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Intervalos por tipo · toca para ajustar'),
                ],
              ),
            ),
            ExcludeSemantics(
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardGastos() {
    final monto = gastos == null
        ? '-'
        : 'Bs ${formatearMiles(gastos!.total.round())}';

    return Card(
      child: TextButton(
        onPressed: abrirGastos,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          foregroundColor: texto,
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: CircleAvatar(
                backgroundColor: Colors.teal.shade50,
                child: Icon(Icons.attach_money, color: Colors.teal.shade700),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Gastos este año',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              monto,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(width: 4),
            ExcludeSemantics(
              child: Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardVehiculo(Vehiculo vehiculo) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        onPressed: widget.onAbrirVehiculo,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          foregroundColor: texto,
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: CircleAvatar(
                backgroundColor: Colors.teal.shade50,
                child: Icon(Icons.two_wheeler, color: Colors.teal.shade700),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehiculo.marca} ${vehiculo.modelo}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${vehiculo.placa ?? '-'} · ${vehiculo.anio}'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Km actual', style: TextStyle(fontSize: 12)),
                Text(
                  '${vehiculo.kilometrajeActual}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            ExcludeSemantics(
              child: Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardMantenimiento(ProximoMantenimiento item) {
    Color color;
    String estadoTxt;

    if (item.estado == 'vencido') {
      color = rojoEstado;
      estadoTxt = 'VENCIDO';
    } else if (item.estado == 'proximo') {
      color = naranjaEstado;
      estadoTxt = 'PROXIMO';
    } else {
      color = teal;
      estadoTxt = 'AL DIA';
    }

    final intervalo = item.proximoKilometraje - (item.ultimoKilometraje ?? 0);
    var barra = 0.0;
    if (intervalo > 0) {
      barra = (intervalo - item.kilometrosRestantes) / intervalo;
      if (barra < 0) barra = 0;
      if (barra > 1) barra = 1;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        onPressed: vehiculo == null ? null : () => abrirRegistro(item),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          foregroundColor: texto,
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            ExcludeSemantics(child: Icon(Icons.circle, color: color, size: 16)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    obtenerTituloMantenimiento(item.tipo),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Proximo a los ${item.proximoKilometraje} km'),
                  Text(
                    item.estaVencido
                        ? 'Pasado por ${item.kilometrosRestantes.abs()} km'
                        : 'Restan ${item.kilometrosRestantes} km',
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  estadoTxt,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ExcludeSemantics(
                  child: SizedBox(
                    width: 60,
                    child: LinearProgressIndicator(
                      value: barra,
                      color: color,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            ExcludeSemantics(
              child: Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
