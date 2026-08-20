import 'package:flutter/material.dart';
import '../api.dart';

class AltaVehiculoPantalla extends StatefulWidget {
  final VoidCallback onCreado;

  const AltaVehiculoPantalla({super.key, required this.onCreado});

  @override
  State<AltaVehiculoPantalla> createState() => _AltaVehiculoPantallaState();
}

class _AltaVehiculoPantallaState extends State<AltaVehiculoPantalla> {
  final marcaCtrl = TextEditingController(text: 'Honda');
  final modeloCtrl = TextEditingController(text: 'CB 150');
  final anioCtrl = TextEditingController(text: '2021');
  final placaCtrl = TextEditingController(text: 'ABC-123');
  bool guardando = false;

  @override
  void dispose() {
    marcaCtrl.dispose();
    modeloCtrl.dispose();
    anioCtrl.dispose();
    placaCtrl.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    setState(() {
      guardando = true;
    });

    try {
      await crearVehiculo(
        marcaCtrl.text,
        modeloCtrl.text,
        int.parse(anioCtrl.text),
        placaCtrl.text,
      );
      widget.onCreado();
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('no se pudo crear')),
        );
      }
    }

    if (mounted) {
      setState(() {
        guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar vehiculo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: marcaCtrl,
              decoration: const InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              controller: modeloCtrl,
              decoration: const InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: anioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Anio'),
            ),
            TextField(
              controller: placaCtrl,
              decoration: const InputDecoration(labelText: 'Placa'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: guardando ? null : guardar,
              child: Text(guardando ? 'Guardando...' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
