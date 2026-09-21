import 'package:flutter/material.dart';

/// En ventanas chicas de escritorio se ve un marco de telefono (412 px).
/// Desde tablet (768) el ancho es real: ahi entra el sidebar de `03_Web`.
class MarcoMovil extends StatelessWidget {
  const MarcoMovil({super.key, required this.child});

  final Widget child;

  static const anchoTelefono = 412.0;
  static const anchoTablet = 768.0;

  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.sizeOf(context).width;
    if (anchoPantalla <= 600 || anchoPantalla >= anchoTablet) {
      return child;
    }

    final altoPantalla = MediaQuery.sizeOf(context).height;
    final alto = (altoPantalla - 32).clamp(640.0, 844.0);

    return ColoredBox(
      color: const Color(0xFFD7E3DF),
      child: Center(
        child: Container(
          width: anchoTelefono,
          height: alto,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(anchoTelefono, alto),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Login y bienvenida en tablet/web: hoja 412, no se estiran a 1280.
class HojaAcceso extends StatelessWidget {
  const HojaAcceso({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.sizeOf(context).width;
    if (anchoPantalla < MarcoMovil.anchoTablet) {
      return child;
    }

    final altoPantalla = MediaQuery.sizeOf(context).height;
    final alto = (altoPantalla - 32).clamp(640.0, 844.0);

    return ColoredBox(
      color: const Color(0xFFD7E3DF),
      child: Center(
        child: Container(
          width: MarcoMovil.anchoTelefono,
          height: alto,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}
