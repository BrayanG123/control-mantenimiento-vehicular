import 'package:flutter/material.dart';

import '../core/dependencies/dependencias_aplicacion.dart';
import '../core/theme/tema_aplicacion.dart';
import '../core/utils/formato.dart';
import '../models/item_plan.dart';
import '../shared/widgets/estado_pantalla.dart';
import '../shared/widgets/indicador_estado.dart';
import '../state/controlador_plan.dart';
import '../state/estado_carga.dart';
import 'detalle_intervalo.dart';

class PlanMantenimientoPantalla extends StatefulWidget {
  const PlanMantenimientoPantalla({super.key});

  @override
  State<PlanMantenimientoPantalla> createState() =>
      _PlanMantenimientoPantallaState();
}

class _PlanMantenimientoPantallaState extends State<PlanMantenimientoPantalla> {
  late final ControladorPlan controlador;

  @override
  void initState() {
    super.initState();
    controlador = ControladorPlan(
      DependenciasAplicacion.mantenimientoApi,
      DependenciasAplicacion.vehiculoApi,
    );
    controlador.addListener(_actualizar);
    controlador.cargar();
  }

  void _actualizar() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controlador
      ..removeListener(_actualizar)
      ..dispose();
    super.dispose();
  }

  Future<void> abrirDetalle(ItemPlan item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleIntervaloPantalla(item: item),
      ),
    );
    if (mounted) await controlador.cargar();
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
          'Plan de mantenimiento',
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
    if (controlador.estado == EstadoCarga.inicial ||
        controlador.estado == EstadoCarga.cargando) {
      return const VistaCargando();
    }

    if (controlador.estado == EstadoCarga.error) {
      return VistaError(
        mensaje: controlador.mensajeError ?? 'No se pudo cargar el plan',
        alReintentar: controlador.cargar,
      );
    }

    final v = controlador.vehiculo;
    final subtitulo = v == null
        ? 'Uso intensivo (~200 km/dia)'
        : '${v.marca} ${v.modelo} · uso intensivo (~200 km/dia)';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(subtitulo, style: const TextStyle(fontSize: 12, color: muted)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: fondoSuave,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu uso es mas intenso que el promedio',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: texto,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Podes acortar intervalos para no llegar tarde al taller.',
                style: TextStyle(fontSize: 13, color: muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final item in controlador.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _fila(item),
          ),
      ],
    );
  }

  Widget _fila(ItemPlan item) {
    final Color color;
    final String estadoTxt;
    final Color fondoEstado;
    if (item.estado == 'vencido') {
      color = rojoEstado;
      estadoTxt = 'VENCIDO';
      fondoEstado = const Color(0xFFFEF6F6);
    } else if (item.estado == 'proximo') {
      color = naranjaEstado;
      estadoTxt = 'PROXIMO';
      fondoEstado = const Color(0xFFFFF6E8);
    } else {
      color = teal;
      estadoTxt = 'AL DIA';
      fondoEstado = fondoSuave;
    }

    final intervaloTxt = item.tipo == 'aceite'
        ? 'Intervalo actual: cada ${formatearMiles(item.intervaloKm)} km'
        : 'Intervalo: cada ${formatearMiles(item.intervaloKm)} km';
    final origen = item.personalizado
        ? 'Ajustado a tu uso'
        : (item.tipo == 'aceite' ? 'Fabrica · uso promedio' : 'Sin cambios');

    return TextButton(
      onPressed: () => abrirDetalle(item),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16),
        foregroundColor: texto,
        alignment: Alignment.centerLeft,
        minimumSize: const Size(double.infinity, 72),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borde),
        ),
      ),
      child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      obtenerTituloMantenimiento(item.tipo),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: texto,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      intervaloTxt,
                      style: const TextStyle(fontSize: 12, color: muted),
                    ),
                    Text(
                      origen,
                      style: const TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
              IndicadorEstado(
                label: estadoTxt,
                color: color,
                fondo: fondoEstado,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: muted, size: 20),
            ],
      ),
    );
  }
}
