import 'package:flutter/material.dart';

import 'app.dart';
import 'state/sesion_aplicacion.dart';

export 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SesionAplicacion.hidratarAlArranque();
  runApp(const MiApp());
}
