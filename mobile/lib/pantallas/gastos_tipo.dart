import 'package:flutter/material.dart';

import '../api.dart';
import '../componentes.dart';
import '../formato.dart';
import '../modelos.dart';
import '../tema.dart';
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
  List<Mantenimiento>? lista;
  String? error;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() {
      cargando = true;
      error = null;
    });
    try {
      final data = await obtenerHistorial();
      final filtrada = <Mantenimiento>[];
      for (final m in data) {
        if (m.tipo == widget.tipo && enPeriodo(m.fecha, widget.periodo)) {
          filtrada.add(m);
        }
      }
      filtrada.sort((a, b) {
        final ca = a.costo ?? 0;
        final cb = b.costo ?? 0;
        return cb.compareTo(ca);
      });
      if (!mounted) return;
      setState(() {
        lista = filtrada;
        cargando = false;
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        error = 'No se pudo cargar';
        cargando = false;
      });
    }
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
          tituloTipo(widget.tipo),
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
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: cargar, child: const Text('Reintentar')),
          ],
        ),
      );
    }

    final items = lista!;

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
                'Bs ${fmtMiles(widget.total.round())}',
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
        for (final m in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _fila(m),
          ),
      ],
    );
  }

  Widget _fila(Mantenimiento m) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => abrirDetalle(m),
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
                      tituloTipo(m.tipo),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: texto,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.costo != null
                          ? '${fmtFecha(m.fecha)} · ${fmtMiles(m.kilometraje)} km · Bs ${fmtMiles(m.costo!.round())}'
                          : '${fmtFecha(m.fecha)} · ${fmtMiles(m.kilometraje)} km',
                      style: const TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const PillEstado(label: 'HECHO', color: neutro, fondo: grisCaja),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
