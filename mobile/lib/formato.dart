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
};

String fmtMiles(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final resto = s.length - i;
    if (i != 0 && resto % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

String fmtFecha(DateTime fecha) {
  return '${fecha.day} ${_meses[fecha.month - 1]} ${fecha.year}';
}

String tituloTipo(String tipo) {
  return _titulos[tipo] ?? tipo[0].toUpperCase() + tipo.substring(1);
}
