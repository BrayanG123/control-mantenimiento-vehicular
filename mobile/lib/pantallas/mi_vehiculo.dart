import 'package:flutter/material.dart';
import '../api.dart';
import '../modelos.dart';

class MiVehiculoPantalla extends StatefulWidget {
  const MiVehiculoPantalla({super.key});

  @override
  State<MiVehiculoPantalla> createState() => _MiVehiculoPantallaState();
}

class _MiVehiculoPantallaState extends State<MiVehiculoPantalla> {
  Vehiculo? vehiculo;
  String? error;
  bool cargando = true;
  final kmCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargar();
  }

  @override
  void dispose() {
    kmCtrl.dispose();
    super.dispose();
  }

  Future<void> cargar() async {
    setState(() {
      cargando = true;
      error = null;
    });
    try {
      final v = await obtenerVehiculo();
      setState(() {
        vehiculo = v;
        if (v != null) {
          kmCtrl.text = v.kilometraje_actual.toString();
        }
        cargando = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = 'Error al cargar vehiculo';
        cargando = false;
      });
    }
  }

  Future<void> guardarKm() async {
    final km = int.tryParse(kmCtrl.text);
    if (km == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('pone un numero')),
      );
      return;
    }

    try {
      final v = await actualizarKm(km);
      setState(() {
        vehiculo = v;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ok')),
        );
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('no se pudo actualizar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null || vehiculo == null) {
      return Center(child: Text(error ?? 'sin vehiculo'));
    }

    final v = vehiculo!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Marca: ${v.marca}', style: const TextStyle(fontSize: 18)),
          Text('Modelo: ${v.modelo}', style: const TextStyle(fontSize: 18)),
          Text('Anio: ${v.anio}', style: const TextStyle(fontSize: 18)),
          Text('Placa: ${v.placa ?? '-'}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Km actual: ${v.kilometraje_actual}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text('Actualizar kilometraje'),
          TextField(
            controller: kmCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ej: 6000',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: guardarKm,
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}
