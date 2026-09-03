import 'package:flutter/material.dart';
import 'api.dart';
import 'pantallas/alta_vehiculo.dart';
import 'pantallas/inicio.dart';
import 'pantallas/mi_vehiculo.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mantenimiento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool cargando = true;
  bool hayVehiculo = false;
  String? errorRed;
  int tab = 0;

  @override
  void initState() {
    super.initState();
    chequear();
  }

  Future<void> chequear() async {
    setState(() {
      cargando = true;
      errorRed = null;
    });
    try {
      final v = await obtenerVehiculo();
      setState(() {
        hayVehiculo = v != null;
        cargando = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        errorRed = e.toString();
        hayVehiculo = false;
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorRed != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No conecta con el backend'),
                const SizedBox(height: 8),
                Text(errorRed!, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                const Text('proba: adb reverse tcp:8000 tcp:8000'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: chequear, child: const Text('Reintentar')),
                TextButton(
                  onPressed: () {
                    setState(() {
                      errorRed = null;
                      hayVehiculo = false;
                    });
                  },
                  child: const Text('Ir a registrar igual'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!hayVehiculo) {
      return AltaVehiculoPantalla(
        onCreado: () {
          setState(() {
            hayVehiculo = true;
          });
        },
      );
    }

    final pantallas = [
      const InicioPantalla(),
      const MiVehiculoPantalla(),
    ];

    return Scaffold(
      appBar: null,
      body: pantallas[tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Mi vehiculo',
          ),
        ],
      ),
    );
  }
}
