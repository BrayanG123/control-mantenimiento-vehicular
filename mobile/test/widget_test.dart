import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';
import 'package:mobile/models/proximo_mantenimiento.dart';
import 'package:mobile/screens/registrar_mantenimiento.dart';

void main() {
  testWidgets('app arranca', (WidgetTester tester) async {
    await tester.pumpWidget(const MiApp());
    expect(find.text('Mantenimiento'), findsOneWidget);
    expect(find.text('Iniciar sesion'), findsOneWidget);
  });

  testWidgets('formulario de registro muestra km y fecha', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrarMantenimientoPantalla(
          tipo: 'aceite',
          kilometrajeActual: 12500,
          item: ProximoMantenimiento(
            tipo: 'aceite',
            ultimoKilometraje: null,
            proximoKilometraje: 5000,
            kilometrosRestantes: -7500,
            estaVencido: true,
            estado: 'vencido',
          ),
        ),
      ),
    );

    expect(find.text('Registrar servicio'), findsOneWidget);
    expect(find.text('Cambio de aceite'), findsWidgets);
    expect(find.text('Kilometraje del servicio'), findsOneWidget);
    expect(find.text('Fecha del servicio'), findsOneWidget);
    expect(find.text('12500'), findsOneWidget);
    expect(find.text('VENCIDO'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();

    expect(find.text('Guardar mantenimiento'), findsOneWidget);
  });

  testWidgets('campo de costo permite escribir y borrar con semantica activa', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        home: RegistrarMantenimientoPantalla(
          tipo: 'aceite',
          kilometrajeActual: 12500,
          item: ProximoMantenimiento(
            tipo: 'aceite',
            ultimoKilometraje: null,
            proximoKilometraje: 17500,
            kilometrosRestantes: 5000,
            estaVencido: false,
            estado: 'pendiente',
          ),
        ),
      ),
    );

    final campoCosto = find.byType(TextField).at(1);
    await tester.ensureVisible(campoCosto);
    await tester.tap(campoCosto);
    await tester.enterText(campoCosto, '180');
    await tester.pump();

    expect(find.text('180'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(campoCosto, '18');
    await tester.pump();

    expect(find.text('18'), findsOneWidget);
    expect(tester.takeException(), isNull);

    semantica.dispose();
  });
}
