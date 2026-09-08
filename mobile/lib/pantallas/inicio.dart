import 'package:flutter/material.dart';

import '../api.dart';
import '../modelos.dart';
import 'historial.dart';

class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key});

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  Vehiculo? vehiculo;
  List<ProximoItem>? lista;
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
      final v = await obtenerVehiculo();
      final data = await obtenerProximos();
      data.sort((a, b) {
        final pa = _prio(a);
        final pb = _prio(b);
        if (pa != pb) return pa.compareTo(pb);
        return a.kilometrajes_restantes.compareTo(b.kilometrajes_restantes);
      });
      setState(() {
        vehiculo = v;
        lista = data;
        cargando = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = 'No se pudo cargar';
        cargando = false;
      });
    }
  }

  void abrirHistorial() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistorialPantalla()),
    );
  }

  // 0 = vencido, 1 = proximo, 2 = al dia
  int _prio(ProximoItem item) {
    if (item.kilometrajes_restantes <= 0) return 0;
    final intervalo = item.proximo_kilometraje - (item.ultimo_kilometraje ?? 0);
    if (item.kilometrajes_restantes <= intervalo * 0.2) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
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

    return RefreshIndicator(
      onRefresh: cargar,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Proximo mantenimiento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: abrirHistorial,
                icon: const Icon(Icons.history),
              ),
              IconButton(onPressed: cargar, icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 16),
          if (vehiculo != null) ...[
            _cardVehiculo(vehiculo!),
            const SizedBox(height: 24),
          ],
          const Text(
            'Mantenimientos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          for (final item in lista!)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _cardMantenimiento(item),
            ),
        ],
      ),
    );
  }

  Widget _cardVehiculo(Vehiculo v) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal.shade50,
              child: Icon(Icons.two_wheeler, color: Colors.teal.shade700),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${v.marca} ${v.modelo}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${v.placa ?? '-'} · ${v.anio}'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Km actual', style: TextStyle(fontSize: 12)),
                Text(
                  '${v.kilometraje_actual}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardMantenimiento(ProximoItem item) {
    final p = _prio(item);
    Color color;
    String estadoTxt;

    if (p == 0) {
      color = Colors.red;
      estadoTxt = 'VENCIDO';
    } else if (p == 1) {
      color = Colors.orange.shade800;
      estadoTxt = 'PROXIMO';
    } else {
      color = Colors.teal.shade700;
      estadoTxt = 'AL DIA';
    }

    final intervalo = item.proximo_kilometraje - (item.ultimo_kilometraje ?? 0);
    var barra = 0.0;
    if (intervalo > 0) {
      barra = (intervalo - item.kilometrajes_restantes) / intervalo;
      if (barra < 0) barra = 0;
      if (barra > 1) barra = 1;
    }

    final tipo = item.tipo[0].toUpperCase() + item.tipo.substring(1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.circle, color: color, size: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tipo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Proximo a los ${item.proximo_kilometraje} km'),
                  Text(
                    item.kilometrajes_restantes <= 0
                        ? 'Pasado por ${item.kilometrajes_restantes.abs()} km'
                        : 'Restan ${item.kilometrajes_restantes} km',
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
                SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(
                    value: barra,
                    color: color,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
