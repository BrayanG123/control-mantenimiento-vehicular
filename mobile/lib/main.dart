import 'package:flutter/material.dart';

import 'app.dart';
import 'data/servicio_sesion_demo.dart';

export 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  hidratarSesionDemoAlArranque();
  runApp(const MiApp());
}
