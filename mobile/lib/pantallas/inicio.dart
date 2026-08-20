import 'package:flutter/material.dart';
import '../api.dart';
import '../modelos.dart';

class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key});

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
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
      final data = await obtenerProximos();
      setState(() {
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
      child: ListView.builder(
        itemCount: lista!.length,
        itemBuilder: (context, i) {
          final item = lista![i];
          return ListTile(
            title: Text(item.tipo.toUpperCase()),
            subtitle: Text(
              'Proximo a los ${item.proximo_kilometraje} km\n'
              'Restan: ${item.kilometrajes_restantes} km',
            ),
            isThreeLine: true,
            trailing: item.vencido
                ? const Text(
                    'VENCIDO',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text('ok'),
          );
        },
      ),
    );
  }
}
