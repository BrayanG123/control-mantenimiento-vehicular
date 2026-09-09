import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';
import 'package:mobile/modelos.dart';
import 'package:mobile/pantallas/registrar_mantenimiento.dart';

void main() {
  testWidgets('app arranca', (WidgetTester tester) async {
    await tester.pumpWidget(const MiApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('formulario de registro muestra km y fecha', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrarMantenimientoPantalla(
          tipo: 'aceite',
          kilometrajeActual: 12500,
          item: ProximoItem(
            tipo: 'aceite',
            ultimo_kilometraje: null,
            proximo_kilometraje: 5000,
            kilometrajes_restantes: -7500,
            vencido: true,
          ),
        ),
      ),
    );

    expect(find.text('Registrar servicio'), findsOneWidget);
    expect(find.text('Cambio de aceite'), findsWidgets);
    expect(find.text('Kilometraje del servicio'), findsOneWidget);
    expect(find.text('Fecha del servicio'), findsOneWidget);
    expect(find.text('Guardar mantenimiento'), findsOneWidget);
    expect(find.text('12500'), findsOneWidget);
    expect(find.text('VENCIDO'), findsOneWidget);
  });
}
