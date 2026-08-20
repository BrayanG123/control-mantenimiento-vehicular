import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('app arranca', (WidgetTester tester) async {
    await tester.pumpWidget(const MiApp());
    // solo chequea que no explote al inicio
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
