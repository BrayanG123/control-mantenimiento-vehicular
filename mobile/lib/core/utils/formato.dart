const _meses = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

const _titulos = {
  'aceite': 'Cambio de aceite',
  'llantas': 'Rotacion de neumaticos',
  'frenos': 'Pastillas de freno',
  'filtros': 'Filtro de aire',
  'cadena': 'Cadena (reparacion)',
};

String formatearMiles(int numero) {
  final s = numero.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final resto = s.length - i;
    if (i != 0 && resto % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

String formatearFecha(DateTime fecha) {
  return '${fecha.day} ${_meses[fecha.month - 1]} ${fecha.year}';
}

String obtenerTituloMantenimiento(String tipo) {
  return _titulos[tipo] ?? tipo[0].toUpperCase() + tipo.substring(1);
}

String motivoDelIntervalo(String tipo) {
  switch (tipo) {
    case 'aceite':
      return '4.000 km asume uso mixto. Con ~200 km/dia se consume en ~20 dias y puede quedar corto para tu ritmo.';
    case 'frenos':
      return '15.000 km es el promedio de fabrica. Si frenas seguido en ciudad, conviene acortarlo.';
    case 'llantas':
      return '20.000 km asume uso normal. En ciudad el caucho se gasta antes.';
    case 'filtros':
      return '10.000 km es el promedio. Con polvo o uso diario conviene bajarlo.';
    default:
      return 'Es el intervalo de fabrica. Podes acortarlo si usas el vehiculo todos los dias.';
  }
}

bool fechaPerteneceAlPeriodo(DateTime fecha, String periodo) {
  final now = DateTime.now();
  final f = DateTime(fecha.year, fecha.month, fecha.day);
  if (periodo == 'todo') return true;
  if (periodo == '3_meses') {
    final corte = now.subtract(const Duration(days: 90));
    return !f.isBefore(DateTime(corte.year, corte.month, corte.day));
  }
  return f.year == now.year;
}
