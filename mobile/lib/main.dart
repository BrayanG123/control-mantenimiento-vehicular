import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'api.dart';
import 'pantallas/acceso.dart';
import 'pantallas/alta_vehiculo.dart';
import 'pantallas/inicio.dart';
import 'pantallas/mi_vehiculo.dart';
import 'marco_movil.dart';
import 'sesion.dart';
import 'tema.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  hidratarSesionAlArranque();
  SemanticsBinding.instance.ensureSemantics();
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de mantenimiento vehicular',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'),
      supportedLocales: const [Locale('es'), Locale('es', 'BO')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          primary: teal,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return MarcoMovil(child: child ?? const SizedBox.shrink());
      },
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
    hidratarSesionAlArranque();
    if (Sesion.haySesion) {
      chequear();
    } else {
      cargando = false;
    }
  }

  VoidCallback get _alSesion => () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        setState(() {});
      };

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
    if (!Sesion.haySesion) {
      return BienvenidaPantalla(onSesion: _alSesion);
    }

    if (cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
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
      MiVehiculoPantalla(
        onCerrarSesion: () {
          Sesion.cerrar();
          setState(() {
            tab = 0;
          });
        },
      ),
    ];

    final conSidebar =
        MediaQuery.sizeOf(context).width >= MarcoMovil.anchoTablet;

    void irA(int i) {
      setState(() {
        tab = i;
      });
    }

    return Scaffold(
      appBar: null,
      body: Semantics(
        role: SemanticsRole.main,
        explicitChildNodes: true,
        label: 'Contenido principal',
        child: conSidebar
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 240,
                    child: Semantics(
                      role: SemanticsRole.navigation,
                      explicitChildNodes: true,
                      label: 'Navegacion principal',
                      child: BarraLateral(tab: tab, onTab: irA),
                    ),
                  ),
                  Expanded(child: pantallas[tab]),
                ],
              )
            : pantallas[tab],
      ),
      bottomNavigationBar: conSidebar
          ? null
          : Semantics(
              role: SemanticsRole.navigation,
              explicitChildNodes: true,
              label: 'Navegacion principal',
              child: BottomNavigationBar(
                currentIndex: tab,
                onTap: irA,
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
            ),
    );
  }
}

class BarraLateral extends StatelessWidget {
  const BarraLateral({super.key, required this.tab, required this.onTab});

  final int tab;
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: fondoSuave,
                    child: Icon(Icons.two_wheeler, color: teal, size: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Control vehicular',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: texto,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _item(
                indice: 0,
                icono: Icons.home,
                label: 'Inicio',
              ),
              const SizedBox(height: 8),
              _item(
                indice: 1,
                icono: Icons.directions_car,
                label: 'Mi vehiculo',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required int indice,
    required IconData icono,
    required String label,
  }) {
    final sel = tab == indice;
    return Semantics(
      button: true,
      selected: sel,
      label: sel ? '$label, seleccionado' : label,
      child: Material(
        color: sel ? fondoSuave : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onTab(indice),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icono, color: sel ? teal : muted, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                      color: sel ? teal : texto,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
