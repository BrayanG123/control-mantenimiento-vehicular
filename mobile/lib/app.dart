import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/dependencies/dependencias_aplicacion.dart';
import 'core/layout/marco_movil.dart';
import 'core/network/error_api.dart';
import 'core/theme/tema_aplicacion.dart';
import 'screens/acceso.dart';
import 'screens/alta_vehiculo.dart';
import 'screens/inicio.dart';
import 'screens/mi_vehiculo.dart';
import 'state/sesion_aplicacion.dart';

class MiApp extends StatefulWidget {
  const MiApp({super.key});

  @override
  State<MiApp> createState() => _MiAppState();
}

class _MiAppState extends State<MiApp> {
  late String? tokenRecuperacion;

  @override
  void initState() {
    super.initState();
    tokenRecuperacion = Uri.base.queryParameters['token_recuperacion'];
  }

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
        colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: teal),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return MarcoMovil(child: child ?? const SizedBox.shrink());
      },
      home: tokenRecuperacion == null
          ? const Home()
          : RestablecerContrasenaPantalla(
              token: tokenRecuperacion!,
              onFinalizado: () => setState(() => tokenRecuperacion = null),
            ),
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
    if (SesionAplicacion.haySesion) {
      chequear();
    } else {
      cargando = false;
    }
  }

  VoidCallback get _alSesion => () {
    Navigator.of(context).popUntil((route) => route.isFirst);
    chequear();
  };

  Future<void> chequear() async {
    setState(() {
      cargando = true;
      errorRed = null;
    });
    try {
      final v = await DependenciasAplicacion.vehiculoApi.obtenerVehiculo();
      setState(() {
        hayVehiculo = v != null;
        cargando = false;
      });
    } on ErrorApi catch (error) {
      if (error.codigoEstado == 401) {
        SesionAplicacion.cerrar();
        setState(() {
          cargando = false;
          hayVehiculo = false;
          errorRed = null;
        });
        return;
      }
      setState(() {
        errorRed = error.mensaje;
        hayVehiculo = false;
        cargando = false;
      });
    } catch (_) {
      setState(() {
        errorRed = 'No se pudo conectar con el backend';
        hayVehiculo = false;
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!SesionAplicacion.haySesion) {
      return BienvenidaPantalla(onSesion: _alSesion);
    }

    if (cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                ElevatedButton(
                  onPressed: chequear,
                  child: const Text('Reintentar'),
                ),
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
        onCerrarSesion: () {
          SesionAplicacion.cerrar();
          setState(() {
            tab = 0;
            hayVehiculo = false;
          });
        },
      );
    }

    void irA(int i) {
      setState(() {
        tab = i;
      });
    }

    final pantallas = [
      InicioPantalla(onAbrirVehiculo: () => irA(1)),
      MiVehiculoPantalla(
        onCerrarSesion: () {
          SesionAplicacion.cerrar();
          setState(() {
            tab = 0;
            hayVehiculo = false;
          });
        },
      ),
    ];

    final conSidebar =
        MediaQuery.sizeOf(context).width >= MarcoMovil.anchoTablet;

    void cerrarSesion() {
      SesionAplicacion.cerrar();
      setState(() {
        tab = 0;
        hayVehiculo = false;
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
                    child: BarraLateral(
                      tab: tab,
                      onTab: irA,
                      onCerrarSesion: cerrarSesion,
                    ),
                  ),
                  Expanded(child: pantallas[tab]),
                ],
              )
            : pantallas[tab],
      ),
      bottomNavigationBar: conSidebar
          ? null
          : _NavInferior(tab: tab, onTab: irA),
    );
  }
}

class BarraLateral extends StatelessWidget {
  const BarraLateral({
    super.key,
    required this.tab,
    required this.onTab,
    this.onCerrarSesion,
  });

  final int tab;
  final ValueChanged<int> onTab;
  final VoidCallback? onCerrarSesion;

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
              _item(indice: 0, icono: Icons.home, label: 'Inicio'),
              const SizedBox(height: 8),
              _item(
                indice: 1,
                icono: Icons.directions_car,
                label: 'Mi vehiculo',
              ),
              const Spacer(),
              if (onCerrarSesion != null)
                Semantics(
                  button: true,
                  label: 'Cerrar sesion',
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onCerrarSesion,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: muted, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Cerrar sesion',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: texto,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
    return TextButton(
      onPressed: () => onTab(indice),
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        backgroundColor: sel ? fondoSuave : Colors.transparent,
        foregroundColor: sel ? teal : texto,
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
    );
  }
}

class _NavInferior extends StatelessWidget {
  const _NavInferior({required this.tab, required this.onTab});

  final int tab;
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _boton(0, Icons.home, 'Inicio'),
              _boton(1, Icons.directions_car, 'Mi vehiculo'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _boton(int indice, IconData icono, String label) {
    final sel = tab == indice;
    return Expanded(
      child: TextButton(
        onPressed: () => onTab(indice),
        style: TextButton.styleFrom(
          foregroundColor: sel ? teal : muted,
          backgroundColor: sel ? fondoSuave : Colors.transparent,
          shape: const RoundedRectangleBorder(),
          padding: const EdgeInsets.symmetric(vertical: 6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 22),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
