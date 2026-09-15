import 'package:flutter/material.dart';

import '../api.dart';
import '../formato.dart';
import '../modelos.dart';
import '../tema.dart';
import 'gastos_tipo.dart';

class GastosPantalla extends StatefulWidget {
  const GastosPantalla({super.key});

  @override
  State<GastosPantalla> createState() => _GastosPantallaState();
}

class _GastosPantallaState extends State<GastosPantalla> {
  ResumenGastos? resumen;
  String periodo = 'este_anio';
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
      final r = await obtenerGastos(periodo: periodo);
      if (!mounted) return;
      setState(() {
        resumen = r;
        cargando = false;
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        error = 'No se pudo cargar los gastos';
        cargando = false;
      });
    }
  }

  void cambiarPeriodo(String p) {
    if (p == periodo) return;
    setState(() {
      periodo = p;
    });
    cargar();
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
                trailing: periodo == 'este_anio' ? const Icon(Icons.check, color: teal) : null,
                onTap: () {
                  Navigator.pop(ctx);
                  cambiarPeriodo('este_anio');
                },
              ),
              ListTile(
                title: const Text('Ultimos 3 meses'),
                trailing: periodo == '3_meses' ? const Icon(Icons.check, color: teal) : null,
                onTap: () {
                  Navigator.pop(ctx);
                  cambiarPeriodo('3_meses');
                },
              ),
              ListTile(
                title: const Text('Todo'),
                trailing: periodo == 'todo' ? const Icon(Icons.check, color: teal) : null,
                onTap: () {
                  Navigator.pop(ctx);
                  cambiarPeriodo('todo');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void abrirTipo(ItemGasto item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GastosTipoPantalla(
          tipo: item.tipo,
          total: item.total,
          periodo: periodo,
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

    final r = resumen!;
    String etiqueta;
    if (periodo == '3_meses') {
      etiqueta = 'ultimos 3 meses';
    } else if (periodo == 'todo') {
      etiqueta = 'todo el historial';
    } else {
      etiqueta = 'este año';
    }

    double maxTotal = 1;
    if (r.por_tipo.isNotEmpty) {
      maxTotal = r.por_tipo.first.total;
      if (maxTotal <= 0) maxTotal = 1;
    }

    return RefreshIndicator(
      onRefresh: cargar,
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
                const Text('Total', style: TextStyle(fontSize: 11, color: muted)),
                const SizedBox(height: 4),
                Text(
                  'Bs ${fmtMiles(r.total.round())}',
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
                  'Bs ${fmtMiles(r.preventivo.round())}',
                  fondoSuave,
                  teal,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _cajaMini(
                  'Reparacion',
                  'Bs ${fmtMiles(r.reparacion.round())}',
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
                onPressed: sheetPeriodo,
                icon: const Icon(Icons.tune, color: muted),
              ),
            ],
          ),
          if (r.sin_costo > 0) ...[
            Text(
              r.sin_costo == 1
                  ? 'Hay 1 servicio sin costo'
                  : 'Hay ${r.sin_costo} servicios sin costo',
              style: const TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          const Text(
            'Desglose por tipo',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: texto),
          ),
          const SizedBox(height: 12),
          if (r.por_tipo.isEmpty)
            const Text(
              'Todavia no hay gastos con costo en este periodo.',
              style: TextStyle(fontSize: 13, color: muted),
            ),
          for (final item in r.por_tipo)
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
    final on = periodo == id;
    return GestureDetector(
      onTap: () => cambiarPeriodo(id),
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

  Widget _rubro(ItemGasto item, double maxTotal) {
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
                      tituloTipo(item.tipo),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: texto,
                      ),
                    ),
                  ),
                  Text(
                    'Bs ${fmtMiles(item.total.round())}',
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
