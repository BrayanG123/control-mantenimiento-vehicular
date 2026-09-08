import 'package:flutter/material.dart';

import '../api.dart';
import '../componentes.dart';
import '../formato.dart';
import '../modelos.dart';
import '../tema.dart';
import 'detalle_mantenimiento.dart';

class HistorialPantalla extends StatefulWidget {
  const HistorialPantalla({super.key});

  @override
  State<HistorialPantalla> createState() => _HistorialPantallaState();
}

class _HistorialPantallaState extends State<HistorialPantalla> {
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
      if (!mounted) return;
      setState(() {
        lista = data;
        cargando = false;
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        error = 'No se pudo cargar el historial';
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

    if (lista!.isEmpty) {
      return _vacio();
    }

    return RefreshIndicator(
      onRefresh: cargar,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            lista!.length == 1
                ? '1 servicio registrado'
                : '${lista!.length} servicios registrados',
            style: const TextStyle(fontSize: 13, color: muted),
          ),
          const SizedBox(height: 16),
          for (final m in lista!)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _fila(m),
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
              'Cuando registres un mantenimiento va a quedar aca con su fecha y su kilometraje.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: muted),
            ),
          ],
        ),
      ),
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
                      '${fmtFecha(m.fecha)} · ${fmtMiles(m.kilometraje)} km',
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
